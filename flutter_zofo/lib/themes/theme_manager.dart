// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

class ThemeManager {
  var themeMode = ThemeMode.system.obs;

  ThemeMode get themeModeProperty => themeMode.value;

  set themeModeProperty(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  var material3enabled = true.obs;

  var animationEnabled = true.obs;
}
