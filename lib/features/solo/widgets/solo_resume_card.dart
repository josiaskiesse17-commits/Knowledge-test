import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';

/// Card shown on the setup screen when a solo session is already in progress.
///
/// Lets the player resume the saved session or discard it to start a new one.
class SoloResumeCard extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onDiscard;

  const SoloResumeCard({
    super.key,
    required this.onResume,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      color: colorScheme.primaryContainer.withValues(alpha: 0.15),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.soloResumeTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            Text(
              l10n.soloResumeSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: l10n.soloResumeButton,
                    icon: Icons.play_arrow,
                    onPressed: onResume,
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingSm),
                Expanded(
                  child: TextButtonWidget(
                    label: l10n.soloDiscardButton,
                    icon: Icons.delete_outline,
                    onPressed: onDiscard,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
