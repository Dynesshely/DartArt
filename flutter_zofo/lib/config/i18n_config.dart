// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:flutter_zofo/utils/i18n/translation_provider.dart';

class I18nConfig {
  Rx<Locale?> locale = null.obs;
  RxList<Locale>? supportedLocales;

  I18nConfig setSupportedLocales({List<Locale> locales = const [Locale('en', 'US'), Locale('zh', 'CN'), Locale('ja', 'JP'), Locale('ko', 'KR')], useSpecificLocale = false, specificLocaleIndex = 0}) {
    supportedLocales = locales.obs;

    if (useSpecificLocale) {
      if (locales.length > specificLocaleIndex) {
        locale.value = locales[specificLocaleIndex];
      } else {
        locale.value = locales[0];
      }
    } else {
      locale.value = Get.deviceLocale;
    }
    return this;
  }

  Rx<TranslationProvider?> translation = TranslationProvider().obs;

  I18nConfig invokeTranslationUpdates() {
    translation.value = translation.value?.clone();
    return this;
  }

  I18nConfig setTranslationProvider(TranslationProvider provider) {
    translation.value = provider;
    return this;
  }
}
