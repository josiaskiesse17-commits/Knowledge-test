import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/features/game/widgets/question_column.dart';
import 'package:knowledge_test/features/game/widgets/quizmaster_panel.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/services/game_engine.dart';

/// Phone and tablet layout: the question scrolls above the controls.
class PhoneGameLayout extends StatelessWidget {
  final GameState state;
  final GameController controller;

  const PhoneGameLayout({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: QuestionColumn(
        state: state,
        controller: controller,
      ),
    );
  }
}

/// Desktop layout: question on the left, scores and controls on the right.
class WideGameLayout extends StatelessWidget {
  final GameState state;
  final GameController controller;
  final ValueChanged<String> onAward;

  const WideGameLayout({
    super.key,
    required this.state,
    required this.controller,
    required this.onAward,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // A very wide window keeps the panel at a readable width instead of
    // stretching it across the screen.
    final panelWidth = screenWidth > 1600 ? 420.0 : 360.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: QuestionColumn(
              state: state,
              controller: controller,
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        SizedBox(
          width: panelWidth,
          child: QuizmasterPanel(
            state: state,
            controller: controller,
            onAward: onAward,
          ),
        ),
      ],
    );
  }
}
