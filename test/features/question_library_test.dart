import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_test/app/theme.dart';
import 'package:knowledge_test/data/sample_question_bank.dart';
import 'package:knowledge_test/features/question_library/question_library_screen.dart';
import 'package:knowledge_test/features/question_library/question_detail_view.dart';
import 'package:knowledge_test/features/settings/settings_screen.dart';
import 'package:knowledge_test/models/questions/index.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/theme_providers.dart';
import 'package:knowledge_test/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  /// Pumps a widget wide enough to trigger a layout, filling the screen.
  Future<StorageService> pumpWithSize(
    WidgetTester tester,
    Widget widget, {
    required Size size,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final storage = await StorageService.create();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWith((ref) async => storage)],
        child: MaterialApp(home: widget),
      ),
    );
    await tester.pumpAndSettle();
    return storage;
  }

  /// Pumps a widget inside a MaterialApp that follows the app theme mode, so
  /// theme switching can be observed on the rendered app.
  Future<void> pumpThemed(
    WidgetTester tester,
    Widget widget, {
    required Size size,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final themeMode = ref.watch(themeModeProvider);
            return MaterialApp(
              theme: createLightTheme(),
              darkTheme: createDarkTheme(),
              themeMode: themeMode,
              home: widget,
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpNarrow(WidgetTester tester, Widget widget) =>
      pumpWithSize(tester, widget, size: const Size(395, 845));

  Widget libraryUnderTest() => const QuestionLibraryScreen();

  /// The filter section is collapsed by default: opening it reveals the chips.
  Future<void> openFilters(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.expand_more).first);
    await tester.pumpAndSettle();
  }

  group('Question library', () {
    testWidgets('shows all questions of the library', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      expect(find.text('Bibliothèque de questions'), findsOneWidget);
      expect(find.text('117 questions'), findsOneWidget);
      expect(find.text('Lequel est arrivé en premier : le premier pas de '
          'l\'Homme sur la Lune ou le premier vol spatial habité par une femme ?'),
          findsOneWidget);
    });

    testWidgets('filters by mode', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());
      expect(find.text('117 questions'), findsOneWidget);

      await openFilters(tester);
      await tester.tap(find.text('Fait ou Fake').first);
      await tester.pumpAndSettle();

      // The sample bank holds 7 Fact-or-cap questions.
      expect(find.text('25 questions'), findsOneWidget);
    });

    testWidgets('shows the questions number by difficulty', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      await openFilters(tester);
      await tester.tap(find.text('Facile').first);
      await tester.pumpAndSettle();

      // 11 easy questions in the sample bank.
      expect(find.text('35 questions'), findsOneWidget);
    });

    testWidgets('searching filters the list', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      // Searching by id returns exactly that question.
      await tester.enterText(find.byType(TextField), 'hm-001');
      await tester.pumpAndSettle();

      expect(find.text('1 question'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.textContaining('Conseil de sécurité'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('an empty search keeps every question', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      await tester.enterText(find.byType(TextField), 'hm-001');
      await tester.pumpAndSettle();
      expect(find.text('1 question'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(find.text('117 questions'), findsOneWidget);
    });

    testWidgets('a search without a match shows the empty state', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      await tester.enterText(find.byType(TextField), 'zzzz-introuvable');
      await tester.pumpAndSettle();

      expect(find.text('Aucune question ne correspond'), findsOneWidget);
      expect(find.text('0 question'), findsOneWidget);
    });

    testWidgets('clearing the filters restores every question', (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      await openFilters(tester);
      await tester.tap(find.text('Difficile').first);
      await tester.pumpAndSettle();
      expect(find.text('22 questions'), findsOneWidget);

      await tester.tap(find.text('Réinitialiser'));
      await tester.pumpAndSettle();
      expect(find.text('117 questions'), findsOneWidget);
    });

    testWidgets('the library shows a question with answer and explanation',
        (tester) async {
      await pumpNarrow(tester, libraryUnderTest());

      // Searching by id narrows the list to that single question.
      await tester.enterText(find.byType(TextField), 'hm-001');
      await tester.pumpAndSettle();

      // The card shows the question text, which is what the quizmaster taps.
      await tester.tap(find.descendant(
        of: find.byType(ListView),
        matching: find.textContaining('Conseil de sécurité'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Bonne réponse'), findsOneWidget);
      expect(find.text('Explication'), findsOneWidget);
      expect(find.textContaining('Source :'), findsOneWidget);
      expect(find.textContaining('Groupe de fait :'), findsOneWidget);
    });

    testWidgets('the detail view shows the question metadata and answers',
        (tester) async {
      // A HowMuch question renders its expected value and accepted range.
      final howMuch = SampleQuestionBank.questions
          .whereType<HowMuchQuestion>()
          .first;

      await pumpNarrow(
        tester,
        QuestionDetailView(question: howMuch),
      );

      expect(find.text('Combien ?'), findsOneWidget);
      expect(find.text('Bonne réponse'), findsOneWidget);
      expect(howMuch.answer.unitFr, isNotNull);
    });

    testWidgets('the library opens on a wide window', (tester) async {
      await pumpWithSize(
        tester,
        libraryUnderTest(),
        size: const Size(1280, 900),
      );

      // A tablet or desktop layout shows the filters and a detail pane.
      expect(find.text('Bibliothèque de questions'), findsOneWidget);
      expect(find.text('Sélectionnez une question'), findsOneWidget);
      expect(find.text('117 questions'), findsOneWidget);

      await tester.tap(find.text('Lequel est arrivé en premier : le premier pas '
          'de l\'Homme sur la Lune ou le premier vol spatial habité par une femme ?'));
      await tester.pumpAndSettle();

      expect(find.text('Bonne réponse'), findsOneWidget);
    });
  });

  group('Settings', () {
    testWidgets('shows the theme choice', (tester) async {
      await pumpNarrow(tester, const SettingsScreen());

      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Apparence'), findsOneWidget);
      expect(find.text('Clair'), findsOneWidget);
      expect(find.text('Sombre'), findsOneWidget);
      expect(find.text('Système'), findsOneWidget);
    });

    testWidgets('switching to the dark theme applies it to the whole app',
        (tester) async {
      await pumpThemed(
        tester,
        const SettingsScreen(),
        size: const Size(395, 845),
      );

      // The app starts on the light theme.
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, ThemeMode.system);

      await tester.tap(find.text('Sombre'));
      await tester.pumpAndSettle();

      final dark = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(dark.themeMode, ThemeMode.dark);
      // The theme handed to MaterialApp really is the dark one.
      expect(dark.darkTheme!.brightness, Brightness.dark);

      // The screens below read the dark theme.
      expect(
        Theme.of(tester.element(find.text('Paramètres'))).brightness,
        Brightness.dark,
      );
    });

    testWidgets('the preference is persisted locally', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final storage = await StorageService.create();

      await pumpThemed(
        tester,
        const SettingsScreen(),
        size: const Size(395, 845),
      );

      await tester.tap(find.text('Sombre'));
      await tester.pumpAndSettle();

      expect(await storage.getThemeMode(), ThemeMode.dark);
    });

    testWidgets('a restored dark preference is applied after a restart',
        (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'theme_mode': 'dark',
      });

      await pumpThemed(
        tester,
        const SettingsScreen(),
        size: const Size(395, 845),
      );

      // The whole app is rendered in dark mode after the restart.
      await tester.pumpAndSettle();
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.themeMode, ThemeMode.dark);
      expect(
        Theme.of(tester.element(find.text('Paramètres'))).brightness,
        Brightness.dark,
      );
    });

    testWidgets('the settings screen offers a wide theme selector',
        (tester) async {
      await pumpWithSize(
        tester,
        const SettingsScreen(),
        size: const Size(1280, 900),
      );

      expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
      expect(find.text('Clair'), findsOneWidget);
    });

    testWidgets('the data section opens the session history', (tester) async {
      await pumpNarrow(tester, const SettingsScreen());

      expect(find.text('Données'), findsOneWidget);
      expect(find.text('Ouvrir l\'historique des sessions'), findsOneWidget);
    });
  });
}
