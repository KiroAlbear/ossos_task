// ignore_for_file: public_member_api_docs, sort_constructors_first, always_specify_types
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ossos_task/features/add_product/add_product.dart';
import 'package:ossos_task/features/authentication/otp/data/otp_enum.dart';
import 'package:ossos_task/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:ossos_task/features/splash_screen.dart';
import 'package:ossos_task/imports.dart';

class Routes {
  Routes._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // SCREENS
  static const String splashScreen = '/';
  static const String testFeatureScreen = '/testFeatureScreen';
  static const String onboardingScreen = '/onboardingScreen';
  static const String loginScreen = '/loginScreen';
  static const String registrationScreen = '/registrationScreen';
  static const String otpScreen = '/otpScreen';
  static const String otpEnterPhoneScreen = '/otpEnterPhoneScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String forgotPasswordScreen = '/forgotPasswordScreen';
  static const String regionScreen = '/regionScreen';
  static const String homeScreen = '/homeScreen';
  static const String addProductScreen = '/addProductScreen';

  static final GoRouter goRouter = GoRouter(
    initialLocation: splashScreen,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      GoRoute(
        path: splashScreen,
        name: splashScreen,
        parentNavigatorKey: rootNavigatorKey,

        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, const SplashScreen()),
      ),
      GoRoute(
        path: testFeatureScreen,
        name: testFeatureScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, TestFeaturePage()),
      ),

      GoRoute(
        path: onboardingScreen,
        name: onboardingScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, OnboardingPage()),
      ),
      GoRoute(
        path: loginScreen,
        name: loginScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, LoginPage()),
      ),
      GoRoute(
        path: registrationScreen,
        name: registrationScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, RegistrationPage()),
      ),
      GoRoute(
        path: otpScreen,
        name: otpScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final OtpEnum? params = state.extra as OtpEnum?;
          return _fadeTransitionScreenWrapper(
            context,
            state,
            BlocProvider<OtpBloc>(create: (_) => getIt<OtpBloc>(),child: OtpPage(otpEnum: params ?? OtpEnum.email)),
          );
        },
      ),

      GoRoute(
        path: otpEnterPhoneScreen,
        name: otpEnterPhoneScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final OtpEnum? params = state.extra as OtpEnum?;
          return _fadeTransitionScreenWrapper(
            context,
            state,
            OtpEnterPhonePage(),
          );
        },
      ),
      GoRoute(
        path: resetPasswordScreen,
        name: resetPasswordScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, ResetPasswordPage()),
      ),

      GoRoute(
        path: forgotPasswordScreen,
        name: forgotPasswordScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, ForgotPasswordPage()),
      ),
      GoRoute(
        path: regionScreen,
        name: regionScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, RegionPage()),
      ),
      GoRoute(
        path: homeScreen,
        name: homeScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, HomePage()),
      ),

      GoRoute(
        path: addProductScreen,
        name: addProductScreen,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            _fadeTransitionScreenWrapper(context, state, AddProductPage()),
      ),
      // ShellRoute(
      //   builder: (BuildContext context, GoRouterState state, Widget child) {
      //     // print(GoRouterState.of(context).uri.toString());
      //
      //     print(GoRouter.of(context).routeInformationProvider.value.uri);
      //     int pageIndex = 0;
      //     if (state.fullPath != null) {
      //       if (state.fullPath!.contains(quranScreen)) {
      //         pageIndex = 0;
      //       } else if (state.fullPath!.contains(favoritesScreen)) {
      //         pageIndex = 1;
      //       } else if (state.fullPath!.contains(profileScreen)) {
      //         pageIndex = 3;
      //       } else if (state.fullPath!.contains(searchScreen)) {
      //         pageIndex = 4;
      //       } else {
      //         pageIndex = 2;
      //       }
      //     }
      //
      //     return BottomNavigationBar(
      //       items: [
      //         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.favorite),
      //           label: 'Favourite',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.add_shopping_cart_rounded),
      //           label: 'Cart',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person),
      //           label: 'Profile',
      //         ),
      //       ],
      //     );
      //   },
      //   routes: <RouteBase>[],
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
        await GoRouter.of(
          context,
        ).pushNamed(screenName, extra: arguments).whenComplete(() {
          if (afterComplete != null) {
            afterComplete();
          }
        });
        break;

      case NavigationType.goNamed:
        GoRouter.of(context).goNamed(screenName, extra: arguments);
        break;

      case NavigationType.pushReplacementNamed:
        await GoRouter.of(
          context,
        ).pushReplacementNamed(screenName, extra: arguments);
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
