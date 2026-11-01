import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';

/// Answering controls for [HowMuchQuestion].
///
/// A numeric input (decimal and negative allowed) with the unit displayed next
/// to it. The Validate button is disabled while the field is empty or
/// unparsable, and a localized error is shown for invalid input.
class SoloHowMuchControls extends StatefulWidget {
  final HowMuchQuestion question;
  final void Function(String encodedAnswer) onAnswer;

  const SoloHowMuchControls({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<SoloHowMuchControls> createState() => _SoloHowMuchControlsState();
}

class _SoloHowMuchControlsState extends State<SoloHowMuchControls> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  double? get _parsed => double.tryParse(_controller.text.trim());

  bool get _isValid => _controller.text.trim().isNotEmpty && _parsed != null;

  void _onChanged(String value) {
    final trimmed = value.trim();
    setState(() {
      if (trimmed.isEmpty) {
        _errorText = null;
      } else if (double.tryParse(trimmed) == null) {
        _errorText = AppLocalizations.of(context)!.soloHowMuchInvalid;
      } else {
        _errorText = null;
      }
    });
  }

  void _validate() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = AppLocalizations.of(context)!.soloHowMuchInvalid;
      });
      return;
    }
    final value = double.tryParse(text);
    if (value == null) {
      setState(() {
        _errorText = AppLocalizations.of(context)!.soloHowMuchInvalid;
      });
      return;
    }
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
    final unit = widget.question.answer.unitFr ?? widget.question.answer.unit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                controller: _controller,
                focusNode: _focusNode,
                hint: l10n.soloHowMuchHint,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                textInputAction: TextInputAction.done,
                errorText: _errorText,
                onChanged: _onChanged,
                onFieldSubmitted: (_) => _validate(),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              unit,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        PrimaryButton(
          label: l10n.soloValidate,
          icon: Icons.check,
          onPressed: _isValid ? _validate : null,
        ),
      ],
    );
  }
}
