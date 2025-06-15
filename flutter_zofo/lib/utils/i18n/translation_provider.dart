// Package imports:
import 'package:get/get.dart';

class TranslationProvider implements Translations {
  var _translations = <String, Map<String, String>>{
    'en_US': {'hello': 'Hello', 'world': 'World'},
    'zh_CN': {'hello': '你好', 'world': '世界'},
  };

  Map<String, Map<String, String>> _getTranslations() {
    return _translations;
  }

  TranslationProvider setTranslations(Map<String, Map<String, String>> translations) {
    _translations = translations;
    return this;
  }

  TranslationProvider setLocale(String locale, Map<String, String> translations) {
    _translations[locale] = translations;
    return this;
  }

  TranslationProvider removeLocale(String locale) {
    if (_translations.containsKey(locale)) {
      _translations.remove(locale);
    }
    return this;
  }

  TranslationProvider clone() => TranslationProvider().setTranslations(_translations);

  @override
  Map<String, Map<String, String>> get keys => _getTranslations();
}
