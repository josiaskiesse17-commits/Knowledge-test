import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/question_library/question_detail_view.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/providers/game_providers.dart';

/// Read-only library of the questions shipped in the app.
///
/// On a narrow phone the filter bar and the list share the screen and a
/// question opens in a full-screen detail. On a tablet or a desktop browser the
/// filters and the list sit in a side panel while the selected question stays
/// visible next to them, so nothing is hidden behind a dialog.
class QuestionLibraryScreen extends ConsumerStatefulWidget {
  const QuestionLibraryScreen({super.key});

  @override
  ConsumerState<QuestionLibraryScreen> createState() =>
      _QuestionLibraryScreenState();
}

class _QuestionLibraryScreenState extends ConsumerState<QuestionLibraryScreen> {
  QuestionFilter _filter = const QuestionFilter();
  BaseQuestion? _selected;

  /// All questions of the repository, ordered by mode then id.
  ///
  /// The repository hands out an unmodifiable list, so a sorted copy is made
  /// here instead of sorting it in place.
  List<BaseQuestion> get _allQuestions {
    final questions = [
      ...ref.watch(questionRepositoryProvider).getAllQuestions(),
    ]..sort((a, b) {
        final byMode = a.mode.index.compareTo(b.mode.index);
        if (byMode != 0) return byMode;
        return a.id.compareTo(b.id);
      });
    return questions;
  }

  void _update(QuestionFilter filter) {
    setState(() => _filter = filter);
    // A selection that no longer matches the filters is dropped.
    if (_selected != null && !filter.apply(_allQuestions).contains(_selected)) {
      _selected = null;
    }
  }

  void _select(BaseQuestion question) {
    setState(() => _selected = question);
    final width = MediaQuery.sizeOf(context).width;
    if (AppBreakpoints.sizeOf(width) == ScreenSize.phone) {
      _openDetails(question);
    }
  }

  Future<void> _openDetails(BaseQuestion question) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: QuestionDetailView(question: question),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final all = _allQuestions;
    final visible = _filter.apply(all);
    final twoPane =
        AppBreakpoints.supportsTwoPane(MediaQuery.sizeOf(context).width);
    // A question may disappear from the filtered list while still selected.
    final selected = visible.contains(_selected) ? _selected : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque de questions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour',
          onPressed: () => context.go(AppRoute.home.path),
        ),
      ),
      body: SafeArea(
        child: twoPane
            ? _WideLayout(
                filter: _filter,
                onFilterChanged: _update,
                questions: visible,
                selected: selected,
                onSelect: (question) => setState(() => _selected = question),
              )
            : _PhoneLayout(
                filter: _filter,
                onFilterChanged: _update,
                questions: visible,
                onSelect: _select,
              ),
      ),
    );
  }
}

/// Narrow layout: search, filters and the list on one column.
class _PhoneLayout extends StatelessWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final List<BaseQuestion> questions;
  final ValueChanged<BaseQuestion> onSelect;

  const _PhoneLayout({
    required this.filter,
    required this.onFilterChanged,
    required this.questions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchField(
          filter: filter,
          onFilterChanged: onFilterChanged,
        ),
        _FilterPanel(
          filter: filter,
          onFilterChanged: onFilterChanged,
          scrollDirection: Axis.horizontal,
        ),
        Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
        Expanded(
          child: questions.isEmpty
              ? const _NoResult()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  itemCount: questions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimensions.spacingSm),
                  itemBuilder: (context, index) => _QuestionCard(
                    question: questions[index],
                    onTap: () => onSelect(questions[index]),
                  ),
                ),
        ),
        _ResultCount(count: questions.length),
      ],
    );
  }
}

/// Wide layout: filters and list in a side panel, details on the right.
class _WideLayout extends StatelessWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final List<BaseQuestion> questions;
  final BaseQuestion? selected;
  final ValueChanged<BaseQuestion> onSelect;

  const _WideLayout({
    required this.filter,
    required this.onFilterChanged,
    required this.questions,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // A web window can be very wide: cap the side panel so the questions stay
    // readable instead of stretching across the screen.
    final panelWidth =
        MediaQuery.sizeOf(context).width < 1100 ? 340.0 : 400.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: panelWidth,
          child: Column(
            children: [
              _SearchField(filter: filter, onFilterChanged: onFilterChanged),
              Expanded(
                child: _FilterPanel(
                  filter: filter,
                  onFilterChanged: onFilterChanged,
                  scrollDirection: Axis.vertical,
                ),
              ),
              _ResultCount(count: questions.length),
            ],
          ),
        ),
        VerticalDivider(
          width: 1,
          color: colorScheme.outlineVariant,
        ),
        Expanded(
          child: questions.isEmpty
              ? const _NoResult()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  itemCount: questions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimensions.spacingSm),
                  itemBuilder: (context, index) => _QuestionCard(
                    question: questions[index],
                    isSelected: questions[index].id == selected?.id,
                    onTap: () => onSelect(questions[index]),
                  ),
                ),
        ),
        VerticalDivider(
          width: 1,
          color: colorScheme.outlineVariant,
        ),
        Expanded(
          child: selected == null
              ? const _SelectHint()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: QuestionDetailView(question: selected!),
                ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;

  const _SearchField({required this.filter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher une question…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: filter.search.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Effacer la recherche',
                  onPressed: () => onFilterChanged(filter.withSearch('')),
                ),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => onFilterChanged(filter.withSearch(value)),
      ),
    );
  }
}

