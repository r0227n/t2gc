import 'dart:async';

import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/models/google_calendar_summary.dart';
import 'package:app/domain/models/timetable_artist_schedule.dart';
import 'package:app/domain/models/timetable_merchandise_slot.dart';
import 'package:app/domain/models/timetable_scan_result.dart';
import 'package:app/presentation/helpers/timetable_formatters.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Stitch verify layout: editorial rows, left accent bar, row checkboxes.
class TimetableScanPerformanceListCard extends StatelessWidget {
  /// Creates the performance list card.
  const TimetableScanPerformanceListCard({
    required this.scanResult,
    required this.selectedSlotIndices,
    required this.eventTitle,
    required this.onToggleSlot,
    required this.onSelectAllSlots,
    required this.onClearAllSlots,
    required this.onEditSchedule,
    required this.onAddSelectedToGoogleCalendar,
    required this.selectedCalendar,
    required this.isLoadingCalendars,
    required this.onSelectCalendar,
    super.key,
  });

  /// Parsed OCR result containing the timetable schedules.
  final TimetableScanResult? scanResult;

  /// Indices into [scanResult!.schedules] for selected rows.
  final Set<int> selectedSlotIndices;

  /// Event title shown in the calendar summary line.
  final String eventTitle;

  /// Toggles whether the schedule at the given index is selected.
  final void Function(int index, {required bool isSelected}) onToggleSlot;

  /// Selects all parsed slots.
  final void Function() onSelectAllSlots;

  /// Clears all parsed slots.
  final void Function() onClearAllSlots;

  /// Updates the schedule at the given index.
  final void Function(int index, TimetableArtistSchedule schedule)
  onEditSchedule;

  /// Adds selected rows to Google Calendar.
  final Future<void> Function() onAddSelectedToGoogleCalendar;

  /// Currently selected Google Calendar.
  final GoogleCalendarSummary? selectedCalendar;

  /// Whether the calendar list is being loaded.
  final bool isLoadingCalendars;

  /// Opens the calendar selection UI.
  final Future<void> Function() onSelectCalendar;

