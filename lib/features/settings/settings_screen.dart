import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/theme_providers.dart';
import 'package:knowledge_test/services/session_history_service.dart';

/// Application settings.
///
/// The preferences offered here are the theme and the language. The history
/// size is reported as read-only information: the sessions themselves are
/// managed from the history screen.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final history = ref.watch(sessionHistoryProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = AppBreakpoints.contentMaxWidth(
      AppBreakpoints.sizeOf(width),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.settingsBackTooltip,
          onPressed: () => context.go(AppRoute.home.path),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: EdgeInsets.all(AppBreakpoints.pagePadding(width)),
              children: [
                _SectionTitle(
                  title: l10n.settingsAppearanceTitle,
                  subtitle: l10n.settingsAppearanceSubtitle,
                  leadingIcon: Icons.palette_outlined,
                ),
                _ThemeSelector(
                  current: themeMode,
                  onChanged: notifier.setThemeMode,
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                _SectionTitle(
                  title: l10n.settingsDataTitle,
                  subtitle: l10n.settingsDataSubtitle,
                  leadingIcon: Icons.storage_outlined,
                ),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.history_outlined),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        child: Text(
                          history.sessions.length <= kMaxStoredSessions
                              ? l10n.settingsStoredSessions(
                                  history.sessions.length,
                                  kMaxStoredSessions,
                                )
                              : l10n.settingsHistoryFull,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                AppCard(
                  onTap: () => context.go(AppRoute.sessionHistory.path),
                  child: Row(
                    children: [
                      const Icon(Icons.list_alt_outlined),
                      const SizedBox(width: AppDimensions.spacingMd),
                      Expanded(
                        child: Text(l10n.settingsOpenHistory),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingLg),
                _SectionTitle(
                  title: l10n.settingsAboutTitle,
                  leadingIcon: Icons.info_outline,
                ),
                AppCard(
                  child: Text(l10n.settingsAboutDescription),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leadingIcon;

  const _SectionTitle({
    required this.title,
    required this.leadingIcon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        children: [
          Icon(leadingIcon, color: colorScheme.primary),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Theme choice: light, dark or follow the system setting.
class _ThemeSelector extends StatelessWidget {
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelector({required this.current, required this.onChanged});

  List<(ThemeMode, String, IconData)> _options(AppLocalizations l10n) => [
        (ThemeMode.light, l10n.settingsThemeLight, Icons.light_mode_outlined),
        (ThemeMode.dark, l10n.settingsThemeDark, Icons.dark_mode_outlined),
        (
          ThemeMode.system,
          l10n.settingsThemeSystem,
          Icons.brightness_auto_outlined
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = _options(l10n);
    final isNarrow = MediaQuery.sizeOf(context).width < 600;

    if (isNarrow) {
      // A single column keeps every label readable on a phone.
      return RadioGroup<ThemeMode>(
        groupValue: current,
        onChanged: (mode) {
          if (mode != null) onChanged(mode);
        },
        child: Column(
          children: [
            for (final option in options)
              RadioListTile<ThemeMode>(
                value: option.$1,
                title: Text(option.$2),
                secondary: Icon(option.$3),
              ),
          ],
        ),
      );
    }

    return SegmentedButton<ThemeMode>(
      segments: [
        for (final option in options)
          ButtonSegment<ThemeMode>(
            value: option.$1,
            label: Text(option.$2),
            icon: Icon(option.$3),
          ),
      ],
      selected: {current},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
