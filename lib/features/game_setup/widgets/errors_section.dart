import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
import 'package:knowledge_test/models/session_models.dart';

/// Validation errors of the current draft, ready to display.
class ErrorsSection extends StatelessWidget {
  final SessionConfig config;
  final AppLocalizations l10n;

  const ErrorsSection({super.key, required this.config, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final errors = config.validate().map((e) => e.message(l10n)).toList();

    if (errors.isEmpty) {
      return const SizedBox(height: AppDimensions.spacingLg);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimensions.spacingSm),
        for (final error in errors)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
            child: Text(
              error,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}
