import 'package:flutter/material.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/widgets/placeholder_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Paramètres',
      icon: Icons.settings_outlined,
      description: 'Configurez l\'application, les préférences de jeu et l\'apparence.',
      backRoute: AppRoute.home,
    );
  }
}