import 'package:flutter/material.dart';

/// Displays parser warnings for abnormal or partial OCR results.
class TimetableScanWarningsCard extends StatelessWidget {
  /// Creates the warnings card.
  const TimetableScanWarningsCard({
    required this.warnings,
    super.key,
  });

  /// Parser and validation warnings to surface to the user.
  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    if (warnings.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.errorContainer.withValues(alpha: 0.35),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '要確認',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final warning in warnings)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.report_gmailerrorred, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(warning)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
