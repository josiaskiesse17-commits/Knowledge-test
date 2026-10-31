import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Session notices shown above the question.
class SessionNotices extends StatelessWidget {
  final GameState state;

  const SessionNotices({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: AppCard(
        color: colorScheme.tertiaryContainer,
        child: Row(
          children: [
            Icon(
              Icons.pause_circle_outlined,
              color: colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                state.isTimedSession
                    ? l10n.gameNoticePausedTimer
                    : l10n.gameNoticePaused,
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
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: AppCard(
        color: colorScheme.errorContainer,
        child: Row(
          children: [
            Icon(Icons.timer_off_outlined, color: colorScheme.onErrorContainer),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Text(
                l10n.gameNoticeTimeExpired,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
