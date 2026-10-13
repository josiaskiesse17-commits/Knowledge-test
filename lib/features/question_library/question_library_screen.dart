import 'package:flutter/material.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/widgets/placeholder_screen.dart';

class QuestionLibraryScreen extends StatelessWidget {
  const QuestionLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Bibliothèque de questions',
      icon: Icons.menu_book_outlined,
      description: 'Gérez vos questions, catégories et importez de nouveaux quiz.',
      backRoute: AppRoute.home,
    );
  }
}