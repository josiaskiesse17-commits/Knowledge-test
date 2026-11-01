import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/solo/solo_constants.dart';
import 'package:knowledge_test/features/solo/widgets/solo_resume_card.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/models/solo_session.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/solo_providers.dart';

/// Setup screen for a solo session.
///
/// The player picks the modes, difficulty, categories, question count and
/// shuffle, then starts the session. Only the modes in [kSoloSupportedModes]
/// are offered for now.
class SoloSetupScreen extends ConsumerStatefulWidget {
  const SoloSetupScreen({super.key});

  @override
  ConsumerState<SoloSetupScreen> createState() => _SoloSetupScreenState();
}

class _SoloSetupScreenState extends ConsumerState<SoloSetupScreen> {
  SoloConfig _config = const SoloConfig();

  @override
  void initState() {
    super.initState();
    _loadResumeState();
  }

  Future<void> _loadResumeState() async {
    // Trigger a read of the in-progress provider so the resume card shows.
    ref.read(soloInProgressProvider);
  }

  void _toggleMode(GameMode mode) {
    setState(() {
      final modes = List<GameMode>.from(_config.modes);
      if (modes.contains(mode)) {
        modes.remove(mode);
      } else {
        modes.add(mode);
      }
      _config = _config.copyWith(modes: modes);
    });
  }

  void _setDifficulty(Difficulty difficulty) {
    setState(() {
      _config = _config.copyWith(difficulty: difficulty);
    });
  }

  void _setCategories(List<QuestionCategory> categories) {
    setState(() {
      _config = _config.copyWith(categories: categories);
    });
  }

  void _setQuestionCount(int count) {
    setState(() {
      _config = _config.copyWith(questionCount: count);
    });
  }

  void _setShuffle(bool value) {
    setState(() {
      _config = _config.copyWith(shuffle: value);
    });
  }

  Future<void> _startGame() async {
    final l10n = AppLocalizations.of(context)!;
    final errors = _config.validate();
    if (errors.isNotEmpty) {
      if (!context.mounted) return;
      _showError(_validationErrorMessage(l10n, errors.first));
      return;
    }

    final unsupported = _config.modes
        .where((m) => !kSoloSupportedModes.contains(m))
        .toList();
    if (unsupported.isNotEmpty) {
      if (!context.mounted) return;
      _showError(l10n.soloNotSupportedYet);
      return;
    }

    final controller = ref.read(soloControllerProvider.notifier);
    final validationErrors = await controller.start(_config);
    if (!context.mounted) return;
    if (validationErrors.isNotEmpty) {
      _showError(validationErrors.first);
      return;
    }

    final allQuestions = ref.read(questionRepositoryProvider).getAllQuestions();
    final matching = allQuestions
        .where(
          (q) =>
              _config.modes.contains(q.mode) &&
              (_config.categories.isEmpty ||
                  _config.categories.contains(q.category)),
        )
        .length;
    if (matching < _config.questionCount) {
      if (!mounted) return;
      _showError(l10n.soloErrorNotEnoughQuestions);
      return;
    }

    if (!mounted) return;
    context.go(AppRoute.soloGame.path);
  }

  void _showError(String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _resume() async {
    final controller = ref.read(soloControllerProvider.notifier);
    await controller.resume();
    if (!mounted) return;
    context.go(AppRoute.soloGame.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inProgress = ref.watch(soloInProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.soloSetupTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoute.home.path),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppBreakpoints.contentMaxWidth(
                AppBreakpoints.sizeOf(MediaQuery.sizeOf(context).width),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLg),
              child: ListView(
                children: [
                  if (inProgress.valueOrNull != null) ...[
                    SoloResumeCard(onResume: _resume, onDiscard: _discard),
                    const SizedBox(height: AppDimensions.spacingLg),
                  ],
                  _SectionTitle(
                    title: l10n.soloSetupModesTitle,
                    subtitle: l10n.soloSetupModesSubtitle,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  for (final mode in kSoloSupportedModes)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingSm,
                      ),
                      child: AppCard(
                        onTap: () => _toggleMode(mode),
                        color: _config.modes.contains(mode)
                            ? Theme.of(context).colorScheme.primaryContainer
                                  .withValues(alpha: 0.4)
                            : null,
                        child: Row(
                          children: [
                            Icon(
                              _config.modes.contains(mode)
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _config.modes.contains(mode)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              size: AppDimensions.iconMd,
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mode.title(l10n),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                  Text(
                                    mode.description(l10n),
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _SectionTitle(
                    title: l10n.soloSetupDifficultyTitle,
                    subtitle: l10n.soloSetupDifficultySubtitle,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  ...Difficulty.values.map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingSm,
                      ),
                      child: AppCard(
                        onTap: () => _setDifficulty(d),
                        color: _config.difficulty == d
                            ? Theme.of(context).colorScheme.primaryContainer
                                  .withValues(alpha: 0.4)
                            : null,
                        child: Row(
                          children: [
                            Icon(
                              _config.difficulty == d
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _config.difficulty == d
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                              size: AppDimensions.iconMd,
                            ),
                            const SizedBox(width: AppDimensions.spacingSm),
                            Expanded(
                              child: Text(
                                d.localizedName(l10n),
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _SectionTitle(
                    title: l10n.soloSetupCategoriesTitle,
                    subtitle: _config.categories.isEmpty
                        ? l10n.soloSetupCategoriesSubtitleAll
                        : l10n.soloSetupCategoriesSubtitleSelected(
                            _config.categories.length,
                          ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  Wrap(
                    spacing: AppDimensions.spacingSm,
                    runSpacing: AppDimensions.spacingSm,
                    children: [
                      for (final c in QuestionCategory.values)
                        FilterChip(
                          selected: _config.categories.contains(c),
                          onSelected: (selected) {
                            final cats = List<QuestionCategory>.from(
                              _config.categories,
                            );
                            if (selected) {
                              cats.add(c);
                            } else {
                              cats.remove(c);
                            }
                            _setCategories(cats);
                          },
                          label: Text(c.localizedName(l10n)),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _SectionTitle(
                    title: l10n.soloSetupLengthTitle,
                    subtitle: l10n.soloSetupLengthSubtitleQuestions,
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${l10n.soloSetupLengthSubtitleQuestions.split('.').first}: ${_config.questionCount}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _setQuestionCount(
                            (_config.questionCount - 1).clamp(1, 50),
                          ),
                          tooltip: 'Moins de questions',
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _setQuestionCount(
                            (_config.questionCount + 1).clamp(1, 50),
                          ),
                          tooltip: 'Plus de questions',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),
                  AppCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.soloSetupShuffleTitle,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Switch(value: _config.shuffle, onChanged: _setShuffle),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  PrimaryButton(
                    label: l10n.soloStartGame,
                    icon: Icons.play_arrow,
                    onPressed: _startGame,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _discard() async {
    final controller = ref.read(soloControllerProvider.notifier);
    await controller.abandon();
    if (!context.mounted) return;
    setState(() {});
  }

  String _validationErrorMessage(AppLocalizations l10n, String key) {
    switch (key) {
      case 'noMode':
        return l10n.soloErrorNoMode;
      case 'questionCountTooLow':
        return l10n.soloErrorQuestionCountTooLow;
      default:
        return key;
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
