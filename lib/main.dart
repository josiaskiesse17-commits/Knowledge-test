import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/app/theme.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quiz Master',
      debugShowCheckedModeBanner: false,
      theme: createLightTheme(),
      routerConfig: appRouter,
    );
  }
}