import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ossos_task/core/routes/navigation_type.dart';
import 'package:ossos_task/features/store_selection/domain/use_cases/store_selection_usecase.dart';
import 'package:ossos_task/features/store_selection/presentation/blocs/store_selection_bloc.dart';
import 'package:ossos_task/features/store_selection/presentation/pages/store_selection_page.dart';
import 'package:ossos_task/features/test_feature/test_feature.dart';

import '../services/service_locator.dart';

class Routes {
  Routes._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // static const String testFeatureScreen = '/testFeatureScreen';
  static const String storeSelectionScreen = '/storeSelectionScreen';

  static final GoRouter goRouter = GoRouter(
    initialLocation: storeSelectionScreen,
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
          BlocProvider(
            create: (_) => StoreSelectionBloc(getIt<StoreSelectionUseCase>()),
            child: const StoreSelectionPage(),
          ),
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
