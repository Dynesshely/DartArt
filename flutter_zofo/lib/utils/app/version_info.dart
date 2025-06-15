class VersionInfo {
  final String version;
  final String versionCode;
  final String versionString;

  const VersionInfo({required this.version, required this.versionCode, required this.versionString});

  /// ### Compiled Time Data ###
  static bool get isRelease => bool.fromEnvironment('dart.vm.product');
  static bool get isDebug => !isRelease;
}
