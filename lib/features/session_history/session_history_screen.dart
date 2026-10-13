import 'package:flutter/material.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/widgets/placeholder_screen.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Historique des sessions',
      icon: Icons.history_outlined,
      description: 'Consultez les résultats des parties précédentes et les statistiques.',
      backRoute: AppRoute.home,
    );
  }
}