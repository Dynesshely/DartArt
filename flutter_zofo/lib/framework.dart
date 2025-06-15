// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Project imports:
import 'package:flutter_zofo/themes/theme_manager.dart';
import 'package:flutter_zofo/utils/app/app_info.dart';
import 'package:flutter_zofo/utils/config/config_manager.dart';
import 'package:flutter_zofo/utils/empty_instance.dart';
import 'package:flutter_zofo/utils/instances_manager.dart';
import 'package:flutter_zofo/utils/url/url_handler.dart';

class ZofoFramework {
  static final ZofoFramework _singleton = ZofoFramework._internal();

  factory ZofoFramework() {
    return _singleton;
  }

  const ZofoFramework._internal();

  static const String name = 'flutter_zofo';

  /// If you want manually initialize instances, you shouldn't call this method
  /// Instead, you can call [ensureInstancesAsync] method to initialize default instances
  Future<void> ensureInstancesAsync() async {
    instances = InstancesManager()
        .register(AppInfo(), DefaultInstances.appInfo)
        .register(ConfigManager(), DefaultInstances.config)
        .register(Connectivity(), DefaultInstances.connectivity)
        .register(EmptyInstance(), DefaultInstances.database)
        .register(EmptyInstance(), DefaultInstances.dataCache)
        .registerBuilder(() async => await PackageInfo.fromPlatform(), DefaultInstances.packageInfo)
        .register(ThemeManager(), DefaultInstances.theme)
        .register(UrlHandler(), DefaultInstances.urlHandler);

    await instances.initializeAllAsync();
  }

  Future<void> initAsync() async {
    // Initialize the framework
    // Register instances, configurations, etc.

    await ensureInstancesAsync();
  }
}

var zofo = ZofoFramework();
