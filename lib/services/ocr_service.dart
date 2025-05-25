import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../models/transaction.dart';

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer();

  static Future<TransactionModel?> scanReceipt(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Parse the recognized text to extract transaction details
      final extractedData = _parseReceiptText(recognizedText.text);
      
      if (extractedData != null) {
        return TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          description: extractedData['description'] ?? 'Receipt Purchase',
          amount: extractedData['amount'] ?? 0.0,
          type: TransactionType.expense,
          categoryId: '3', // Default to shopping
          date: extractedData['date'] ?? DateTime.now(),
          receiptUrl: imageFile.path,
        );
      }
    } catch (e) {
      print('OCR Error: $e');
    }
    
    return null;
  }

  static Map<String, dynamic>? _parseReceiptText(String text) {
    final lines = text.split('\n');
    double? amount;
    DateTime? date;
    String? description;

    // Look for amount patterns
    final amountRegex = RegExp(r'\$?(\d+\.?\d*)');
    final dateRegex = RegExp(r'(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})');

    for (final line in lines) {
      // Try to find amount
      if (amount == null) {
        final amountMatch = amountRegex.firstMatch(line);
        if (amountMatch != null) {
          amount = double.tryParse(amountMatch.group(1) ?? '');
        }
      }

      // Try to find date
      if (date == null) {
        final dateMatch = dateRegex.firstMatch(line);
        if (dateMatch != null) {
          try {
            final dateParts = dateMatch.group(1)!.split(RegExp(r'[\/\-]'));
            if (dateParts.length == 3) {
              date = DateTime(
                int.parse(dateParts[2]),
                int.parse(dateParts[0]),
                int.parse(dateParts[1]),
              );
            }
          } catch (e) {
            // Ignore date parsing errors
          }
        }
      }

      // Use first non-empty line as description
      if (description == null && line.trim().isNotEmpty) {
        description = line.trim();
      }
    }

    if (amount != null && amount > 0) {
      return {
        'amount': amount,
        'date': date ?? DateTime.now(),
        'description': description ?? 'Receipt Purchase',
      };
    }

    return null;
  }

  static void dispose() {
    _textRecognizer.close();
  }
}
