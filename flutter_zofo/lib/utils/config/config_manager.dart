// Package imports:
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:flutter_zofo/config/theme_config.dart';

class ConfigManager {
  SharedPreferences? _prefs;

  final Rx<ThemeConfig> themeConfig = ThemeConfig().obs;

  ConfigManager() {
    Future.sync(() => initAsync());
  }

  Future<void> initAsync() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Set<String>?> getKeysAsync() async {
    if (_prefs == null) {
      await initAsync();
    }

    return _prefs?.getKeys();
  }

  Future<T?> readAsync<T>(String key, {T? fallback, bool checkType = false}) async {
    if (_prefs == null) {
      await initAsync();
    }

    if (checkType) {
      if (T is String) {
        return (_prefs?.getString(key) as T) ?? fallback;
      } else if (T is List<String>) {
        return (_prefs?.getStringList(key) as T) ?? fallback;
      } else if (T is bool) {
        return (_prefs?.getBool(key) as T) ?? fallback;
      } else if (T is int) {
        return (_prefs?.getInt(key) as T) ?? fallback;
      } else if (T is double) {
        return (_prefs?.getDouble(key) as T) ?? fallback;
      }
    }

    return (_prefs?.get(key) as T) ?? fallback;
  }

  T? quickRead<T>(String key) {
    return _prefs?.get(key) as T?;
  }

  Future<List<T>> readListAsync<T>(List<String> keys, {List<T> fallback = const [], bool checkType = false}) async {
    if (_prefs == null) {
      await initAsync();
    }

    final result = <T>[];
    var index = 0;
    for (String key in keys) {
      if (checkType) {
        if (T is String) {
          result.add(_prefs?.getString(key) as T ?? fallback[index]);
        } else if (T is List<String>) {
          result.add(_prefs?.getStringList(key) as T ?? fallback[index]);
        } else if (T is bool) {
          result.add(_prefs?.getBool(key) as T ?? fallback[index]);
        } else if (T is int) {
          result.add(_prefs?.getInt(key) as T ?? fallback[index]);
        } else if (T is double) {
          result.add(_prefs?.getDouble(key) as T ?? fallback[index]);
        }
      } else {
        result.add(_prefs?.get(key) as T ?? fallback[index]);
      }
      index++;
    }

    return result;
  }

  Future<String> readStringAsync(String key, {String fallback = ''}) async {
    if (_prefs == null) {
      await initAsync();
    }

    return _prefs?.getString(key) ?? fallback;
  }

  Future<List<String>> readStringListAsync(String key, {List<String> fallback = const []}) async {
    if (_prefs == null) {
      await initAsync();
    }

    return _prefs?.getStringList(key) ?? fallback;
  }

  Future<bool> readBoolAsync(String key, {bool fallback = false}) async {
    if (_prefs == null) {
      await initAsync();
    }

    return _prefs?.getBool(key) ?? fallback;
  }

  Future<int> readIntAsync(String key, {int fallback = 0}) async {
    if (_prefs == null) {
      await initAsync();
    }

    return _prefs?.getInt(key) ?? fallback;
  }

  Future<double> readDoubleAsync(String key, {double fallback = 0.0}) async {
    if (_prefs == null) {
      await initAsync();
    }

    return _prefs?.getDouble(key) ?? fallback;
  }

  Future<void> writeAsync<T>(String key, T value) async {
    if (_prefs == null) {
      await initAsync();
    }

    if (T is String) {
      await _prefs?.setString(key, value as String);
    } else if (T is List<String>) {
      await _prefs?.setStringList(key, value as List<String>);
    } else if (T is bool) {
      await _prefs?.setBool(key, value as bool);
    } else if (T is int) {
      await _prefs?.setInt(key, value as int);
    } else if (T is double) {
      await _prefs?.setDouble(key, value as double);
    } else {
      throw Exception('Unsupported type: ${T.toString()}');
    }
  }
}
