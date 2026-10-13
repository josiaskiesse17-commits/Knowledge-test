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
/// The search field and every filter live in one card that scrolls together
/// with the question list, so the screen reads as a single surface instead of a
/// stacked panel and a list. On a tablet or a desktop browser that card sits in
/// a side column while the selected question stays visible next to it.
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

/// Narrow layout: the filter card and the list scroll together.
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
    // The filter card is followed directly by the questions it filters, on the
    // same scroll surface.
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      children: [
        _FilterBlock(
          filter: filter,
          onFilterChanged: onFilterChanged,
          resultCount: questions.length,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (questions.isEmpty)
          const _NoResult()
        else
          for (final question in questions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: _QuestionCard(
                question: question,
                onTap: () => onSelect(question),
              ),
            ),
      ],
    );
  }
}

/// Wide layout: filters and list in a side column, details on the right.
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
    // A web window can be very wide: cap the side column so the questions stay
    // readable instead of stretching across the screen.
    final panelWidth =
        MediaQuery.sizeOf(context).width < 1100 ? 340.0 : 400.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: panelWidth,
          padding: const EdgeInsets.all(AppDimensions.spacingMd),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.25),
          ),
          child: SingleChildScrollView(
            child: _FilterBlock(
              filter: filter,
              onFilterChanged: onFilterChanged,
              resultCount: questions.length,
            ),
          ),
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

/// Search field, active filters and the result count, as one compact section.
///
/// The filter list is collapsed by default so the questions start right below
/// the search field; expanding it opens every criterion in place, on the same
/// surface, instead of in a separate panel.
class _FilterBlock extends StatefulWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final int resultCount;

  const _FilterBlock({
    required this.filter,
    required this.onFilterChanged,
    required this.resultCount,
  });

  @override
  State<_FilterBlock> createState() => _FilterBlockState();
}

class _FilterBlockState extends State<_FilterBlock> {
  bool _expanded = false;

  List<_FilterSection> get _sections => [
        _FilterSection(
          title: 'Mode',
          options: [for (final mode in GameMode.values) mode.name],
          labels: {
            for (final mode in GameMode.values) mode.name: mode.displayNameFr
          },
          selected: widget.filter.modes.map((m) => m.name).toSet(),
          onToggle: (name) {
            final mode = GameMode.values.firstWhere((m) => m.name == name);
            widget.onFilterChanged(widget.filter.toggleMode(mode));
          },
        ),
        _FilterSection(
          title: 'Difficulté',
          options: [for (final d in Difficulty.values) d.name],
          labels: {for (final d in Difficulty.values) d.name: d.displayNameFr},
          selected: widget.filter.difficulties.map((d) => d.name).toSet(),
          onToggle: (name) {
            final difficulty =
                Difficulty.values.firstWhere((d) => d.name == name);
            widget.onFilterChanged(widget.filter.toggleDifficulty(difficulty));
          },
        ),
        _FilterSection(
          title: 'Catégorie',
          options: [for (final c in QuestionCategory.values) c.name],
          labels: {
            for (final c in QuestionCategory.values) c.name: c.displayNameFr,
          },
          selected: widget.filter.categories.map((c) => c.name).toSet(),
          onToggle: (name) {
            final category =
                QuestionCategory.values.firstWhere((c) => c.name == name);
            widget.onFilterChanged(widget.filter.toggleCategory(category));
          },
        ),
        _FilterSection(
          title: 'Variation',
          options: [for (final v in QuestionVariation.values) v.name],
          labels: {
            for (final v in QuestionVariation.values) v.name: v.labelFr
          },
          selected: widget.filter.variations.map((v) => v.name).toSet(),
          onToggle: (name) {
            final variation =
                QuestionVariation.values.firstWhere((v) => v.name == name);
            widget.onFilterChanged(widget.filter.toggleVariation(variation));
          },
        ),
      ];

  /// Short labels of the active filters, shown under the search field.
  List<String> get _activeFilterLabels {
    final filter = widget.filter;
    final labels = <String>[];
    for (final mode in GameMode.values) {
      if (filter.modes.contains(mode)) labels.add(mode.displayNameFr);
    }
    for (final difficulty in Difficulty.values) {
      if (filter.difficulties.contains(difficulty)) {
        labels.add(difficulty.displayNameFr);
      }
    }
    for (final category in QuestionCategory.values) {
      if (filter.categories.contains(category)) {
        labels.add(category.displayNameFr);
      }
    }
    for (final variation in QuestionVariation.values) {
      if (filter.variations.contains(variation)) {
        labels.add(variation.labelFr);
      }
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final filter = widget.filter;
    final activeLabels = _activeFilterLabels;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher une question…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: filter.search.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Effacer la recherche',
                      onPressed: () => widget.onFilterChanged(filter.withSearch('')),
                    ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => widget.onFilterChanged(filter.withSearch(value)),
          ),
          const SizedBox(height: AppDimensions.spacingSm),

          // The filter row: a toggle to open every criterion, and the filters
          // already applied as a short summary.
          Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
                size: AppDimensions.iconSm,
                color: colorScheme.primary,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Expanded(
                child: Text(
                  filter.isActive
                      ? '${filter.activeCount} filtre${filter.activeCount == 1 ? '' : 's'} actif${filter.activeCount == 1 ? '' : 's'}'
                      : 'Filtres',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (filter.isActive)
                TextButton(
                  onPressed: () => widget.onFilterChanged(filter.cleared),
                  child: const Text('Réinitialiser'),
                ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _expanded
                    ? 'Masquer les filtres'
                    : 'Afficher les filtres',
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ],
          ),
          if (activeLabels.isNotEmpty) ...[
            Wrap(
              spacing: AppDimensions.spacingXs,
              runSpacing: AppDimensions.spacingXs,
              children: [
                for (final label in activeLabels)
                  Chip(
                    label: Text(label),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingXs),
          ],

          if (_expanded) ...[
            Divider(height: AppDimensions.spacingMd),
            for (final section in _sections) ...[
              Text(
                section.title,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
              const SizedBox(height: AppDimensions.spacingMd),
            ],
          ],

          Divider(height: AppDimensions.spacingMd),
          Row(
            children: [
              Icon(
                Icons.list_alt_outlined,
                size: AppDimensions.iconSm,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              Text(
                '${widget.resultCount} question${widget.resultCount <= 1 ? '' : 's'}',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