  @override
  Widget build(BuildContext context) {
    final spacing = context.timetableScanSpacing;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final translations = t;
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
            translations.timetableScan.performanceList.emptyState,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        if (schedules.isNotEmpty) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: context.timetableScanLargeRadius,
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
                          translations.timetableScan.performanceList.heading,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        translations.timetableScan.performanceList.selectAll,
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
                        onEditSchedule: (schedule) => onEditSchedule(
                          i,
                          schedule,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.m),
          _BottomActionBar(
            selectedCount: selectedCount,
            eventTitle: eventTitle,
            onAddSelectedToGoogleCalendar: onAddSelectedToGoogleCalendar,
            selectedCalendar: selectedCalendar,
            isLoadingCalendars: isLoadingCalendars,
            onSelectCalendar: onSelectCalendar,
          ),
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
    required this.onEditSchedule,
    super.key,
  });

  final TimetableArtistSchedule schedule;
  final Color accent;
  final ({Color bg, Color fg}) venueStyle;
  final bool isSelected;
  final void Function({required bool selected}) onToggle;
  final void Function(TimetableArtistSchedule schedule) onEditSchedule;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final spacing = context.timetableScanSpacing;
    final liveTime = schedule.performance.dateTimeLabel;
    final merchTime = schedule.merchandise != null
        ? schedule.merchandise!.dateTimeLabel
        : t.timetableScan.performanceList.notAvailable;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: context.timetableScanLargeRadius,
        boxShadow: TimetableScanTheme.ambientCardShadow(
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
                            unawaited(
                              _showEditScheduleSheet(
                                context: context,
                                schedule: schedule,
                                onSaved: onEditSchedule,
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

final class _EditScheduleFormData {
  const _EditScheduleFormData({
    required this.artistName,
    required this.liveStartAt,
    required this.liveEndAt,
    required this.merchandiseStartAt,
    required this.merchandiseEndAt,
  });

  final String artistName;
  final DateTime liveStartAt;
  final DateTime liveEndAt;
  final DateTime? merchandiseStartAt;
  final DateTime? merchandiseEndAt;
}

Future<void> _showEditScheduleSheet({
  required BuildContext context,
  required TimetableArtistSchedule schedule,
  required void Function(TimetableArtistSchedule schedule) onSaved,
}) async {
  final updatedSchedule = await showModalBottomSheet<TimetableArtistSchedule>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _EditScheduleSheet(schedule: schedule),
  );
  if (updatedSchedule == null) {
    return;
  }

  onSaved(updatedSchedule);
}

class _EditScheduleSheet extends StatefulWidget {
  const _EditScheduleSheet({required this.schedule});

  final TimetableArtistSchedule schedule;

  @override
  State<_EditScheduleSheet> createState() => _EditScheduleSheetState();
}

class _EditScheduleSheetState extends State<_EditScheduleSheet> {
  static final DateFormat _dateTimeFormat = DateFormat('yyyy/MM/dd HH:mm');

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _artistNameController;
  late final TextEditingController _liveStartController;
  late final TextEditingController _liveEndController;
  late final TextEditingController _merchStartController;
  late final TextEditingController _merchEndController;
  late DateTime _liveStartAt;
  late DateTime _liveEndAt;
  DateTime? _merchStartAt;
  DateTime? _merchEndAt;

  @override
  void initState() {
    super.initState();
    final merchandise = widget.schedule.merchandise;
    _artistNameController = TextEditingController(
      text: widget.schedule.artistName,
    );
    _liveStartAt = widget.schedule.performance.startAt;
    _liveEndAt = widget.schedule.performance.endAt;
    _merchStartAt = merchandise?.startAt;
    _merchEndAt = merchandise?.endAt;
    _liveStartController = TextEditingController(
      text: _dateTimeFormat.format(_liveStartAt),
    );
    _liveEndController = TextEditingController(
      text: _dateTimeFormat.format(_liveEndAt),
    );
    _merchStartController = TextEditingController(
      text: _merchStartAt == null ? '' : _dateTimeFormat.format(_merchStartAt!),
    );
    _merchEndController = TextEditingController(
      text: _merchEndAt == null ? '' : _dateTimeFormat.format(_merchEndAt!),
    );
  }

  @override
  void dispose() {
    _artistNameController.dispose();
    _liveStartController.dispose();
    _liveEndController.dispose();
    _merchStartController.dispose();
    _merchEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.timetableScanSpacing;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.m,
          0,
          spacing.m,
          bottomInset + spacing.m,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.timetableScan.performanceList.editDetails,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: spacing.s),
                TextFormField(
                  controller: _artistNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'アーティスト名',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'アーティスト名を入力してください。';
                    }
                    return null;
                  },
                ),
                SizedBox(height: spacing.m),
                _DateTimeFieldGroup(
                  title: t.timetableScan.performanceList.liveTime,
                  startController: _liveStartController,
                  endController: _liveEndController,
                  onPickStart: () => _pickDateTime(
                    initialValue: _liveStartAt,
                    onSelected: (value) {
                      setState(() {
                        _liveStartAt = value;
                        _liveStartController.text = _dateTimeFormat.format(
                          value,
                        );
                      });
                    },
                  ),
                  onPickEnd: () => _pickDateTime(
                    initialValue: _liveEndAt,
                    onSelected: (value) {
                      setState(() {
                        _liveEndAt = value;
                        _liveEndController.text = _dateTimeFormat.format(
                          value,
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: spacing.m),
                _DateTimeFieldGroup(
                  title: t.timetableScan.performanceList.merchEventTime,
                  startController: _merchStartController,
                  endController: _merchEndController,
                  optional: true,
                  onPickStart: () => _pickDateTime(
                    initialValue: _merchStartAt ?? _liveEndAt,
                    onSelected: (value) {
                      setState(() {
                        _merchStartAt = value;
                        _merchStartController.text = _dateTimeFormat.format(
                          value,
                        );
                      });
                    },
                  ),
                  onPickEnd: () => _pickDateTime(
                    initialValue: _merchEndAt ?? _merchStartAt ?? _liveEndAt,
                    onSelected: (value) {
                      setState(() {
                        _merchEndAt = value;
                        _merchEndController.text = _dateTimeFormat.format(
                          value,
                        );
                      });
                    },
                  ),
                  onClear: () {
                    setState(() {
                      _merchStartAt = null;
                      _merchEndAt = null;
                      _merchStartController.clear();
                      _merchEndController.clear();
                    });
                  },
                ),
                SizedBox(height: spacing.l),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('キャンセル'),
                      ),
                    ),
                    SizedBox(width: spacing.s),
                    Expanded(
                      child: FilledButton(
                        onPressed: _handleSave,
                        child: const Text('保存'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final data = _parseFormData();
    if (data == null) {
      return;
    }

    Navigator.of(context).pop(_buildUpdatedSchedule(data));
  }

  _EditScheduleFormData? _parseFormData() {
    final artistName = _artistNameController.text.trim();
    final liveStartAt = _liveStartAt;
    final liveEndAt = _liveEndAt;

    if (!liveEndAt.isAfter(liveStartAt)) {
      _showValidationMessage('ライブ終了時間は開始時間より後にしてください。');
      return null;
    }

    final hasMerchStart = _merchStartAt != null;
    final hasMerchEnd = _merchEndAt != null;
    if (hasMerchStart != hasMerchEnd) {
      _showValidationMessage(
        '特典会 / イベント時間は開始と終了を両方入力してください。',
      );
      return null;
    }

    final merchStartAt = _merchStartAt;
    final merchEndAt = _merchEndAt;
    if (merchStartAt != null && merchEndAt != null) {
      if (!merchEndAt.isAfter(merchStartAt)) {
        _showValidationMessage(
          '特典会 / イベント終了時間は開始時間より後にしてください。',
        );
        return null;
      }
    }

    return _EditScheduleFormData(
      artistName: artistName,
      liveStartAt: liveStartAt,
      liveEndAt: liveEndAt,
      merchandiseStartAt: merchStartAt,
      merchandiseEndAt: merchEndAt,
    );
  }

  Future<void> _pickDateTime({
    required DateTime initialValue,
    required void Function(DateTime value) onSelected,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialValue),
    );
    if (time == null || !mounted) {
      return;
    }

    onSelected(
      DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  TimetableArtistSchedule _buildUpdatedSchedule(_EditScheduleFormData data) {
    final previousMerchandise = widget.schedule.merchandise;
    final liveSourceText =
        '${_dateTimeFormat.format(data.liveStartAt)}'
        '〜${_dateTimeFormat.format(data.liveEndAt)}';
    final performance = widget.schedule.performance.copyWith(
      artistName: data.artistName,
      startAt: data.liveStartAt,
      endAt: data.liveEndAt,
      sourceText: liveSourceText,
    );

    final merchandise = switch ((
      data.merchandiseStartAt,
      data.merchandiseEndAt,
    )) {
      (final start?, final end?) =>
        (previousMerchandise ??
                TimetableMerchandiseSlot(
                  slotNumber: widget.schedule.slotNumber,
                  artistName: data.artistName,
                  startAt: start,
                  endAt: end,
                  sourceText:
                      '${_dateTimeFormat.format(start)}'
                      '〜${_dateTimeFormat.format(end)}',
                ))
            .copyWith(
              artistName: data.artistName,
              startAt: start,
              endAt: end,
              sourceText:
                  '${_dateTimeFormat.format(start)}'
                  '〜${_dateTimeFormat.format(end)}',
            ),
      _ => null,
    };

    return widget.schedule.copyWith(
      performance: performance,
      merchandise: merchandise,
    );
  }

  void _showValidationMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _DateTimeFieldGroup extends StatelessWidget {
  const _DateTimeFieldGroup({
    required this.title,
    required this.startController,
    required this.endController,
    required this.onPickStart,
    required this.onPickEnd,
    this.optional = false,
    this.onClear,
  });

  final String title;
  final TextEditingController startController;
  final TextEditingController endController;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final bool optional;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final spacing = context.timetableScanSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (optional && onClear != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onClear,
              child: const Text('クリア'),
            ),
          ),
        SizedBox(height: spacing.s),
        TextFormField(
          controller: startController,
          readOnly: true,
          onTap: onPickStart,
          decoration: InputDecoration(
            labelText: optional ? '開始日時（未設定可）' : '開始日時',
            suffixIcon: const Icon(Icons.calendar_today_rounded),
          ),
        ),
        SizedBox(height: spacing.s),
        TextFormField(
          controller: endController,
          readOnly: true,
          onTap: onPickEnd,
          decoration: InputDecoration(
            labelText: optional ? '終了日時（未設定可）' : '終了日時',
            suffixIcon: const Icon(Icons.calendar_today_rounded),
          ),
        ),
      ],
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
    final spacing = context.timetableScanSpacing;
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
        SizedBox(height: spacing.xs),
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
  const _BottomActionBar({
    required this.selectedCount,
    required this.eventTitle,
    required this.onAddSelectedToGoogleCalendar,
    required this.selectedCalendar,
    required this.isLoadingCalendars,
    required this.onSelectCalendar,
  });

  final int selectedCount;
  final String eventTitle;
  final Future<void> Function() onAddSelectedToGoogleCalendar;
  final GoogleCalendarSummary? selectedCalendar;
  final bool isLoadingCalendars;
  final Future<void> Function() onSelectCalendar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final spacing = context.timetableScanSpacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: context.timetableScanLargeRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.surfaceContainerLow,
            scheme.surfaceContainer,
          ],
        ),
        boxShadow: TimetableScanTheme.ambientCardShadow(
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
                  t.timetableScan.performanceList.addingToCalendar(
                    eventTitle: eventTitle,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: row ? TextAlign.start : TextAlign.center,
                ),
              ],
            );
            final buttonEnabled = selectedCount > 0;
            final button = Opacity(
              opacity: buttonEnabled ? 1 : 0.45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: context.timetableScanPillRadius,
                  gradient: TimetableScanTheme.primaryCtaGradient(
                    scheme,
                  ),
                  boxShadow: TimetableScanTheme.ambientCardShadow(
                    scheme.onSurface,
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: context.timetableScanPillRadius,
                    onTap: buttonEnabled
                        ? () async {
                            await onAddSelectedToGoogleCalendar();
                          }
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.l,
                        vertical: spacing.m,
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
