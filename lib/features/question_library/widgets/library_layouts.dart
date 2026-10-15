import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/features/question_library/question_detail_view.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/features/question_library/widgets/library_placeholders.dart';
import 'package:knowledge_test/features/question_library/widgets/question_card.dart';
import 'package:knowledge_test/features/question_library/widgets/question_filter_panel.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Narrow layout: the filter card and the list scroll together.
class PhoneLibraryLayout extends StatelessWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final List<BaseQuestion> questions;
  final ValueChanged<BaseQuestion> onSelect;

  const PhoneLibraryLayout({
    super.key,
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
        QuestionFilterPanel(
          filter: filter,
          onFilterChanged: onFilterChanged,
          resultCount: questions.length,
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        if (questions.isEmpty)
          const NoResult()
        else
          for (final question in questions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: QuestionCard(
                question: question,
                onTap: () => onSelect(question),
              ),
            ),
      ],
    );
  }
}

/// Wide layout: filters and list in a side column, details on the right.
class WideLibraryLayout extends StatelessWidget {
  final QuestionFilter filter;
  final ValueChanged<QuestionFilter> onFilterChanged;
  final List<BaseQuestion> questions;
  final BaseQuestion? selected;
  final ValueChanged<BaseQuestion> onSelect;

  const WideLibraryLayout({
    super.key,
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
            child: QuestionFilterPanel(
              filter: filter,
              onFilterChanged: onFilterChanged,
              resultCount: questions.length,
            ),
          ),
        ),
        Expanded(
          child: questions.isEmpty
              ? const NoResult()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  itemCount: questions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppDimensions.spacingSm),
                  itemBuilder: (context, index) => QuestionCard(
                    question: questions[index],
                    isSelected: questions[index].id == selected?.id,
                    onTap: () => onSelect(questions[index]),
                  ),
                ),
        ),
        Expanded(
          child: selected == null
              ? const SelectHint()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: QuestionDetailView(question: selected!),
                ),
        ),
      ],
    );
  }
}
