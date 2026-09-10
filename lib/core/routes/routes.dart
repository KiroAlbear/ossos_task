import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ossos_task/core/routes/navigation_type.dart';
import 'package:ossos_task/features/test_feature/test_feature.dart';

class Routes {
  Routes._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static const String testFeatureScreen = '/testFeatureScreen';

  static final GoRouter goRouter = GoRouter(
    initialLocation: testFeatureScreen,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      GoRoute(path: '/', redirect: (context, state) => testFeatureScreen),
      GoRoute(
        path: testFeatureScreen,
        name: testFeatureScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _fadeTransitionScreenWrapper(
          context,
          state,
          BlocProvider(
            create: (_) => TestFeatureBloc(),
            child: const TestFeaturePage(),
          ),
        ),
      ),
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
