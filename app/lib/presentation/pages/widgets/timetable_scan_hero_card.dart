import 'package:flutter/material.dart';

/// Hero section for the timetable scan screen.
class TimetableScanHeroCard extends StatelessWidget {
  /// Creates the hero card.
  const TimetableScanHeroCard({
    required this.statusMessage,
    required this.supportedFormatLabel,
    super.key,
  });

  /// Current OCR/import status shown in the highlighted panel.
  final String statusMessage;

  /// Supported timetable format label.
  final String supportedFormatLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFFF4647D),
            Color(0xFFE85BA6),
            Color(0xFF56C7C0),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(supportedFormatLabel),
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide.none,
            ),
            const SizedBox(height: 16),
            const Text(
              'タイムテーブルを\nGoogle Calendar 下書きへ。',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              <String>[
                '初回版は添付画像フォーマット専用です。',
                '画像から OCR を実行して抽出結果を表示し、',
                '出演者ごとにライブと物販の予定を確認できます。',
              ].join(' '),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        statusMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
