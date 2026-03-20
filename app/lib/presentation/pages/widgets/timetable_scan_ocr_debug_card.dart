import 'package:flutter/material.dart';

/// Expandable card for showing raw OCR text.
class TimetableScanOcrDebugCard extends StatelessWidget {
  /// Creates the OCR debug card.
  const TimetableScanOcrDebugCard({
    required this.rawText,
    super.key,
  });

  /// Raw text returned by OCR before parsing.
  final String rawText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('OCR デバッグテキスト'),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(rawText),
        ],
      ),
    );
  }
}
