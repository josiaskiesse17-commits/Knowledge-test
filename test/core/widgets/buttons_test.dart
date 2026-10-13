import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/app/theme.dart';
import 'package:knowledge_test/core/widgets/buttons.dart';

/// The label line box the theme asks for (labelLarge = 16 px at height 1.4).
const double _labelLineBox = 22.0;

void main() {
  Widget buttonHost(Widget child) => MaterialApp(
        theme: createLightTheme(),
        home: Scaffold(
          body: Center(child: SizedBox(width: 360, child: child)),
        ),
      );

  /// Checks that the label is drawn at its full line box and that this box
  /// stays inside the button, so nothing crosses or cuts the text.
  void expectLabelFullyVisible(
    WidgetTester tester,
    String label, {
    required double buttonHeight,
  }) {
    final textBox = tester.renderObject<RenderBox>(find.text(label));
    // The label keeps the height the theme asks for instead of being squeezed.
    expect(textBox.size.height, greaterThanOrEqualTo(_labelLineBox - 0.5));

    final buttonBox = tester.renderObject<RenderBox>(
      find.ancestor(
        of: find.text(label),
        matching: find.byType(ConstrainedBox),
      ).first,
    );
    expect(buttonBox.size.height, moreOrLessEquals(buttonHeight, epsilon: 1));

    final textTopLeft = textBox.localToGlobal(Offset.zero);
    final buttonTopLeft = buttonBox.localToGlobal(Offset.zero);
    expect(
      textTopLeft.dy,
      greaterThanOrEqualTo(buttonTopLeft.dy),
      reason: 'the top of the label is cut by the button',
    );
    expect(
      textTopLeft.dy + textBox.size.height,
      lessThanOrEqualTo(buttonTopLeft.dy + buttonBox.size.height),
      reason: 'the bottom of the label is cut by the button',
    );
    expect(tester.takeException(), isNull);
  }

  group('Button labels are never crossed or clipped', () {
    testWidgets('the primary button keeps its label inside the 48 dp height',
        (tester) async {
      await tester.pumpWidget(
        buttonHost(
          const PrimaryButton(
            label: 'Nouvelle partie',
            icon: Icons.play_circle_outline,
          ),
        ),
      );
      expectLabelFullyVisible(tester, 'Nouvelle partie', buttonHeight: 48);
    });

    testWidgets('the secondary button keeps a long French label visible',
        (tester) async {
      await tester.pumpWidget(
        buttonHost(
          const SecondaryButton(
            label: 'Indice suivant (1/6)',
            icon: Icons.lightbulb_outline,
          ),
        ),
      );
      expectLabelFullyVisible(tester, 'Indice suivant (1/6)', buttonHeight: 48);
    });

    testWidgets('a very long French label is not cut vertically',
        (tester) async {
      await tester.pumpWidget(
        buttonHost(
          const PrimaryButton(
            label: 'Configurer une nouvelle partie entre amis',
          ),
        ),
      );
      final textBox = tester.renderObject<RenderBox>(
        find.text('Configurer une nouvelle partie entre amis'),
      );
      expect(textBox.size.height, greaterThanOrEqualTo(_labelLineBox - 0.5));
    });

    testWidgets('the text button keeps its label visible', (tester) async {
      await tester.pumpWidget(
        buttonHost(
          const TextButtonWidget(
            label: 'Ajouter un joueur',
            icon: Icons.person_add_outlined,
          ),
        ),
      );
      // labelMedium = 14 px at height 1.4.
      final textBox =
          tester.renderObject<RenderBox>(find.text('Ajouter un joueur'));
      expect(textBox.size.height, greaterThanOrEqualTo(19.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('the dark theme renders the same label height',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: createDarkTheme(),
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 360,
                child: PrimaryButton(
                  label: 'Question suivante',
                  icon: Icons.arrow_forward,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      );
      expectLabelFullyVisible(tester, 'Question suivante', buttonHeight: 48);
    });

    testWidgets('buttons grow instead of clipping when the text is scaled up',
        (tester) async {
      final textScaler = const TextScaler.linear(1.5);
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: textScaler),
          child: MaterialApp(
            theme: createLightTheme(),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 360,
                  child: PrimaryButton(
                    label: 'Nouvelle partie',
                    icon: Icons.play_circle_outline,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final textBox =
          tester.renderObject<RenderBox>(find.text('Nouvelle partie'));
      final buttonBox = tester.renderObject<RenderBox>(
        find.ancestor(
          of: find.text('Nouvelle partie'),
          matching: find.byType(ConstrainedBox),
        ).first,
      );

      // The label keeps its scaled height, and the button grows to hold it.
      expect(textBox.size.height, greaterThan(_labelLineBox));
      expect(
        buttonBox.size.height,
        greaterThanOrEqualTo(textBox.size.height),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
