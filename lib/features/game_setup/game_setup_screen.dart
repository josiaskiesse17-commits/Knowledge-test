import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';

final playerControllersProvider = StateProvider<List<TextEditingController>>((ref) {
  return [TextEditingController(), TextEditingController()];
});

final playerFocusNodesProvider = StateProvider<List<FocusNode>>((ref) {
  return [FocusNode(), FocusNode()];
});

class GameSetupScreen extends ConsumerStatefulWidget {
  const GameSetupScreen({super.key});

  @override
  ConsumerState<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends ConsumerState<GameSetupScreen> {
  @override
  void dispose() {
    final controllers = ref.read(playerControllersProvider);
    final focusNodes = ref.read(playerFocusNodesProvider);
    for (final controller in controllers) {
      controller.dispose();
    }
    for (final focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    final controllers = ref.read(playerControllersProvider.notifier);
    final focusNodes = ref.read(playerFocusNodesProvider.notifier);
    if (controllers.state.length < 8) {
      controllers.state = [...controllers.state, TextEditingController()];
      focusNodes.state = [...focusNodes.state, FocusNode()];
    }
  }

  void _removePlayer(int index) {
    final controllers = ref.read(playerControllersProvider.notifier);
    final focusNodes = ref.read(playerFocusNodesProvider.notifier);
    if (controllers.state.length > 2) {
      controllers.state[index].dispose();
      focusNodes.state[index].dispose();
      controllers.state = [
        ...controllers.state.sublist(0, index),
        ...controllers.state.sublist(index + 1),
      ];
      focusNodes.state = [
        ...focusNodes.state.sublist(0, index),
        ...focusNodes.state.sublist(index + 1),
      ];
    }
  }

  void _startGame() {
    final controllers = ref.read(playerControllersProvider);
    final names = controllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (names.length < 2) {
      _showError(context, AppStrings.minPlayersError);
      return;
    }

    if (names.length > 8) {
      _showError(context, AppStrings.maxPlayersError);
      return;
    }

    if (names.toSet().length != names.length) {
      _showError(context, 'Les noms des joueurs doivent être uniques');
      return;
    }

    _showError(context, 'Fonctionnalité à venir - Task 3');
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllers = ref.watch(playerControllersProvider);
    final focusNodes = ref.watch(playerFocusNodesProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.gameSetupTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.home.path),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final contentWidth = maxWidth > AppDimensions.maxContentWidth
                ? AppDimensions.maxContentWidth
                : maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppStrings.players,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      Text(
                        'Ajoutez 2 à 8 joueurs pour commencer',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      Expanded(
                        child: ListView.separated(
                          itemCount: controllers.length,
                          separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.spacingMd),
                          itemBuilder: (context, index) {
                            return _PlayerRow(
                              index: index,
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              onRemove: controllers.length > 2
                                  ? () => _removePlayer(index)
                                  : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: AppStrings.addPlayer,
                              icon: Icons.person_add_outlined,
                              onPressed: controllers.length < 8 ? _addPlayer : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      PrimaryButton(
                        label: AppStrings.startGame,
                        icon: Icons.play_arrow,
                        onPressed: _startGame,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onRemove;

  const _PlayerRow({
    required this.index,
    required this.controller,
    required this.focusNode,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
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
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: AppTextField(
              controller: controller,
              focusNode: focusNode,
              hint: '${AppStrings.playerNameHint} ${index + 1}',
              textInputAction: TextInputAction.next,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: AppDimensions.spacingSm),
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
        ],
      ),
    );
  }
}