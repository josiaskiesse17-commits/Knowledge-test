import 'package:flutter/material.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// Shuffle switch of the session.
class ShuffleSection extends StatelessWidget {
  final SessionConfig config;
  final SessionSetupNotifier notifier;

  const ShuffleSection({
    super.key,
    required this.config,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          value: config.shuffleQuestions,
          onChanged: (_) => notifier.toggleShuffle(),
          title: Text(l10n.gameSetupShuffleTitle),
          subtitle: Text(l10n.gameSetupShuffleSubtitle),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
