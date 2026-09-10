import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ossos_task/gen/assets.gen.dart';
import 'package:ossos_task/imports.dart';

const String englishLanguageCode = 'en';
// const String arabicLanguageCode = 'ar';
// const String frenchLanguageCode = 'fr';

class LocalizationController {
  static LocalizationController? _instance;

  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  Map<String, dynamic>? _localizedStrings;

  Locale? locale = Locale('en', 'US');

  static LocalizationController getInstance() {
    return _instance ??= LocalizationController();
  }

  Future<Map<String, dynamic>> getApiLocalizations(String languageCode) async {
    // try {
    // await Future.delayed(Duration(seconds: 15));
    throw Exception();
    // final result = await SetLanguageApi().getAllResourceStrings(languageCode);

    // final resourceStrings = json.encode(result);
    // await SharedPreferencesManager.setString(
    //     SharedPreferencesManager.appResourcesStrings, resourceStrings);
    // return resourceStrings;
    // } catch (onError) {
    //   return _localizedStrings = await _convertLocalizationToMap(languageCode);
    // }
  }

  Future<void> getResourceStringsFromSharedPref(String languageCode) async {
    try {
      dynamic result;
      bool isConnectedToInternet = await AppUtils.isConnectedToInternet();

      if (isConnectedToInternet) {
        result = await getApiLocalizations(languageCode);
        _localizedStrings = result is String
            ? json.decode(result) as Map<String, dynamic>
            : result as Map<String, dynamic>;
      } else {
        // result = await SharedPreferencesManager.getString(
        //   SharedPreferencesManager.appResourcesStrings,
        // );
        _localizedStrings = await _convertLocalizationToMap(languageCode);
      }
    } catch (onError) {
      _localizedStrings = await _convertLocalizationToMap(languageCode);
    }
  }

  Future<Map<String, dynamic>> _convertLocalizationToMap(
    String languageCode,
  ) async {
    final String assetPath = switch (languageCode) {
      englishLanguageCode => Assets.translations.appEn,
      _ => Assets.translations.appEn,
    };

    final String localizationJson = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> localizations =
        json.decode(localizationJson) as Map<String, dynamic>;

    return localizations;
  }

  String translate(BuildContext context, String key) {
    try {
      return _localizedStrings![key];
    } catch (error) {
      return '';
    }
  }

  // bool isRTL() {
  //   return locale?.languageCode == arabicLanguageCode;
  // }

  String getLanguage() {
    return locale!.languageCode;
  }

  Future<void> setup(Locale locale) async {
    this.locale = locale;

    await getResourceStringsFromSharedPref(this.locale!.languageCode);
  }
}

// class SetLanguageApi with ApiHelperMixin {
//   SetLanguageApi._privateConstructor();
//
//   static final SetLanguageApi _instance = SetLanguageApi._privateConstructor();
//
//   factory SetLanguageApi() {
//     return _instance;
//   }
//
//   Future<Map<String, dynamic>> getAllResourceStrings(String language) async {
//     try {
//       String url = Urls.getLocalizationStrings;
//       Map<String, dynamic> mappedData = await fetchData<Map<String, dynamic>>(
//         url,
//       );
//
//       return mappedData;
//     } catch (err) {
//       rethrow;
//     }
//   }
// }
