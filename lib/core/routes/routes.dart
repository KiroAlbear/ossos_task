import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ossos_task/core/routes/navigation_type.dart';
import 'package:ossos_task/features/store_selection/domain/use_cases/store_selection_usecase.dart';
import 'package:ossos_task/features/store_selection/presentation/blocs/store_selection_bloc.dart';
import 'package:ossos_task/features/store_selection/presentation/pages/store_selection_page.dart';
import 'package:ossos_task/features/test_feature/test_feature.dart';

import '../../features/inventory_session/presentation/blocs/inventory_session_bloc.dart';
import '../../features/inventory_session/presentation/pages/inventory_session.dart';
import '../../features/product_page/domain/use_cases/product_page_usecase.dart';
import '../../features/product_page/presentation/blocs/product_page_bloc.dart';
import '../../features/product_page/presentation/pages/product_page.dart';
import '../services/service_locator.dart';

class Routes {
  Routes._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // static const String testFeatureScreen = '/testFeatureScreen';
  static const String storeSelectionScreen = '/storeSelectionScreen';
  static const String productsScreen = '/productsScreen';
  static const String inventorySessionScreen = '/inventorySessionScreen';

  static final GoRouter goRouter = GoRouter(
    initialLocation: inventorySessionScreen,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      // GoRoute(path: '/', redirect: (context, state) => testFeatureScreen),
      GoRoute(
        path: storeSelectionScreen,
        name: storeSelectionScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _fadeTransitionScreenWrapper(
          context,
          state,
          const StoreSelectionPage(),
        ),
      ),

      GoRoute(
        path: productsScreen,
        name: productsScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _fadeTransitionScreenWrapper(
          context,
          state,
          const ProductPage(),
        ),
      ),

      GoRoute(
        path: inventorySessionScreen,
        name: inventorySessionScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _fadeTransitionScreenWrapper(
          context,
          state,
          const InventorySessionPage(),
        ),
      ),

      // GoRoute(
      //   path: testFeatureScreen,
      //   name: testFeatureScreen,
      //   parentNavigatorKey: rootNavigatorKey,
      //   pageBuilder: (context, state) => _fadeTransitionScreenWrapper(
      //     context,
      //     state,
      //     BlocProvider(
      //       create: (_) => TestFeatureBloc(),
      //       child: const TestFeaturePage(),
      //     ),
      //   ),
      // ),
    ],
  );

  static Future<void> navigateToScreen(
    String screenName,
    NavigationType navigationType,
    BuildContext context, {
    Object? arguments,
    Function()? afterComplete,
  }) async {
    if (screenName == "") {
      return;
    }
    switch (navigationType) {
      case NavigationType.pushNamed:
        await GoRouter.of(context)
            .pushNamed(screenName, extra: arguments)
            .whenComplete(() {
              if (afterComplete != null) {
                afterComplete();
              }
            });
        break;

      case NavigationType.goNamed:
        GoRouter.of(context).goNamed(screenName, extra: arguments);
        break;

      case NavigationType.pushReplacementNamed:
        await GoRouter.of(context)
            .pushReplacementNamed(screenName, extra: arguments);
        break;
    }
  }

  static void navigateToFirstScreen(BuildContext context) {
    while (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  static CustomTransitionPage<dynamic> _fadeTransitionScreenWrapper(
    BuildContext context,
    dynamic state,
    Widget screen,
  ) {
    return CustomTransitionPage(
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.linear).animate(animation),
              child: child,
            );
          },
      key: state.pageKey,
      child: screen,
    );
  }
}
