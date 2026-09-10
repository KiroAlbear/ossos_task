import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../imports.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

abstract class BaseStatefullState<T extends BaseStatefulWidget> extends State<T>
    with RouteAware, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldMessengerState? _scaffoldMessengerState;
  bool _ignoreProgrammaticPop = false;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  ValueNotifier<bool> isNetworkConnected = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: statusBarColor(),
          systemNavigationBarColor: systemNavigationBarColor(),
          // IOS only brightness
          systemNavigationBarContrastEnforced: false,
          statusBarBrightness: statusBarBrightness() ?? Brightness.dark,
          statusBarIconBrightness: statusBarBrightness() ?? Brightness.dark,
        ),
      );
    }

    // _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
    //   results,
    // ) {
    //   if (results.contains(ConnectivityResult.none) &&
    //       isNetworkConnected.value) {
    //     isNetworkConnected.value = false;
    //   } else if (!results.contains(ConnectivityResult.none) &&
    //       !isNetworkConnected.value) {
    //     isNetworkConnected.value = true;
    //   }
    // });
  }

  Color? customBackgroundColor() => Colors.transparent;

  bool useCustomScaffold() => false;

  bool canPop() => false;

  bool isSafeArea() => false;

  bool isBottomSafeArea() => true;

  bool? showAppbarBackArrow() => null;

  PreferredSizeWidget? appBar() => null;

  Color? statusBarColor() => Colors.transparent;

  Color? systemNavigationBarColor() => Colors.white;

  double appTopPadding() => 0;

  double appPagePadding() => 16.0;

  String? appBarTitle() => null;

  Brightness? statusBarBrightness() => null;

  @protected
  Future<void> runWithoutBackAlert(FutureOr<void> Function() action) async {
    _ignoreProgrammaticPop = true;

    try {
      await Future.sync(action);
    } finally {
      await WidgetsBinding.instance.endOfFrame;

      if (mounted) {
        _ignoreProgrammaticPop = false;
      }
    }
  }

  // void changeSystemNavigationBarColor() {
  //   if (Platform.isAndroid) {
  //     SystemChrome.setSystemUIOverlayStyle(
  //       SystemUiOverlayStyle(
  //         systemNavigationBarColor: systemNavigationBarColor(),
  //         statusBarBrightness: Brightness.dark,
  //         statusBarIconBrightness: Brightness.dark,
  //       ),
  //     );
  //   }
  // }
  //
  // void changeSystemNavigationBarAndStatusColor() {
  //   if (Platform.isAndroid) {
  //     SystemChrome.setSystemUIOverlayStyle(
  //       SystemUiOverlayStyle(
  //         statusBarColor: statusBarColor(),
  //         systemNavigationBarColor: systemNavigationBarColor(),
  //         statusBarBrightness: Brightness.dark,
  //         statusBarIconBrightness: Brightness.dark,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop(),
      onPopInvokedWithResult: (didPop, result) {
        if (_ignoreProgrammaticPop) {
          return;
        }

        onPopInvoked(didPop);
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isNetworkConnected,
        builder: (context, isConnected, child) {
          if (!isConnected) {
            return const NoInternetPage();
          } else {
            return useCustomScaffold()
                ? _safeAreaBody
                : Scaffold(
                    bottomNavigationBar: customBottomNavBar(),

                    resizeToAvoidBottomInset: true,
                    // extendBodyBehindAppBar: true,
                    // extendBody: true,
                    primary: true,
                    // restorationId: ConstantModule.appTitle,
                    key: scaffoldKey,
                    backgroundColor:
                        customBackgroundColor() == Colors.transparent
                        ? GenericColors.getColors(
                            context,
                            GenericColors.white_blueC33_scaffold_background,
                          )
                        : Colors.white,
                    appBar: appBar() == null
                        ? appBarTitle() != null
                              ? CustomAppar(
                                  title: appBarTitle()!,
                                  withBackArrow:
                                      showAppbarBackArrow() ??
                                      Navigator.canPop(context),
                                )
                              : null
                        : null,
                    body: Container(
                      padding: EdgeInsets.only(
                        top: appTopPadding(),
                        right: appPagePadding(),
                        left: appPagePadding(),
                      ),

                      child: _safeAreaBody,
                    ),
                    // )
                  );
          }
        },
      ),
    );
  }

  void onPopInvoked(bool didPop) async {
    if (didPop) {
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      await handleCloseApplication(context);
    }
  }

  static Future<void> handleCloseApplication(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await showModalBottomSheet(
        backgroundColor: GenericColors.getColors(
          context,
          GenericColors.white_blue148,
        ),
        context: Routes.rootNavigatorKey.currentContext!,
        builder: (context) {
          return DialogWidget(
            message: "Are you sure you want to exit the app?",
            cancelMessage: "Cancel",
            confirmMessage: "Ok",
            onCancel: () {},
            onConfirm: () {
              exit(0);
            },
          );
        },
      );
    });
  }

  Widget get _defaultBody => getBody(context);

  Widget get _safeAreaBody {
    if (!isSafeArea()) {
      return _defaultBody;
    }

    return SafeArea(bottom: isBottomSafeArea(), child: _defaultBody);
  }

  void hideKeyboard() {
    if (Platform.isIOS || Platform.isAndroid) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  Widget getBody(BuildContext context);

  Widget? customBottomNavBar() {
    return null;
  }

  Widget? customFloatActionButton() {
    return null;
  }

  @override
  void dispose() {
    _scaffoldMessengerState?.hideCurrentMaterialBanner();
    _connectivitySubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
