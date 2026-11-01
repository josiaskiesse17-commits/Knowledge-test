import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Answering controls for the two solo-supported modes.
///
/// WhichCameFirst shows two tappable event cards. FactOrCap shows either
/// true/false buttons or tappable statements depending on the variation.
class SoloQuestionControls extends StatelessWidget {
  final BaseQuestion question;
  final int? selectedIndex;
  final void Function(int index) onIndexSelected;
  final void Function(String text) onTextSubmitted;

  const SoloQuestionControls({
    super.key,
    required this.question,
    this.selectedIndex,
    required this.onIndexSelected,
    required this.onTextSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    switch (question) {
      case WhichCameFirstQuestion():
        return _WhichCameFirstControls(
          question: question as WhichCameFirstQuestion,
          selectedIndex: selectedIndex,
          onIndexSelected: onIndexSelected,
        );
      case FactOrCapQuestion():
        return _FactOrCapControls(
          question: question as FactOrCapQuestion,
          selectedIndex: selectedIndex,
          onIndexSelected: onIndexSelected,
          onTextSubmitted: onTextSubmitted,
        );
      default:
        return _UnsupportedControls(question);
    }
  }
}

/// Two tappable event cards for WhichCameFirst.
class _WhichCameFirstControls extends StatelessWidget {
  final WhichCameFirstQuestion question;
  final int? selectedIndex;
  final void Function(int index) onIndexSelected;

  const _WhichCameFirstControls({
    required this.question,
    this.selectedIndex,
    required this.onIndexSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.events.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: _SelectableCard(
              onTap: () => onIndexSelected(i),
              isSelected: selectedIndex == i,
              colorScheme: colorScheme,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      question.events[i].label,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (selectedIndex == i)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: AppDimensions.iconMd,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// True/false buttons or tappable statements for FactOrCap.
class _FactOrCapControls extends StatelessWidget {
  final FactOrCapQuestion question;
  final int? selectedIndex;
  final void Function(int index) onIndexSelected;
  final void Function(String text) onTextSubmitted;

  const _FactOrCapControls({
    required this.question,
    this.selectedIndex,
    required this.onIndexSelected,
    required this.onTextSubmitted,
  });

  bool get _isTrueFalse =>
      question.lieStatementIndex == null &&
      question.falseStatementIndex == null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isTrueFalse) {
      final isTrue = question.statements.isNotEmpty
          ? question.statements.first.isTrue
          : false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.statements.isNotEmpty
                ? question.statements.first.text
                : '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            children: [
              Expanded(
                child: _SelectableCard(
                  onTap: () => onTextSubmitted(isTrue ? 'true' : 'false'),
                  isSelected: selectedIndex == (isTrue ? 1 : 0),
                  colorScheme: colorScheme,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    child: Row(
                      children: [
                        Icon(
                          selectedIndex == (isTrue ? 1 : 0)
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: selectedIndex == (isTrue ? 1 : 0)
                              ? colorScheme.primary
                              : colorScheme.outline,
                          size: AppDimensions.iconMd,
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: Text(
                            'Vrai',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: _SelectableCard(
                  onTap: () => onTextSubmitted(isTrue ? 'false' : 'true'),
                  isSelected: selectedIndex == (isTrue ? 0 : 1),
                  colorScheme: colorScheme,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    child: Row(
                      children: [
                        Icon(
                          selectedIndex == (isTrue ? 0 : 1)
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: selectedIndex == (isTrue ? 0 : 1)
                              ? colorScheme.primary
                              : colorScheme.outline,
                          size: AppDimensions.iconMd,
                        ),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Expanded(
                          child: Text(
                            'Faux',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Statement modes: tap the statement that is false (or the lie).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < question.statements.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSm),
            child: _SelectableCard(
              onTap: () => onIndexSelected(i),
              isSelected: selectedIndex == i,
              colorScheme: colorScheme,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Text(
                      String.fromCharCode(65 + i),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingSm),
                  Expanded(
                    child: Text(
                      question.statements[i].text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  if (selectedIndex == i)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: AppDimensions.iconMd,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A tappable card with a selection indicator.
class _SelectableCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final ColorScheme colorScheme;
  final Widget child;

  const _SelectableCard({
    required this.onTap,
    required this.isSelected,
    required this.colorScheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.5)
          : null,
      child: child,
    );
  }
}

/// Placeholder for modes not yet supported in solo.
class _UnsupportedControls extends StatelessWidget {
  final BaseQuestion question;

  const _UnsupportedControls(this.question);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.help_outline,
              color: colorScheme.onSurfaceVariant,
              size: AppDimensions.iconLg,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              l10n.soloNotSupportedYet,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            TextButtonWidget(label: l10n.soloSkipQuestion, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
