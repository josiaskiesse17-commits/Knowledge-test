import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';
import 'package:knowledge_test/l10n/app_localizations.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/services/solo_answer_codec.dart';

/// Answering controls for [PutInOrderQuestion].
///
/// A [ReorderableListView] with drag handles lets the player reorder the items.
/// The initial order is shuffled deterministically from the question id and is
/// never equal to the correct order. Tapping "Validate" encodes the current
/// order with [SoloAnswerCodec.encodePutInOrder].
class SoloPutInOrderControls extends StatefulWidget {
  final PutInOrderQuestion question;
  final void Function(String encodedAnswer) onAnswer;

  const SoloPutInOrderControls({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<SoloPutInOrderControls> createState() => _SoloPutInOrderControlsState();
}

class _SoloPutInOrderControlsState extends State<SoloPutInOrderControls> {
  late List<OrderableItem> _ordered;

  @override
  void initState() {
    super.initState();
    _ordered = _initialOrder();
  }

  @override
  void didUpdateWidget(SoloPutInOrderControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _ordered = _initialOrder();
    }
  }

  List<OrderableItem> _initialOrder() {
    final items = List<OrderableItem>.of(widget.question.items);
    final correctIds = widget.question.correctOrderIds;
    final rng = Random(widget.question.id.hashCode);

    // Keep shuffling until the order differs from the correct one. PutInOrder
    // questions always hold at least two items, so this terminates.
    for (var i = 0; i < 50; i++) {
      items.shuffle(rng);
      final ids = items.map((e) => e.id).toList();
      if (!listEquals(ids, correctIds)) return items;
    }
    return items;
  }

  bool listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _onReorderItem(int oldIndex, int newIndex) {
    setState(() {
      final item = _ordered.removeAt(oldIndex);
      _ordered.insert(newIndex, item);
    });
  }

  void _validate() {
    widget.onAnswer(
      SoloAnswerCodec.encodePutInOrder(_ordered.map((e) => e.id).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.soloPutInOrderInstruction,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSm),
        SizedBox(
          height: 400,
          child: ReorderableListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ordered.length,
            itemBuilder: (context, index) {
              final item = _ordered[index];
              return ListTile(
                key: ValueKey(item.id),
                leading: Icon(
                  Icons.drag_handle,
                  color: colorScheme.onSurfaceVariant,
                  size: AppDimensions.iconMd,
                ),
                title: Text(item.label, style: textTheme.bodyMedium),
                trailing: Text(
                  '${item.referenceValue}${item.unit != null ? ' ${item.unit}' : ''}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
            onReorderItem: _onReorderItem,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        PrimaryButton(
          label: l10n.soloPutInOrderValidate,
          icon: Icons.check,
          onPressed: _validate,
        ),
      ],
    );
  }
}
