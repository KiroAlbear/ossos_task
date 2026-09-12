import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ossos_task/core/utils/product_utils.dart';
import 'package:ossos_task/features/inventory_session/inventory_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late InventorySessionBloc bloc;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'storeId': '1'});
    bloc = InventorySessionBloc();
  });
  tearDown(() => bloc.close());

  Future<ProductsProgressState> loadSubmitted() async {
    final loaded = bloc.stream.firstWhere(
      (state) =>
          state is ProductsProgressState && !state.isLoadingSubmittedProducts,
    );
    bloc.add(const GetSubmittedProductsEvent());
    return await loaded as ProductsProgressState;
  }

  test(
    'pending sync follows saved products and hides again after deletion',
    () async {
      expect((await loadSubmitted()).hasSubmittedProducts, isFalse);
      await ProductUtils().saveSubmittedProducts([
        {
          'productId': 101,
          'name': 'Scanner',
          'countedQuantity': 18,
          'expectedVersion': 5,
        },
      ]);
      final saved = await loadSubmitted();
      expect(saved.hasSubmittedProducts, isTrue);
      expect(saved.submittedProducts.single.name, 'Scanner');
      expect(saved.submittedProductsError, isNull);
      final deleting = bloc.stream.firstWhere(
        (state) =>
            state is ProductsProgressState && state.isDeletingSubmittedProducts,
      );
      final deleted = bloc.stream.firstWhere(
        (state) =>
            state is ProductsProgressState &&
            !state.isDeletingSubmittedProducts,
      );
      bloc.add(const DeleteSubmittedProductsEvent());
      expect(
        (await deleting as ProductsProgressState).hasSubmittedProducts,
        isTrue,
      );
      expect(
        (await deleted as ProductsProgressState).hasSubmittedProducts,
        isFalse,
      );
      expect(await ProductUtils().getSubmittedProducts(), isEmpty);
    },
  );

  test('bad stored data reports an error and permits another load', () async {
    await const FlutterSecureStorage().write(
      key: 'submitted_product_counts_1',
      value: 'invalid json',
    );
    final failed = await loadSubmitted();
    expect(failed.submittedProductsError, isNotNull);
    expect(failed.hasSubmittedProducts, isFalse);
    await ProductUtils().deleteSubmittedProducts();
    final retried = await loadSubmitted();
    expect(retried.submittedProductsError, isNull);
    expect(retried.isLoadingSubmittedProducts, isFalse);
  });
}
