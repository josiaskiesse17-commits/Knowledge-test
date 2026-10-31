import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';

/// Shown when the game screen is opened without a running session.
class EmptySession extends StatelessWidget {
  final VoidCallback onBack;

  const EmptySession({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.emptySessionTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.quiz_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              Text(
                l10n.emptySessionNoSession,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              PrimaryButton(
                label: l10n.emptySessionSetup,
                icon: Icons.settings_outlined,
                onPressed: onBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
