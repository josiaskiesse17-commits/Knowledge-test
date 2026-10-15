import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Session notices shown above the question.
class SessionNotices extends StatelessWidget {
  final GameState state;

  const SessionNotices({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: AppCard(
        color: colorScheme.tertiaryContainer,
        child: Row(
          children: [
            Icon(Icons.pause_circle_outlined,
                color: colorScheme.onTertiaryContainer),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                state.isTimedSession
                    ? 'Session en pause. Le chronomètre est arrêté.'
                    : 'Session en pause.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Warning shown once the clock of a timed session has run out.
class TimeExpiredNotice extends StatelessWidget {
  const TimeExpiredNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: AppCard(
        color: colorScheme.errorContainer,
        child: Row(
          children: [
            Icon(Icons.timer_off_outlined,
                color: colorScheme.onErrorContainer),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                'Temps écoulé. Terminez cette question, puis la session s\'arrêtera.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
