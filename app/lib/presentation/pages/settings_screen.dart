import 'dart:async';

import 'package:app/core/gen/slang.g.dart' as app_i18n;
import 'package:app/data/services/google_calendar_service.dart';
import 'package:app/domain/models/google_calendar_summary.dart';
import 'package:app/presentation/controllers/settings_controller.dart';
import 'package:app/presentation/widgets/google_sign_in_web_button.dart';
import 'package:core/core.dart' as core;
import 'package:core/i18n/core_translations.g.dart' as core_i18n;
import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Loads package information for the version row.
final packageInfoProvider = FutureProvider<PackageInfo>(
  (ref) => PackageInfo.fromPlatform(),
);

/// Application settings screen.
class SettingsScreen extends ConsumerStatefulWidget {
  /// Creates the settings screen.
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _artistNameExclusionController;

  @override
  void initState() {
    super.initState();
    _artistNameExclusionController = TextEditingController();
  }

  @override
  void dispose() {
    _artistNameExclusionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translations = _appTranslations(context);
    final theme = Theme.of(context);
    final spacing = context.appSpacing;
    final locale = ref.watch(core.appLocaleProviderProvider);
    final settingsState = ref.watch(settingsControllerProvider);
    final calendarService = ref.watch(googleCalendarServiceProvider);
    final versionAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.settings.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing.l),
        children: [
          _SectionTitle(title: translations.settings.sections.appSettings),
          Card(
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.gavel_rounded,
                  title: translations.settings.licenses,
                  subtitle: translations.settings.licensesDescription,
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Timetable to Google Calendar',
                      applicationVersion: versionAsync.asData?.value.version,
                    );
                  },
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.translate_rounded,
                  title: translations.settings.displayLanguage,
                  subtitle: _localeLabel(
                    translations: translations,
                    locale: locale,
                  ),
                  onTap: () async {
                    await core
                        .PreferencesDialogHelpers.showLocaleSelectionDialog(
                      context: context,
                      title: translations.settings.displayLanguage,
                      onLocaleChanged: _handleLocaleChanged,
                    );
                  },
                ),
                const Divider(height: 1),
                Padding(
                  padding: EdgeInsets.all(spacing.l),
                  child: _ArtistNameExclusionSettingBlock(
                    controller: _artistNameExclusionController,
                    words: settingsState.artistNameExclusionWords,
                    onAdd: () {
                      unawaited(_handleAddArtistNameExclusionWord());
                    },
                    onRemove: (word) {
                      unawaited(
                        ref
                            .read(settingsControllerProvider.notifier)
                            .removeArtistNameExclusionWord(word),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.xl),
          _SectionTitle(title: translations.settings.sections.account),
          Card(
            child: Padding(
              padding: EdgeInsets.all(spacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ActionSettingBlock(
                    leading: _GoogleAccountLeading(
                      photoUrl: settingsState.account?.photoUrl,
                    ),
                    title: translations.settings.googleAccount,
                    subtitle: settingsState.account == null
                        ? translations.settings.notSignedIn
                        : translations.settings.connectedAs(
                            email: settingsState.account!.email,
                          ),
                    hint: calendarService.isConfigured
                        ? translations.settings.signInHint
                        : translations.settings.oauthConfigurationHint,
                    action: settingsState.account == null
                        ? _GoogleSignInAction(
                            isConfigured: calendarService.isConfigured,
                            supportsAuthenticate:
                                calendarService.supportsAuthenticate,
                            isBusy: settingsState.isBusy,
                            label:
                                translations.settings.googleSignInButtonLabel,
                            onPressed: () {
                              unawaited(
                                ref
                                    .read(settingsControllerProvider.notifier)
                                    .signIn(),
                              );
                            },
                          )
                        : OutlinedButton.icon(
                            onPressed: settingsState.isBusy
                                ? null
                                : () {
                                    unawaited(
                                      ref
                                          .read(
                                            settingsControllerProvider.notifier,
                                          )
                                          .signOut(),
                                    );
                                  },
                            icon: const Icon(Icons.logout_rounded),
                            label: Text(translations.settings.signOut),
                          ),
                  ),
                  Divider(
                    height: spacing.l,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  _ActionSettingBlock(
                    leading: const Icon(
                      Icons.calendar_month_rounded,
                      size: 28,
                    ),
                    title: translations.settings.googleCalendar,
                    subtitle: _selectedCalendarLabel(
                      context,
                      settingsState,
                    ),
                    hint: _calendarHint(
                      context,
                      settingsState,
                      calendarService,
                    ),
                    action: FilledButton.tonalIcon(
                      onPressed:
                          calendarService.isConfigured &&
                              settingsState.isSignedIn &&
                              !settingsState.isBusy &&
                              !settingsState.isInitializing &&
                              !settingsState.isLoadingCalendars
                          ? () {
                              unawaited(
                                _showCalendarSelectionDialog(context, ref),
                              );
                            }
                          : null,
                      icon: settingsState.isLoadingCalendars
                          ? SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                      label: Text(
                        settingsState.isLoadingCalendars
                            ? translations.settings.loadingCalendars
                            : translations.settings.selectCalendar,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (settingsState.errorMessage != null) ...[
            SizedBox(height: spacing.xl),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.error_outline_rounded,
                  color: theme.colorScheme.error,
                ),
                title: Text(translations.settings.googleAccount),
                subtitle: Text(
                  _errorMessage(
                    settingsState.errorMessage!,
                    translations,
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: spacing.xl),
          _SectionTitle(title: translations.settings.sections.other),
          Card(
            child: _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: translations.settings.version,
              subtitle: versionAsync.when(
                data: (info) => info.version,
                error: (_, _) => '-',
                loading: () => '...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLocaleChanged(String languageCode) async {
    final nextLocale = app_i18n.AppLocale.values.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => app_i18n.AppLocale.ja,
    );
    await app_i18n.LocaleSettings.setLocale(nextLocale);
  }

  Future<void> _handleAddArtistNameExclusionWord() async {
    final word = _artistNameExclusionController.text.trim();
    if (word.isEmpty) {
      return;
    }

    await ref
        .read(settingsControllerProvider.notifier)
        .addArtistNameExclusionWord(word);
    _artistNameExclusionController.clear();
  }

  String _localeLabel({
    required app_i18n.Translations translations,
    required Locale locale,
  }) {
    return switch (locale.languageCode) {
      'ja' => '日本語',
      'en' => 'English',
      _ => translations.settings.language,
    };
  }

  String _selectedCalendarLabel(
    BuildContext context,
    SettingsState settingsState,
  ) {
    final translations = _appTranslations(context);

    if (!settingsState.isSignedIn) {
      return translations.settings.signInRequired;
    }

    if (settingsState.isLoadingCalendars && settingsState.calendars.isEmpty) {
      return translations.settings.loadingCalendars;
    }

    return settingsState.selectedCalendar?.summary ??
        translations.timetableScan.performanceList.defaultCalendar;
  }

  String _calendarHint(
    BuildContext context,
    SettingsState settingsState,
    GoogleCalendarService calendarService,
  ) {
    final translations = _appTranslations(context);

    if (!calendarService.isConfigured) {
      return translations.settings.oauthConfigurationHint;
    }
    if (!settingsState.isSignedIn) {
      return translations.settings.signInRequired;
    }
    if (settingsState.isLoadingCalendars) {
      return translations.settings.loadingCalendars;
    }
    return translations.settings.calendarHint;
  }

  Future<void> _showCalendarSelectionDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(settingsControllerProvider.notifier);
    final state = ref.read(settingsControllerProvider);
    final cancelLabel = core_i18n.CoreTranslations.of(context).dialog.cancel;

    if (state.calendars.isEmpty) {
      await notifier.loadWritableCalendars();
    }

    if (!context.mounted) {
      return;
    }

    final refreshedState = ref.read(settingsControllerProvider);
    final availableCalendars = refreshedState.calendars;
    if (availableCalendars.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _appTranslations(
              context,
            ).timetableScan.performanceList.noWritableCalendars,
          ),
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => core.SelectionDialog<GoogleCalendarSummary>(
        title: _appTranslations(context).settings.selectCalendar,
        icon: const Icon(Icons.calendar_month_rounded),
        cancelLabel: cancelLabel,
        currentValue: refreshedState.selectedCalendar,
        options: [
          for (final calendar in availableCalendars)
            core.SelectionOption(
              value: calendar,
              displayText: calendar.summary,
            ),
        ],
        onChanged: notifier.selectCalendar,
      ),
    );
  }

  String _errorMessage(
    String message,
    app_i18n.Translations translations,
  ) {
    if (message == 'oauth_configuration_missing' ||
        message.contains('GoogleCalendarNotConfiguredException')) {
      return translations.settings.oauthConfigurationMissing;
    }

    return translations.settings.calendarLoadFailed(message: message);
  }
}

class _ArtistNameExclusionSettingBlock extends StatelessWidget {
  const _ArtistNameExclusionSettingBlock({
    required this.controller,
    required this.words,
    required this.onAdd,
    required this.onRemove,
  });

  final TextEditingController controller;
  final List<String> words;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.appSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.text_fields_rounded),
            ),
            SizedBox(width: spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OCR除外ワード',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    'OCR結果をアーティスト名に入れる前に削除するワードです。',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.s),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: '除外ワードを追加',
                      hintText: '例: 物販',
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => onAdd(),
                  ),
                  SizedBox(height: spacing.s),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('追加'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.m),
        if (words.isEmpty)
          Text(
            '登録済みの除外ワードはありません。',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: spacing.s,
            runSpacing: spacing.s,
            children: [
              for (final word in words)
                InputChip(
                  label: Text(word),
                  onDeleted: () => onRemove(word),
                ),
            ],
          ),
      ],
    );
  }
}

app_i18n.Translations _appTranslations(BuildContext context) {
  return app_i18n.TranslationProvider.of(context).translations;
}

class _GoogleSignInAction extends StatelessWidget {
  const _GoogleSignInAction({
    required this.isConfigured,
    required this.supportsAuthenticate,
    required this.isBusy,
    required this.label,
    required this.onPressed,
  });

  final bool isConfigured;
  final bool supportsAuthenticate;
  final bool isBusy;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isConfigured) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.error_outline_rounded),
        label: Text(
          _appTranslations(context).settings.oauthConfigurationMissing,
        ),
      );
    }

    if (!supportsAuthenticate && kIsWeb) {
      return buildGoogleSignInWebButton(context);
    }

    return FilledButton.icon(
      onPressed: isBusy ? null : onPressed,
      icon: const Icon(Icons.login_rounded),
      label: Text(label),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.appSpacing;
    return Padding(
      padding: EdgeInsets.only(
        left: spacing.s,
        bottom: spacing.m,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class _ActionSettingBlock extends StatelessWidget {
  const _ActionSettingBlock({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.action,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String hint;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.appSpacing;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: spacing.xs),
          child: leading,
        ),
        SizedBox(width: spacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                hint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: spacing.m),
              Align(
                alignment: Alignment.centerLeft,
                child: action,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoogleAccountLeading extends StatelessWidget {
  const _GoogleAccountLeading({
    required this.photoUrl,
  });

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final photoUrl = this.photoUrl;
    if (photoUrl == null || photoUrl.isEmpty) {
      return const Icon(Icons.account_circle_rounded, size: 28);
    }

    return ClipOval(
      child: Image.network(
        photoUrl,
        width: 32,
        height: 32,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.account_circle_rounded, size: 28);
        },
      ),
    );
  }
}
