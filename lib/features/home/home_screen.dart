import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final size = AppBreakpoints.sizeOf(width);
    final isWide = size != ScreenSize.phone;
    final maxWidth = AppBreakpoints.contentMaxWidth(size);

    final secondaryButtons = [
      _MenuEntry(
        label: l10n.homeQuestionLibrary,
        icon: Icons.menu_book_outlined,
        description: l10n.homeQuestionLibraryDescription,
        onTap: () => context.go(AppRoute.questionLibrary.path),
      ),
      _MenuEntry(
        label: l10n.homeSessionHistory,
        icon: Icons.history_outlined,
        description: l10n.homeSessionHistoryDescription,
        onTap: () => context.go(AppRoute.sessionHistory.path),
      ),
      _MenuEntry(
        label: l10n.homeSettings,
        icon: Icons.settings_outlined,
        description: l10n.homeSettingsDescription,
        onTap: () => context.go(AppRoute.settings.path),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppBreakpoints.pagePadding(width),
                vertical: AppDimensions.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: isWide
                        ? AppDimensions.spacingLg
                        : AppDimensions.spacingXl,
                  ),
                  Icon(
                    Icons.quiz_outlined,
                    size: isWide ? 72 : 56,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  Text(
                    l10n.homeWelcome,
                    style: (isWide
                            ? textTheme.displayLarge
                            : textTheme.displayMedium)
                        ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Text(
                    l10n.homeWelcomeSubtitle,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: isWide
                        ? AppDimensions.spacingXxl
                        : AppDimensions.spacingXl,
                  ),
                  PrimaryButton(
                    label: l10n.homeNewGame,
                    icon: Icons.play_circle_outline,
                    onPressed: () => context.go(AppRoute.gameSetup.path),
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _buildMenuItems(context, secondaryButtons, isWide),
                  const SizedBox(height: AppDimensions.spacingXl),
                  Text(
                    'v0.1.0',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Stacks the entries on a phone, and spreads them over a grid on wider
  /// screens so the home page does not look like a stretched phone screen.
  Widget _buildMenuItems(
    BuildContext context,
    List<_MenuEntry> entries,
    bool isWide,
  ) {
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.spacingMd),
            _MenuCard(entry: entries[i], showDescription: false),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            AppBreakpoints.sizeOf(constraints.maxWidth) == ScreenSize.desktop
                ? 3
                : 2;
        final cardWidth = (constraints.maxWidth - AppDimensions.spacingMd * (columns - 1)) / columns;

        return Wrap(
          spacing: AppDimensions.spacingMd,
          runSpacing: AppDimensions.spacingMd,
          children: [
            for (final entry in entries)
              SizedBox(
                width: cardWidth,
                child: _MenuCard(entry: entry, showDescription: true),
              ),
          ],
        );
      },
    );
  }
}

class _MenuEntry {
  final String label;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const _MenuEntry({
    required this.label,
    required this.icon,
    required this.description,
    required this.onTap,
  });
}

class _MenuCard extends StatelessWidget {
  final _MenuEntry entry;
  final bool showDescription;

  const _MenuCard({required this.entry, required this.showDescription});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final icon = Container(
      width: showDescription ? 40 : 48,
      height: showDescription ? 40 : 48,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Icon(
        entry.icon,
        color: colorScheme.primary,
        size: AppDimensions.iconMd,
      ),
    );

    final label = Text(
      entry.label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
    );

    // A phone shows a single row per entry, a wide screen a card with the
    // description under the label.
    return AppCard(
      onTap: entry.onTap,
      child: showDescription
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(height: AppDimensions.spacingSm),
                label,
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  entry.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                icon,
                const SizedBox(width: AppDimensions.spacingMd),
                Expanded(child: label),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimensions.iconMd,
                ),
              ],
            ),
    );
  }
}
