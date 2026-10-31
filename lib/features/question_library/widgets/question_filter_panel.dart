import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/l10n/game_mode_localizations.dart';
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
  late final AppLocalizations _l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _l10n = AppLocalizations.of(context)!;
  }

  List<_FilterSection> get _sections => [
    _FilterSection(
      title: _l10n.questionFilterMode,
      options: [for (final mode in GameMode.values) mode.name],
      labels: {
        for (final mode in GameMode.values) mode.name: mode.title(_l10n),
      },
      selected: widget.filter.modes.map((m) => m.name).toSet(),
      onToggle: (name) {
        final mode = GameMode.values.firstWhere((m) => m.name == name);
        widget.onFilterChanged(widget.filter.toggleMode(mode));
      },
    ),
    _FilterSection(
      title: _l10n.questionFilterDifficulty,
      options: [for (final d in Difficulty.values) d.name],
      labels: {
        for (final d in Difficulty.values) d.name: d.localizedName(_l10n),
      },
      selected: widget.filter.difficulties.map((d) => d.name).toSet(),
      onToggle: (name) {
        final difficulty = Difficulty.values.firstWhere((d) => d.name == name);
        widget.onFilterChanged(widget.filter.toggleDifficulty(difficulty));
      },
    ),
    _FilterSection(
      title: _l10n.questionFilterCategory,
      options: [for (final c in QuestionCategory.values) c.name],
      labels: {
        for (final c in QuestionCategory.values) c.name: c.localizedName(_l10n),
      },
      selected: widget.filter.categories.map((c) => c.name).toSet(),
      onToggle: (name) {
        final category = QuestionCategory.values.firstWhere(
          (c) => c.name == name,
        );
        widget.onFilterChanged(widget.filter.toggleCategory(category));
      },
    ),
    _FilterSection(
      title: _l10n.questionFilterVariation,
      options: [for (final v in QuestionVariation.values) v.name],
      labels: {
        for (final v in QuestionVariation.values)
          v.name: v.localizedName(_l10n),
      },
      selected: widget.filter.variations.map((v) => v.name).toSet(),
      onToggle: (name) {
        final variation = QuestionVariation.values.firstWhere(
          (v) => v.name == name,
        );
        widget.onFilterChanged(widget.filter.toggleVariation(variation));
      },
    ),
  ];

  /// Short labels of the active filters, shown under the search field.
  List<String> get _activeFilterLabels {
    final filter = widget.filter;
    final labels = <String>[];
    for (final mode in GameMode.values) {
      if (filter.modes.contains(mode)) labels.add(mode.title(_l10n));
    }
    for (final difficulty in Difficulty.values) {
      if (filter.difficulties.contains(difficulty)) {
        labels.add(difficulty.localizedName(_l10n));
      }
    }
    for (final category in QuestionCategory.values) {
      if (filter.categories.contains(category)) {
        labels.add(category.localizedName(_l10n));
      }
    }
    for (final variation in QuestionVariation.values) {
      if (filter.variations.contains(variation)) {
        labels.add(variation.localizedName(_l10n));
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

    String activeLabel;
    if (filter.isActive) {
      activeLabel = filter.activeCount == 1
          ? _l10n.questionFilterActiveCount(1)
          : _l10n.questionFilterActiveCountOther(filter.activeCount);
    } else {
      activeLabel = _l10n.questionFilterFilters;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: _l10n.questionFilterSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: filter.search.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: _l10n.questionFilterClearTooltip,
                      onPressed: () =>
                          widget.onFilterChanged(filter.withSearch('')),
                    ),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) =>
                widget.onFilterChanged(filter.withSearch(value)),
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
                  activeLabel,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (filter.isActive)
                TextButton(
                  onPressed: () => widget.onFilterChanged(filter.cleared),
                  child: Text(_l10n.questionFilterReset),
                ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: _expanded
                    ? _l10n.questionFilterHideTooltip
                    : _l10n.questionFilterShowTooltip,
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
                widget.resultCount == 1
                    ? _l10n.questionFilterResultCount(1)
                    : _l10n.questionFilterResultCountOther(widget.resultCount),
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
