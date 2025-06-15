// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:flutter_zofo/utils/url/url_config.dart';

class UrlHandler {
  final List<UrlConfig> history = [];

  Future<bool> openUrl(
    Uri url, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfig = const WebViewConfiguration(),
    BrowserConfiguration browserConfig = const BrowserConfiguration(),
    String? webOnlyWindowName,
  }) async {
    history.add(UrlConfig(url.toString(), mode, webOnlyWindowName));
    return await launchUrl(url, mode: mode, webViewConfiguration: webViewConfig, browserConfiguration: browserConfig, webOnlyWindowName: webOnlyWindowName);
  }

  Future<bool> openLink(String link, {LaunchMode mode = LaunchMode.inAppBrowserView}) async {
    final Uri url = Uri.parse(link);
    return await openUrl(url, mode: mode);
  }

  Future<bool> openLinkOutside(String link) async {
    return await openLink(link, mode: LaunchMode.externalApplication);
  }

  Future<bool> mailTo(String email, {String? subject, String? body}) async {
    final Uri decode = Uri.parse(email);
    final Uri emailUri = Uri(scheme: 'mailto', host: decode.host, port: decode.port, path: decode.path, queryParameters: {'subject': subject, 'body': body});

    return await openUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  Future<bool> call(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    return await openUrl(phoneUri, mode: LaunchMode.externalApplication);
  }

  Future<bool> sendSms(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    return await openUrl(smsUri, mode: LaunchMode.externalApplication);
  }

  Future<bool> openFile(String path) async {
    final Uri fileUri = Uri(scheme: 'file', path: path);
    return await openUrl(fileUri, mode: LaunchMode.externalApplication);
  }
}
