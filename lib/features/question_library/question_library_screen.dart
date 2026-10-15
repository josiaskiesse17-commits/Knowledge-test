import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/utils/responsive.dart';
import 'package:knowledge_test/features/question_library/question_detail_view.dart';
import 'package:knowledge_test/features/question_library/question_filter.dart';
import 'package:knowledge_test/features/question_library/widgets/library_layouts.dart';
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
            ? WideLibraryLayout(
                filter: _filter,
                onFilterChanged: _update,
                questions: visible,
                selected: selected,
                onSelect: (question) => setState(() => _selected = question),
              )
            : PhoneLibraryLayout(
                filter: _filter,
                onFilterChanged: _update,
                questions: visible,
                onSelect: _select,
              ),
      ),
    );
  }
}
