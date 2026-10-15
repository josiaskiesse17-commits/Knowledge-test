import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// Players of the session: one editable row per player, plus the add button.
class PlayerSection extends StatelessWidget {
  final SessionConfig config;
  final SessionSetupNotifier notifier;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final ValueChanged<int> onRemove;
  final VoidCallback onAdd;

  const PlayerSection({
    super.key,
    required this.config,
    required this.notifier,
    required this.controllers,
    required this.focusNodes,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.players,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Text(
          'De 2 à 8 joueurs, sur un seul appareil.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        for (var i = 0; i < config.playerNames.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: PlayerRow(
              index: i,
              controller: controllers[i],
              focusNode: focusNodes[i],
              onNameChanged: (name) => notifier.updatePlayerName(i, name),
              onRemove: config.playerNames.length > config.minPlayers
                  ? () => onRemove(i)
                  : null,
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButtonWidget(
            label: AppStrings.addPlayer,
            icon: Icons.person_add_outlined,
            onPressed: config.playerNames.length < config.maxPlayers
                ? onAdd
                : null,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
      ],
    );
  }
}

/// One player name field, numbered, with its remove button.
class PlayerRow extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onNameChanged;
  final VoidCallback? onRemove;

  const PlayerRow({
    super.key,
    required this.index,
    required this.controller,
    required this.focusNode,
    required this.onNameChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacingSm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: '${AppStrings.playerNameHint} ${index + 1}',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingSm,
                ),
              ),
              onChanged: onNameChanged,
              onSubmitted: onNameChanged,
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: colorScheme.error,
                size: AppDimensions.iconMd,
              ),
              onPressed: onRemove,
              tooltip: 'Supprimer le joueur',
            ),
        ],
      ),
    );
  }
}
