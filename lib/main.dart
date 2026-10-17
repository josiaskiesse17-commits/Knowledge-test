import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/app/theme.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/theme_providers.dart';
import 'package:knowledge_test/repositories/asset_question_repository.dart';
import 'package:knowledge_test/repositories/question_repository.dart';

typedef QuestionRepositoryLoader = Future<QuestionRepository> Function();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StartupApp());
}

class StartupApp extends StatefulWidget {
  final QuestionRepositoryLoader loader;

  const StartupApp({super.key, this.loader = AssetQuestionRepository.load});

  @override
  State<StartupApp> createState() => _StartupAppState();
}

class _StartupAppState extends State<StartupApp> {
  late Future<QuestionRepository> _loaderFuture;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _loaderFuture = widget.loader();
  }

  void _retry() {
    setState(() {
      _startLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuestionRepository>(
      future: _loaderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Impossible de charger la banque de questions.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _retry,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final repository = snapshot.data!;
        return ProviderScope(
          overrides: [questionRepositoryProvider.overrideWithValue(repository)],
          child: const MainApp(),
        );
      },
    );
  }
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    // The history is read in the background: the game starts without waiting
    // for the storage.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionHistoryProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    // A finished session is saved exactly once, as soon as it is completed:
    // the listener and the final ranking screen share the same id guard, so
    // navigating right after the completion cannot write it twice.
    ref.listen(gameControllerProvider, (previous, next) {
      final wasCompleted = previous?.isCompleted ?? false;
      if (next.isCompleted && !wasCompleted) {
        ref.read(sessionHistoryProvider.notifier).persistCompleted(next);
      }
    });

    return MaterialApp.router(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      theme: createLightTheme(),
      darkTheme: createDarkTheme(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
