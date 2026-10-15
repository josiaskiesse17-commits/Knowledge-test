import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Search field, active filters and the result count, as one compact section.
///
/// The filter list is collapsed by default so the questions start right below
/// the search field; expanding it opens every criterion in place, on the same
/// surface, instead of in a separate panel.
class QuestionFilterPanel extends StatefulWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final int resultCount;

  const QuestionFilterPanel({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.resultCount,
  });

  @override
  State<QuestionFilterPanel> createState() => _QuestionFilterPanelState();
}

class _QuestionFilterPanelState extends State<QuestionFilterPanel> {
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

/// One criterion of the filter panel, as a group of chips.
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