/// Filters of the library, one section per criterion.
class _FilterPanel extends StatelessWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final Axis scrollDirection;

  const _FilterPanel({
    required this.filter,
    required this.onFilterChanged,
    required this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) {
    final sections = <_FilterSection>[
      _FilterSection(
        title: 'Mode',
        options: [
          for (final mode in GameMode.values) mode.name,
        ],
        labels: {for (final mode in GameMode.values) mode.name: mode.displayNameFr},
        selected: filter.modes.map((m) => m.name).toSet(),
        onToggle: (name) {
          final mode = GameMode.values.firstWhere((m) => m.name == name);
          onFilterChanged(filter.toggleMode(mode));
        },
      ),
      _FilterSection(
        title: 'Difficulté',
        options: [for (final d in Difficulty.values) d.name],
        labels: {
          for (final d in Difficulty.values) d.name: d.displayNameFr,
        },
        selected: filter.difficulties.map((d) => d.name).toSet(),
        onToggle: (name) {
          final difficulty = Difficulty.values.firstWhere((d) => d.name == name);
          onFilterChanged(filter.toggleDifficulty(difficulty));
        },
      ),
      _FilterSection(
        title: 'Catégorie',
        options: [for (final c in QuestionCategory.values) c.name],
        labels: {
          for (final c in QuestionCategory.values) c.name: c.displayNameFr,
        },
        selected: filter.categories.map((c) => c.name).toSet(),
        onToggle: (name) {
          final category = QuestionCategory.values.firstWhere((c) => c.name == name);
          onFilterChanged(filter.toggleCategory(category));
        },
      ),
      _FilterSection(
        title: 'Variation',
        options: [for (final v in QuestionVariation.values) v.name],
        labels: {for (final v in QuestionVariation.values) v.name: v.labelFr},
        selected: filter.variations.map((v) => v.name).toSet(),
        onToggle: (name) {
          final variation = QuestionVariation.values.firstWhere((v) => v.name == name);
          onFilterChanged(filter.toggleVariation(variation));
        },
      ),
    ];

    final panel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
          ),
          child: Row(
            children: [
              Text(
                'Filtres',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              if (filter.isActive)
                TextButton(
                  onPressed: () => onFilterChanged(filter.cleared),
                  child: const Text('Réinitialiser'),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        for (final section in sections)
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.spacingMd,
              left: AppDimensions.spacingMd,
              right: AppDimensions.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Wrap(
                  spacing: AppDimensions.spacingXs,
                  runSpacing: AppDimensions.spacingXs,
                  children: [
                    for (final option in section.options)
                      FilterChip(
                        label: Text(section.labels[option] ?? option),
                        selected: section.selected.contains(option),
                        onSelected: (_) => section.onToggle(option),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );

    if (scrollDirection == Axis.horizontal) {
      // On a phone the filters are a bar of columns, each one with a bounded
      // height and its own scrolling, so the list below is never pushed out of
      // the screen by a long category list.
      return SizedBox(
        height: 156,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingMd,
          ),
          children: [
            if (filter.isActive)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
                    child: TextButton(
                      onPressed: () => onFilterChanged(filter.cleared),
                      child: const Text('Tout'),
                    ),
                  ),
                ],
              ),
            for (final section in sections)
              SizedBox(
                width: 170,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.spacingSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: AppDimensions.spacingXs,
                            runSpacing: AppDimensions.spacingXs,
                            children: [
                              for (final option in section.options)
                                FilterChip(
                                  label: Text(section.labels[option] ?? option),
                                  selected: section.selected.contains(option),
                                  onSelected: (_) => section.onToggle(option),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    }
    return SingleChildScrollView(child: panel);
  }
}

class _FilterSection {
  final String title;
  final List<String> options;
  final Map<String, String> labels;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _FilterSection({
    required this.title,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onToggle,
  });
}

class _QuestionCard extends StatelessWidget {
  final BaseQuestion question;
  final VoidCallback onTap;
  final bool isSelected;

  const _QuestionCard({
    required this.question,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_modeIcon(question.mode),
                  size: AppDimensions.iconSm, color: colorScheme.primary),
              const SizedBox(width: AppDimensions.spacingXs),
              Expanded(
                child: Text(
                  question.mode.displayNameFr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                question.difficulty.displayNameFr,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            question.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Wrap(
            spacing: AppDimensions.spacingXs,
            runSpacing: AppDimensions.spacingXs,
            children: [
              Text(
                question.category.displayNameFr,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '•',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.outline,
                ),
              ),
              Text(
                question.variation.labelFr,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static IconData _modeIcon(GameMode mode) => switch (mode) {
        GameMode.whichCameFirst => Icons.history_outlined,
        GameMode.guessTheCountry => Icons.public_outlined,
        GameMode.factOrCap => Icons.fact_check_outlined,
        GameMode.putInOrder => Icons.sort_outlined,
        GameMode.howMuch => Icons.straighten_outlined,
      };
}

class _ResultCount extends StatelessWidget {
  final int count;

  const _ResultCount({required this.count});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingSm),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.list_alt_outlined,
              size: AppDimensions.iconSm, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            '$count question${count <= 1 ? '' : 's'}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _NoResult extends StatelessWidget {
  const _NoResult();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_outlined,
                size: 56, color: colorScheme.outline),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              'Aucune question ne correspond',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Modifiez la recherche ou réinitialisez les filtres.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectHint extends StatelessWidget {
  const _SelectHint();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.touch_app_outlined,
                size: 56, color: colorScheme.outline),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              'Sélectionnez une question',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              'Sa réponse, son explication et sa source s\'afficheront ici.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
