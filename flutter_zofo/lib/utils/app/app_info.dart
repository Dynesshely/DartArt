// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:flutter_zofo/contracts/late_initializable.dart';
import 'package:flutter_zofo/utils/app/version_info.dart';
import 'package:flutter_zofo/utils/instances_manager.dart';

class AppInfo extends LateInitializable {
  late final String appName;

  Rx<VersionInfo>? versionInfo;

  bool get isRelease => VersionInfo.isRelease;
  bool get isDebug => !isRelease;

  @override
  Future<AppInfo> initAsync() async {
    await instances.get(DefaultInstances.packageInfo).then((value) {
      final result = VersionInfo(version: value.version, versionCode: value.buildNumber, versionString: '${value.version}${(VersionInfo.isRelease ? ' (Release)' : ' (Debug)')}');
      if (versionInfo == null) {
        versionInfo = Rx<VersionInfo>(result);
      } else {
        versionInfo!.value = result;
      }
    });

    return this;
  }
}
