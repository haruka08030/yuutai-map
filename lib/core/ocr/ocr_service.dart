import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OcrResult {
  OcrResult(this.text, this.expiryDate);
  final String text;
  final DateTime? expiryDate;
}

class OcrService {
  Future<OcrResult?> pickAndRecognizeText() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }

    final textRecognizer = TextRecognizer();
    final recognizedText =
        await textRecognizer.processImage(InputImage.fromFilePath(image.path));
    await textRecognizer.close();

    final text = recognizedText.text;
    DateTime? expiryDate;

    // Simple date parsing
    final dateRegex = RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日');
    final match = dateRegex.firstMatch(text);
    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      expiryDate = DateTime(year, month, day);
    }
    return OcrResult(text, expiryDate);
  }
}
