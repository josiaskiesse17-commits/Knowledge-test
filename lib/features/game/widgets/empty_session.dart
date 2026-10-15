import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';

/// Shown when the game screen is opened without a running session.
class EmptySession extends StatelessWidget {
  final VoidCallback onBack;

  const EmptySession({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
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
                'Aucune session en cours.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              PrimaryButton(
                label: 'Configurer une partie',
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
