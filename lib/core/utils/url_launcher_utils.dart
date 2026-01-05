import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Launches a URL and shows a SnackBar on failure.
/// 
/// This function attempts to launch the given URL. If the launch fails,
/// it displays an error message to the user.
Future<void> launchURL(String url, BuildContext context) async {
  if (!await launchUrl(Uri.parse(url))) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('リンクを開けませんでした')),
      );
    }
  }
}
