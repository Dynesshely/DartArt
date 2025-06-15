// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

class I18nManager {
  String? _languageCode;

  set languageCodeProperty(String? code) {
    _languageCode = code;
    var codes = _languageCode?.split('-') ?? ['en', 'US'];
    Get.updateLocale(Locale(codes[0], codes[1]));
  }

  Locale? get getLanguageCode {
    if (_languageCode == null) return null;

    var codes = _languageCode?.split('-') ?? ['en', 'US'];
    return Locale(codes[0], codes[1]);
  }
}
