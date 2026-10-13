import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/app/theme.dart';
import 'package:knowledge_test/providers/game_providers.dart';
import 'package:knowledge_test/providers/session_history_providers.dart';
import 'package:knowledge_test/providers/theme_providers.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
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