import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/presentation/helpers/timetable_formatters.dart';
import 'package:flutter/material.dart';

/// Timetable list showing live and merchandise slots per artist.
class TimetableScanPerformanceListCard extends StatelessWidget {
  /// Creates the performance list card.
  const TimetableScanPerformanceListCard({
    required this.scanResult,
    required this.selectedSlotIndices,
    required this.onToggleSlot,
    required this.onSelectAllSlots,
    required this.onClearAllSlots,
    super.key,
  });

  /// Parsed OCR result containing the timetable schedules.
  final TimetableScanResult? scanResult;

  /// Indices into [scanResult!.schedules] for selected rows.
  ///
  /// Each row is independent.
  final Set<int> selectedSlotIndices;

  /// Toggles whether the schedule at the given index is selected.
  final void Function(int index, {required bool isSelected}) onToggleSlot;

  /// Selects all parsed slots.
  final void Function() onSelectAllSlots;

  /// Clears all parsed slots.
  final void Function() onClearAllSlots;

  @override
  Widget build(BuildContext context) {
    final schedules =
        scanResult?.schedules ?? const <TimetableArtistSchedule>[];
    final visibleSchedules = [
      for (var i = 0; i < schedules.length; i++)
        if (selectedSlotIndices.contains(i)) schedules[i],
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ライブ / 物販タイムテーブル',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (schedules.isEmpty) const Text('タイムテーブルを検出するとここに表示します。'),
            if (schedules.isNotEmpty) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '表示中 ${visibleSchedules.length} / ${schedules.length} 組',
                    ),
                  ),
                  TextButton(
                    key: const ValueKey('select-all-slots-button'),
                    onPressed: onSelectAllSlots,
                    child: const Text('全選択'),
                  ),
                  TextButton(
                    key: const ValueKey('clear-all-slots-button'),
                    onPressed: onClearAllSlots,
                    child: const Text('全解除'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _SelectionPanel(
                schedules: schedules,
                selectedSlotIndices: selectedSlotIndices,
                onToggleSlot: onToggleSlot,
              ),
              const SizedBox(height: 16),
              if (visibleSchedules.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('表示対象のグループがありません。チェックをONにしてください。'),
                ),
            ],
            for (final schedule in visibleSchedules)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DecoratedBox(
                  key: ValueKey('artist-schedule-${schedule.slotNumber}'),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schedule.artistName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _ScheduleDetailRow(
                          icon: Icons.music_note_outlined,
                          label: 'ライブ',
                          value: schedule.performance.timeLabel,
                        ),
                        if (schedule.merchandise case final merchandise?)
                          _ScheduleDetailRow(
                            icon: Icons.shopping_bag_outlined,
                            label: merchandise.boothLabelText,
                            value: merchandise.timeLabel,
                          )
                        else
                          const _ScheduleDetailRow(
                            icon: Icons.shopping_bag_outlined,
                            label: '特典会',
                            value: '未取得',
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectionPanel extends StatelessWidget {
  const _SelectionPanel({
    required this.schedules,
    required this.selectedSlotIndices,
    required this.onToggleSlot,
  });

  final List<TimetableArtistSchedule> schedules;
  final Set<int> selectedSlotIndices;
  final void Function(int index, {required bool isSelected}) onToggleSlot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            for (var i = 0; i < schedules.length; i++) ...[
              _FilterChip(
                key: ValueKey('artist-filter-$i'),
                schedule: schedules[i],
                index: i,
                isSelected: selectedSlotIndices.contains(i),
                onToggle: onToggleSlot,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.schedule,
    required this.index,
    required this.isSelected,
    required this.onToggle,
    super.key,
  });

  final TimetableArtistSchedule schedule;
  final int index;
  final bool isSelected;
  final void Function(int index, {required bool isSelected}) onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD7DEE6)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                key: ValueKey('artist-filter-checkbox-$index'),
                value: isSelected,
                onChanged: (value) => onToggle(
                  index,
                  isSelected: value ?? false,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.artistName,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule.performance.timeLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleDetailRow extends StatelessWidget {
  const _ScheduleDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
