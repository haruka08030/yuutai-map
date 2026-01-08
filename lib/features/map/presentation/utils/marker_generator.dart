import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerGenerator {
  Future<BitmapDescriptor> getMarkerBitmap(
    int size, {
    String? text,
    Color? color,
  }) async {
    if (kIsWeb) size = (size / 2).round();

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint1 = Paint()..color = color ?? Colors.orange;
    final paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          size / 2 - textPainter.width / 2,
          size / 2 - textPainter.height / 2,
        ),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);
    if (data == null) {
      throw Exception('Failed to convert image to byte data');
    }

    // ignore: deprecated_member_use
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
