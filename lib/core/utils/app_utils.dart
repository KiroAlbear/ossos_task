import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ossos_task/imports.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  static bool validateString(String text, String regex) {
    return RegExp(regex).hasMatch(text);
  }

  static Future<bool> isConnectedToInternet() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    final bool hasNetworkConnection = connectivityResult.any(
      (ConnectivityResult result) => result != ConnectivityResult.none,
    );

    if (!hasNetworkConnection) {
      return false;
    }

    try {
      final List<InternetAddress> lookupResult = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      return lookupResult.isNotEmpty &&
          lookupResult.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static String getLocalizedDate(String date) {
    // convert string to date
    DateTime dateTime = DateTime.parse(date);
    // convert date to local date
    String localDate = DateFormat('EEEE dd MMMM yyyy', 'ar').format(dateTime);
    return localDate;
  }

  static (bool, List<T>) getPaginationData<T>(
    List<T> data,
    List<T>? currentData,
    bool isLoadingMore,
    int pageSize,
  ) {
    bool isEndOfList = false;

    if (isLoadingMore && currentData != null) {
      currentData.addAll(data);
    } else {
      currentData = data;
    }
    isEndOfList = data.length < pageSize;
    return (isEndOfList, currentData);
  }

  static Future<void> showDatePickerDialog({
    required BuildContext context,
    required Function(DateRangePickerSelectionChangedArgs) onSelectionChanged,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CustomDateRangePickerDialog(
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            onSelectionChanged(args);
            Navigator.pop(ctx);
          },
        );
      },
    );
  }

  static void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  static List<T> convertJsonList<T>(
    dynamic data,
    Function(Map<String, dynamic>) fromJson,
  ) {
    List<Map<String, dynamic>> result = data.cast<Map<String, dynamic>>();
    List<T> list = [];

    for (var i = 0; i < result.length; i++) {
      list.add(fromJson(result[i]));
    }
    return list;
  }

  static Future<(double?, double?)> requestLocationPermssion() async {
    // check if android platform

    final value = await Geolocator.checkPermission();

    if (value == LocationPermission.denied ||
        value == LocationPermission.deniedForever) {
      final value2 = await Geolocator.requestPermission();
      if (value2 == LocationPermission.denied ||
          value2 == LocationPermission.deniedForever) {
        // Permission is denied
        return (null, null);
      } else if (value2 == LocationPermission.whileInUse ||
          value2 == LocationPermission.always) {
        return await _requestEnablingGPS();
      }
    } else if (value == LocationPermission.whileInUse ||
        value == LocationPermission.always) {
      return await _requestEnablingGPS();
    }

    return (null, null);
  }

  static Future<(double?, double?)> _requestEnablingGPS() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return (position.latitude, position.longitude);
    } catch (e) {
      return (null, null);
    }
  }

  static void showAppToast({
    required BuildContext context,
    required String message,
    Duration autoCloseDuration = const Duration(seconds: 3),
    Color backgroundColor = StaticColors.red_808,
  }) {
    toastification.dismissAll();
    toastification.showCustom(
      context: context,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: autoCloseDuration,
      animationDuration: const Duration(milliseconds: 250),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.35),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      builder: (context, holder) {
        return ToastWidget(message: message, backgroundColor: backgroundColor);
      },
    );
  }

  static Future<void> showAppBottomSheet({
    required BuildContext context,
    required Widget child,
    double? height,
  }) async {
    await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      context: context,
      builder: (context) {
        return CustomBottomSheet(height: height, child: child);
      },
    );
  }
}
