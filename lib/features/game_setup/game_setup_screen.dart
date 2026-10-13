import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/session_models.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';

class GameSetupScreen extends ConsumerStatefulWidget {
  const GameSetupScreen({super.key});

  @override
  ConsumerState<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends ConsumerState<GameSetupScreen> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _syncControllers(ref.read(sessionSetupProvider).playerNames);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _syncControllers(List<String> names) {
    while (_controllers.length > names.length) {
      _controllers.removeLast().dispose();
      _focusNodes.removeLast().dispose();
    }
    while (_controllers.length < names.length) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    for (var i = 0; i < names.length; i++) {
      if (_controllers[i].text != names[i]) {
        _controllers[i].text = names[i];
      }
    }
  }

  void _addPlayer() {
    ref.read(sessionSetupProvider.notifier).addPlayer();
    _syncControllers(ref.read(sessionSetupProvider).playerNames);
  }

  void _removePlayer(int index) {
    ref.read(sessionSetupProvider.notifier).removePlayer(index);
    _syncControllers(ref.read(sessionSetupProvider).playerNames);
  }

  void _startGame() {
    final config = ref.read(sessionSetupProvider);
    // Questions already played in the saved sessions are reused only when the
    // session cannot be filled with fresh ones.
    final recentQuestionIds =
        ref.read(sessionHistoryProvider.notifier).recentQuestionIds;
    final errors = ref
        .read(gameControllerProvider.notifier)
        .prepare(config, recentQuestionIds: recentQuestionIds);

    if (errors.isNotEmpty) {
      _showError(errors.first);
      return;
    }

    ref.read(gameControllerProvider.notifier).start();
    context.go(AppRoute.game.path);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(sessionSetupProvider);
    final notifier = ref.read(sessionSetupProvider.notifier);

    _syncControllers(config.playerNames);

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
            final contentWidth = constraints.maxWidth > AppDimensions.maxContentWidth
                ? AppDimensions.maxContentWidth
                : constraints.maxWidth;

            // A desktop or tablet window shows the session options in two
            // columns instead of one very long phone column.
            final twoColumns =
                AppBreakpoints.sizeOf(constraints.maxWidth) != ScreenSize.phone;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: twoColumns
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _sessionColumn(
                                      scrollPadding:
                                          const EdgeInsets.only(right: AppDimensions.spacingMd),
                                      children: [
                                        ..._playerSection(config, notifier),
                                        ..._modesSection(config, notifier),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: _sessionColumn(
                                      scrollPadding:
                                          const EdgeInsets.only(left: AppDimensions.spacingMd),
                                      children: [
                                        ..._difficultySection(config, notifier),
                                        ..._categoriesSection(config, notifier),
                                        ..._lengthSection(config, notifier),
                                        ..._shuffleSection(config, notifier),
                                        ..._errorsSection(config),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : ListView(
                                children: [
                                  ..._playerSection(config, notifier),
                                  ..._modesSection(config, notifier),
                                  ..._difficultySection(config, notifier),
                                  ..._categoriesSection(config, notifier),
                                  ..._lengthSection(config, notifier),
                                  ..._shuffleSection(config, notifier),
                                  ..._errorsSection(config),
                                ],
                              ),
                      ),
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

  /// Scrollable column used by the two-column layout.
  Widget _sessionColumn({
    required List<Widget> children,
    required EdgeInsets scrollPadding,
  }) {
    return ListView(
      padding: scrollPadding,
      children: children,
    );
  }

  List<Widget> _playerSection(SessionConfig config, SessionSetupNotifier notifier) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return [
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
          child: _PlayerRow(
            index: i,
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            onNameChanged: (name) => notifier.updatePlayerName(i, name),
            onRemove: config.playerNames.length > config.minPlayers
                ? () => _removePlayer(i)
                : null,
          ),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButtonWidget(
          label: AppStrings.addPlayer,
          icon: Icons.person_add_outlined,
          onPressed: config.playerNames.length < config.maxPlayers
              ? _addPlayer
              : null,
        ),
      ),
      const SizedBox(height: AppDimensions.spacingLg),
    ];
  }

  List<Widget> _modesSection(
      SessionConfig config, SessionSetupNotifier notifier) {
    return [
      _SectionTitle(
        title: 'Modes de jeu',
        subtitle: 'Un ou plusieurs modes pour la session.',
      ),
      const SizedBox(height: AppDimensions.spacingSm),
      for (final mode in GameMode.values)
        _ModeTile(
          mode: mode,
          isSelected: config.modes.contains(mode),
          onTap: () => notifier.toggleMode(mode),
        ),
      const SizedBox(height: AppDimensions.spacingLg),
    ];
  }

  List<Widget> _difficultySection(
      SessionConfig config, SessionSetupNotifier notifier) {
    return [
      _SectionTitle(
        title: 'Difficulté',
        subtitle: 'Les questions de ce niveau sont privilégiées.',
      ),
      const SizedBox(height: AppDimensions.spacingSm),
      SegmentedButton<Difficulty>(
        segments: [
          for (final difficulty in Difficulty.values)
            ButtonSegment<Difficulty>(
              value: difficulty,
              label: Text(difficulty.displayNameFr),
            ),
        ],
        selected: {config.difficulty},
        onSelectionChanged: (selection) => notifier.setDifficulty(selection.first),
      ),
      const SizedBox(height: AppDimensions.spacingLg),
    ];
  }

  List<Widget> _categoriesSection(
      SessionConfig config, SessionSetupNotifier notifier) {
    return [
      _SectionTitle(
        title: 'Catégories',
        subtitle: config.categories.isEmpty
            ? 'Toutes les catégories.'
            : '${config.categories.length} catégorie(s) sélectionnée(s).',
      ),
      const SizedBox(height: AppDimensions.spacingSm),
      Wrap(
        spacing: AppDimensions.spacingSm,
        runSpacing: AppDimensions.spacingSm,
        children: [
          for (final category in QuestionCategory.values)
            FilterChip(
              label: Text(category.displayNameFr),
              selected: config.categories.contains(category),
              onSelected: (_) => notifier.toggleCategory(category),
            ),
        ],
      ),
      const SizedBox(height: AppDimensions.spacingLg),
    ];
  }

  List<Widget> _lengthSection(
      SessionConfig config, SessionSetupNotifier notifier) {
    final textTheme = Theme.of(context).textTheme;

    return [
      _SectionTitle(
        title: 'Durée ou nombre de questions',
        subtitle: config.isTimed
            ? 'Session minutée : la question en cours est toujours terminée.'
            : 'Session limitée en nombre de questions.',
      ),
      const SizedBox(height: AppDimensions.spacingSm),
      SegmentedButton<bool>(
        segments: const [
          ButtonSegment<bool>(
            value: false,
            label: Text('Questions'),
          ),
          ButtonSegment<bool>(
            value: true,
            label: Text('Durée'),
          ),
        ],
        selected: {config.isTimed},
        onSelectionChanged: (selection) {
          final timed = selection.first;
          notifier.setSessionDurationMinutes(timed ? 15 : null);
        },
      ),
      const SizedBox(height: AppDimensions.spacingMd),
      if (config.isTimed)
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Durée : ${config.sessionDurationMinutes} min',
                  style: textTheme.bodyLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => notifier.setSessionDurationMinutes(
                  (config.sessionDurationMinutes! - 1).clamp(1, 180),
                ),
                tooltip: 'Réduire la durée',
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => notifier.setSessionDurationMinutes(
                  (config.sessionDurationMinutes! + 1).clamp(1, 180),
                ),
                tooltip: 'Augmenter la durée',
              ),
            ],
          ),
        )
      else
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Nombre de questions : ${config.questionCount}',
                  style: textTheme.bodyLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => notifier.setQuestionCount(
                  (config.questionCount - 1).clamp(1, 30),
                ),
                tooltip: 'Moins de questions',
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => notifier.setQuestionCount(
                  (config.questionCount + 1).clamp(1, 30),
                ),
                tooltip: 'Plus de questions',
              ),
            ],
          ),
        ),
      const SizedBox(height: AppDimensions.spacingSm),
    ];
  }

  List<Widget> _shuffleSection(
      SessionConfig config, SessionSetupNotifier notifier) {
    return [
      SwitchListTile(
        value: config.shuffleQuestions,
        onChanged: (_) => notifier.toggleShuffle(),
        title: const Text('Mélanger les questions'),
        subtitle: const Text('Ordre aléatoire à chaque session.'),
        contentPadding: EdgeInsets.zero,
      ),
    ];
  }

  List<Widget> _errorsSection(SessionConfig config) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (config.validate().isEmpty) {
      return [const SizedBox(height: AppDimensions.spacingLg)];
    }

    return [
      const SizedBox(height: AppDimensions.spacingSm),
      for (final error in config.validate())
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
          child: Text(
            error,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ),
      const SizedBox(height: AppDimensions.spacingLg),
    ];
  }
}

class _PlayerRow extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onNameChanged;
  final VoidCallback? onRemove;

  const _PlayerRow({
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  final GameMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTile({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: AppCard(
        onTap: onTap,
        color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.4) : null,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              size: AppDimensions.iconMd,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.displayNameFr,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    mode.descriptionFr,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
