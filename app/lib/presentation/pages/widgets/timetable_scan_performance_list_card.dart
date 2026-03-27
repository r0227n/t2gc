import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/presentation/helpers/timetable_formatters.dart';
import 'package:app/presentation/pages/widgets/timetable_scan_stitch_tokens.dart';
import 'package:flutter/material.dart';

/// Stitch verify layout: editorial rows, left accent bar, row checkboxes.
class TimetableScanPerformanceListCard extends StatelessWidget {
  /// Creates the performance list card.
  const TimetableScanPerformanceListCard({
    required this.scanResult,
    required this.selectedSlotIndices,
    required this.onToggleSlot,
    required this.onSelectAllSlots,
    required this.onClearAllSlots,
  });

  /// Parsed OCR result containing the timetable schedules.
  final TimetableScanResult? scanResult;

  /// Indices into [scanResult!.schedules] for selected rows.
  final Set<int> selectedSlotIndices;

  /// Toggles whether the schedule at the given index is selected.
  final void Function(int index, {required bool isSelected}) onToggleSlot;

  /// Selects all parsed slots.
  final void Function() onSelectAllSlots;

  /// Clears all parsed slots.
  final void Function() onClearAllSlots;

  @override
  Widget build(BuildContext context) {
    final spacing = context.timetableScanSpacing;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final schedules =
        scanResult?.schedules ?? const <TimetableArtistSchedule>[];
    final selectedCount = selectedSlotIndices.length;
    final allSelected =
        schedules.isNotEmpty && selectedCount == schedules.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (schedules.isEmpty)
          Text(
            t.timetableScan.performanceList.emptyState,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        if (schedules.isNotEmpty) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(
                TimetableScanStitchTokens.radiusLg,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.timetableScan.performanceList.heading,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        t.timetableScan.performanceList.selectAll,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: spacing.s),
                      Checkbox(
                        key: const ValueKey('select-all-slots-checkbox'),
                        value: allSelected,
                        onChanged: (_) {
                          if (allSelected) {
                            onClearAllSlots();
                          } else {
                            onSelectAllSlots();
                          }
                        },
                        activeColor: scheme.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.m),
                  for (var i = 0; i < schedules.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: spacing.m),
                      child: _StitchEventRow(
                        key: ValueKey(
                          'artist-schedule-${schedules[i].slotNumber}',
                        ),
                        schedule: schedules[i],
                        accent: _accentForIndex(i, scheme),
                        venueStyle: _venueStyleForIndex(i, scheme),
                        isSelected: selectedSlotIndices.contains(i),
                        onToggle: ({required selected}) => onToggleSlot(
                          i,
                          isSelected: selected,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.m),
          _BottomActionBar(selectedCount: selectedCount),
        ],
      ],
    );
  }
}

Color _accentForIndex(int index, ColorScheme scheme) {
  final colors = <Color>[
    scheme.tertiary,
    scheme.secondary,
    scheme.outlineVariant,
  ];
  return colors[index % colors.length];
}

({Color bg, Color fg}) _venueStyleForIndex(int index, ColorScheme scheme) {
  final useTertiary = index % 3 != 1;
  if (useTertiary) {
    return (bg: scheme.tertiaryContainer, fg: scheme.onTertiaryContainer);
  }
  return (
    bg: scheme.surfaceContainerHighest,
    fg: scheme.onSurfaceVariant,
  );
}

class _StitchEventRow extends StatelessWidget {
  const _StitchEventRow({
    required this.schedule,
    required this.accent,
    required this.venueStyle,
    required this.isSelected,
    required this.onToggle,
    super.key,
  });

  final TimetableArtistSchedule schedule;
  final Color accent;
  final ({Color bg, Color fg}) venueStyle;
  final bool isSelected;
  final void Function({required bool selected}) onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final spacing = context.timetableScanSpacing;
    final liveTime = schedule.performance.timeLabel;
    final merchTime = schedule.merchandise != null
        ? schedule.merchandise!.timeLabel
        : t.timetableScan.performanceList.notAvailable;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(
          TimetableScanStitchTokens.radiusLg,
        ),
        boxShadow: TimetableScanStitchTokens.ambientCardShadow(
          scheme.onSurface,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.m + spacing.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing.m,
                children: [
                  Row(
                    spacing: spacing.xs,
                    children: [
                      Checkbox(
                        key: ValueKey(
                          'event-row-checkbox-${schedule.slotNumber}',
                        ),
                        value: isSelected,
                        onChanged: (v) => onToggle(selected: v ?? false),
                        activeColor: scheme.primary,
                      ),
                      Text(
                        schedule.artistName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final narrow = constraints.maxWidth < 420;
                      final live = _InfoCell(
                        label: t.timetableScan.performanceList.liveTime,
                        value: liveTime,
                      );
                      final merch = _InfoCell(
                        label: t.timetableScan.performanceList.merchEventTime,
                        value: merchTime,
                        valueColor: schedule.merchandise == null
                            ? scheme.onSurfaceVariant
                            : null,
                      );
                      final edit = Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context
                                      .t
                                      .timetableScan
                                      .performanceList
                                      .editingComingSoon,
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: scheme.primary,
                          ),
                          label: Text(
                            t.timetableScan.performanceList.editDetails,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      );
                      if (narrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            live,
                            SizedBox(height: spacing.s),
                            merch,
                            edit,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: live),
                          SizedBox(width: spacing.m),
                          Expanded(child: merch),
                          edit,
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor ?? scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.selectedCount});

  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final spacing = context.timetableScanSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          TimetableScanStitchTokens.radiusLg,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.surfaceContainerLow,
            scheme.surfaceContainer,
          ],
        ),
        boxShadow: TimetableScanStitchTokens.ambientCardShadow(
          scheme.onSurface,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.l),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final row = constraints.maxWidth >= 560;
            final selectedTitle = selectedCount == 1
                ? t.timetableScan.performanceList.selectedOne
                : t.timetableScan.performanceList.selectedMany(
                    count: selectedCount,
                  );
            final summary = Column(
              crossAxisAlignment: row
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  selectedTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  t.timetableScan.performanceList.addingToCalendar,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: row ? TextAlign.start : TextAlign.center,
                ),
              ],
            );
            final button = DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: TimetableScanStitchTokens.primaryCtaGradient(scheme),
                boxShadow: TimetableScanStitchTokens.ambientCardShadow(
                  scheme.onSurface,
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context
                              .t
                              .timetableScan
                              .performanceList
                              .calendarIntegrationComingSoon,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          color: scheme.onPrimary,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            context
                                .t
                                .timetableScan
                                .performanceList
                                .addSelectedToGoogleCalendar,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            if (row) {
              return Row(
                children: [
                  Expanded(child: summary),
                  SizedBox(width: spacing.m),
                  button,
                ],
              );
            }
            return Column(
              children: [
                summary,
                SizedBox(height: spacing.m),
                button,
              ],
            );
          },
        ),
      ),
    );
  }
}
