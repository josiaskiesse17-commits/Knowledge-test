import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Answering controls for [GuessTheCountryQuestion].
///
/// Easy and medium difficulties show four multiple-choice options (the correct
/// country plus three distractors). Distractors are drawn from other
/// GuessTheCountry questions in the bank, preferring the same continent, and
/// are seeded from the question id so the options are identical after a resume
/// or a rebuild. Hard difficulty shows a text field graded with the existing
/// normalization, with a submit button and keyboard submit.
class SoloGuessTheCountryControls extends StatefulWidget {
  final GuessTheCountryQuestion question;
  final List<BaseQuestion> bank;
  final void Function(String encodedAnswer) onAnswer;

  const SoloGuessTheCountryControls({
    super.key,
    required this.question,
    required this.bank,
    required this.onAnswer,
  });

  @override
  State<SoloGuessTheCountryControls> createState() =>
      _SoloGuessTheCountryControlsState();
}

class _SoloGuessTheCountryControlsState
    extends State<SoloGuessTheCountryControls> {
  String? _selected;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool get _isMultipleChoice => widget.question.difficulty != Difficulty.hard;

  List<String> _options() {
    final correct = widget.question.targetCountry;
    final rng = Random(widget.question.id.hashCode);

    final sameContinent = <String>{};
    final otherContinent = <String>{};
    for (final q in widget.bank.whereType<GuessTheCountryQuestion>()) {
      if (q.id == widget.question.id || q.targetCountry == correct) continue;
      if (q.continent == widget.question.continent) {
        sameContinent.add(q.targetCountry);
      } else {
        otherContinent.add(q.targetCountry);
      }
    }

    final distractors = <String>{};
    final sameList = sameContinent.toList()..shuffle(rng);
    final otherList = otherContinent.toList()..shuffle(rng);
    for (final c in sameList) {
      if (distractors.length >= 3) break;
      distractors.add(c);
    }
    for (final c in otherList) {
      if (distractors.length >= 3) break;
      distractors.add(c);
    }
    if (distractors.length < 3) {
      final fallback =
          widget.bank
              .whereType<GuessTheCountryQuestion>()
              .where((q) => q.targetCountry != correct)
              .map((q) => q.targetCountry)
              .toSet()
            ..removeAll(distractors);
      final fallbackList = fallback.toList()..shuffle(rng);
      for (final c in fallbackList) {
        if (distractors.length >= 3) break;
        distractors.add(c);
      }
    }

    final options = [...distractors, correct]..shuffle(rng);
    return options;
  }

  void _select(String country) {
    setState(() {
      _selected = country;
    });
    widget.onAnswer(country);
  }

  void _submitText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onAnswer(text);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.question.clues.isNotEmpty) ...[
          Text(
            l10n.soloGuessTheCountryHint,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          for (var i = 0; i < widget.question.clues.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingXs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${i + 1}.',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      widget.question.clues[i].text,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppDimensions.spacingMd),
        ],
        if (_isMultipleChoice) ...[
          for (final option in _options())
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
              child: AppCard(
                color: _selected == option
                    ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                    : null,
                onTap: () => _select(option),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  child: Row(
                    children: [
                      Expanded(child: Text(option, style: textTheme.bodyLarge)),
                    ],
                  ),
                ),
              ),
            ),
        ] else ...[
          AppTextField(
            controller: _controller,
            focusNode: _focusNode,
            hint: l10n.soloGuessTheCountryHint,
            textInputAction: TextInputAction.done,
            onChanged: (_) => setState(() {}),
            onFieldSubmitted: (_) => _submitText(),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          PrimaryButton(
            label: l10n.soloValidate,
            icon: Icons.send,
            onPressed: _controller.text.trim().isNotEmpty ? _submitText : null,
          ),
        ],
      ],
    );
  }
}
