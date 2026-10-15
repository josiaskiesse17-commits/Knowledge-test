import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/game_setup/widgets/categories_section.dart';
import 'package:knowledge_test/features/game_setup/widgets/difficulty_section.dart';
import 'package:knowledge_test/features/game_setup/widgets/errors_section.dart';
import 'package:knowledge_test/features/game_setup/widgets/length_section.dart';
import 'package:knowledge_test/features/game_setup/widgets/mode_section.dart';
import 'package:knowledge_test/features/game_setup/widgets/player_section.dart';
import 'package:knowledge_test/features/game_setup/widgets/shuffle_section.dart';
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
                                        PlayerSection(
                                          config: config,
                                          notifier: notifier,
                                          controllers: _controllers,
                                          focusNodes: _focusNodes,
                                          onRemove: _removePlayer,
                                          onAdd: _addPlayer,
                                        ),
                                        ModeSection(
                                          config: config,
                                          notifier: notifier,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: _sessionColumn(
                                      scrollPadding:
                                          const EdgeInsets.only(left: AppDimensions.spacingMd),
                                      children: [
                                        DifficultySection(
                                          config: config,
                                          notifier: notifier,
                                        ),
                                        CategoriesSection(
                                          config: config,
                                          notifier: notifier,
                                        ),
                                        LengthSection(
                                          config: config,
                                          notifier: notifier,
                                        ),
                                        ShuffleSection(
                                          config: config,
                                          notifier: notifier,
                                        ),
                                        ErrorsSection(config: config),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : ListView(
                                children: [
                                  PlayerSection(
                                    config: config,
                                    notifier: notifier,
                                    controllers: _controllers,
                                    focusNodes: _focusNodes,
                                    onRemove: _removePlayer,
                                    onAdd: _addPlayer,
                                  ),
                                  ModeSection(
                                    config: config,
                                    notifier: notifier,
                                  ),
                                  DifficultySection(
                                    config: config,
                                    notifier: notifier,
                                  ),
                                  CategoriesSection(
                                    config: config,
                                    notifier: notifier,
                                  ),
                                  LengthSection(
                                    config: config,
                                    notifier: notifier,
                                  ),
                                  ShuffleSection(
                                    config: config,
                                    notifier: notifier,
                                  ),
                                  ErrorsSection(config: config),
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
}
