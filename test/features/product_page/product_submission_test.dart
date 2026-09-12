import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ossos_task/core/utils/product_utils.dart';
import 'package:ossos_task/imports.dart';
import 'package:ossos_task/features/product_page/presentation/widgets/product_conflicts_sheet.dart';

class _ProductsRepository implements ProductPageRepository {
  @override
  Future<Either<Failure, ProductPageModel>> fetchProducts({
    required int page,
    int limit = 20,
  }) async => Right(
    ProductPageModel(
      data: [
        ProductModel(
          id: 101,
          name: 'Scanner',
          sku: 'SCN',
          barcode: '101',
          systemQuantity: 20,
          version: 5,
          updatedAt: DateTime.utc(2026),
        ),
      ],
      page: 1,
      totalPages: 1,
      totalItems: 1,
    ),
  );
}

class _SubmissionRepository implements InventorySessionRepository {
  final requests = <InventorySessionRequestModel>[];
  Future<Either<Failure, InventorySessionModel>> Function() respond =
      () async => const Right(InventorySessionModel(sessionId: 7));

  @override
  Future<Either<Failure, InventorySessionModel>> submitInventorySession(
    InventorySessionRequestModel request,
  ) {
    requests.add(request);
    return respond();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProductPageBloc bloc;
  late _SubmissionRepository submission;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      'product_counts_1': '{"101":18}',
    });
    submission = _SubmissionRepository();
    bloc = ProductPageBloc(
      ProductPageUseCase(_ProductsRepository()),
      InventorySessionUseCase(submission),
    );
  });
  tearDown(() => bloc.close());

  test(
    'saveSubmittedProducts persists all item fields for the selected store',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        'storeId': '1',
        'submitted_product_counts_1': '[]',
        'submitted_product_counts_2': '[]',
      });
      final items = <Map<String, dynamic>>[
        {
          'productId': 101,
          'name': 'Scanner',
          'countedQuantity': 18,
          'expectedVersion': 5,
        },
        {
          'productId': 102,
          'name': 'Printer',
          'countedQuantity': 0,
          'expectedVersion': 3,
        },
      ];

      await ProductUtils().saveSubmittedProducts(items);

      const storage = FlutterSecureStorage();
      final stored = await storage.read(key: 'submitted_product_counts_1');
      expect(stored, isNotNull);
      expect(jsonDecode(stored!), items);
      expect(
        (await ProductUtils().getSubmittedProducts())
            .map((item) => item.toJson())
            .toList(),
        items,
      );
      expect(await storage.read(key: 'submitted_product_counts_2'), '[]');
    },
  );

  test(
    'deleteSubmittedProducts removes only the selected store submitted items',
    () async {
      final saved = jsonEncode([
        {
          'productId': 101,
          'name': 'Scanner',
          'countedQuantity': 18,
          'expectedVersion': 5,
        },
      ]);
      FlutterSecureStorage.setMockInitialValues({
        'storeId': '1',
        'submitted_product_counts_1': saved,
        'submitted_product_counts_2': saved,
        'product_counts_1': '{"101":18}',
      });

      await ProductUtils().deleteSubmittedProducts();

      const storage = FlutterSecureStorage();
      expect(await storage.read(key: 'submitted_product_counts_1'), isNull);
      expect(await ProductUtils().getSubmittedProducts(), isEmpty);
      expect(await storage.read(key: 'submitted_product_counts_2'), saved);
      expect(await storage.read(key: 'product_counts_1'), '{"101":18}');
      expect(await storage.read(key: 'storeId'), '1');
    },
  );

  testWidgets('conflict sheet displays names and quantities and scrolls', (
    tester,
  ) async {
    final request = InventorySessionRequestModel(
      clientSessionId: 'sheet-test',
      storeId: 1,
      createdAt: DateTime.utc(2026),
      items: List.generate(
        15,
        (index) => InventorySessionItemModel(
          productId: index + 1,
          name: 'Product ${index + 1}',
          countedQuantity: 18,
          expectedVersion: 5,
        ),
      ),
    );
    final conflict = InventorySessionConflictModel(
      conflicts: request.items
          .map(
            (item) => InventorySessionConflictItemModel(
              productId: item.productId,
              expectedVersion: 5,
              currentVersion: 6,
              originalSystemQuantity: 20,
              currentSystemQuantity: 25,
              countedQuantity: 18,
            ),
          )
          .toList(),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppUtils.showAppBottomSheet(
                context: context,
                child: ProductConflictsSheet(
                  conflict: conflict,
                  request: request,
                ),
              ),
              child: const Text('Open conflicts'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open conflicts'));
    await tester.pumpAndSettle();
    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('Original system quantity'), findsWidgets);
    expect(find.text('Current system quantity'), findsWidgets);
    expect(find.text('Counted quantity'), findsWidgets);
    expect(find.text('20'), findsWidgets);
    expect(find.text('25'), findsWidgets);
    expect(find.text('18'), findsWidgets);
    await tester.scrollUntilVisible(find.text('Product 15'), 300);
    expect(find.text('Product 15'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  Future<void> restoreAndLoad() async {
    final restored = bloc.stream.firstWhere(
      (state) => state is ProductPageState && !state.isRestoring,
    );
    bloc.add(const RestoreProductCountsEvent('1'));
    await restored;
    final loaded = bloc.stream.firstWhere(
      (state) => state is ProductPageState && state.products.isNotEmpty,
    );
    bloc.add(const LoadProductsEvent());
    await loaded;
  }

  Future<ProductSubmissionState> submit() async {
    final result = bloc.stream.firstWhere(
      (state) =>
          state is ProductSubmissionState &&
          state is! ProductSubmissionLoadingState,
    );
    bloc.add(const SubmitProductCountEvent());
    return await result as ProductSubmissionState;
  }

  test('accepted submission sends actual products and clears draft and pending products', () async {
    await restoreAndLoad();
    expect(await submit(), isA<ProductSubmissionSuccessState>());
    final request = submission.requests.single;
    expect(request.storeId, 1);
    expect(request.clientSessionId, isNotEmpty);
    expect(request.items.single.name, 'Scanner');
    expect(request.items.single.productId, 101);
    expect(request.items.single.countedQuantity, 18);
    expect(request.items.single.expectedVersion, 5);
    expect(await ProductUtils().getProductsSharedPrefrences(), isEmpty);
    expect(await ProductUtils().getSubmittedProducts(), isEmpty);
  });

  test('failed submission retains counts and permits retry', () async {
    await restoreAndLoad();
    submission.respond = () async => const Left(CustomFailure('Offline'));
    final result = await submit() as ProductSubmissionErrorState;
    expect(result.message, 'Offline');
    expect(await ProductUtils().getProductsSharedPrefrences(), {101: 18});
    submission.respond = () async =>
        const Right(InventorySessionModel(sessionId: 7));
    expect(await submit(), isA<ProductSubmissionSuccessState>());
  });

  test('rejects incomplete counts before contacting the repository', () async {
    expect(await submit(), isA<ProductSubmissionErrorState>());
    expect(submission.requests, isEmpty);
  });

  test(
    'ignores duplicate submission events while a request is pending',
    () async {
      await restoreAndLoad();
      final pending = Completer<Either<Failure, InventorySessionModel>>();
      submission.respond = () => pending.future;
      final result = submit();
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SubmitProductCountEvent());
      await Future<void>.delayed(Duration.zero);
      expect(submission.requests, hasLength(1));
      pending.complete(const Right(InventorySessionModel(sessionId: 7)));
      expect(await result, isA<ProductSubmissionSuccessState>());
    },
  );
}
