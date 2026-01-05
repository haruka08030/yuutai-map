import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches a URL in an in-app web view and shows a SnackBar on failure.
///
/// This function attempts to launch the given URL in an in-app web view,
/// allowing users to easily return to the app using the back button.
/// If the launch fails, it displays an error message to the user.
Future<void> launchURL(String url, BuildContext context) async {
  try {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('リンクを開けませんでした')));
      }
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('リンクを開けませんでした')));
    }
  }
}
