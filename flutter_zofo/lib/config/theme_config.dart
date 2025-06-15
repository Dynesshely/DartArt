// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

class ThemeConfig {
  Rx<ThemeData?> lightTheme = null.obs;
  Rx<ThemeData?> darkTheme = null.obs;
  Rx<bool> useMaterial3 = true.obs;
}
