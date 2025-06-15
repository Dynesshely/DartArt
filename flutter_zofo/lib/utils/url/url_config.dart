// Package imports:
import 'package:url_launcher/url_launcher.dart';

class UrlConfig {
  final String url;
  final LaunchMode mode;
  final String? webOnlyWindowName;

  const UrlConfig(this.url, this.mode, this.webOnlyWindowName);
}
