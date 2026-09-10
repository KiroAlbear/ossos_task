import 'package:flutter/material.dart';
import 'package:ossos_task/imports.dart';

class Logger {
  static void log(
    String logMessage, {
    String name = "AppLogger...",
    dynamic loggedData = '',
  }) {
    if (AppConfigs.isProductionEnv()) return;
    debugPrint('$name *********** $logMessage');
  }

  static void logTrace(
    dynamic name,
    dynamic error,
    dynamic stackTrace, {
    String functionName = '',
  }) {
    if (AppConfigs.isProductionEnv()) return;
    debugPrint('$name ******* $functionName *****  $error, $stackTrace');
  }
}
