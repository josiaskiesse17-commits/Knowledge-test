import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/app/router.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final AppRoute? backRoute;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    this.backRoute,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: backRoute != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go(backRoute!.path),
              )
            : null,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXl),
                Text(
                  title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingMd),
                Text(
                  description,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXl),
                Text(
                  AppStrings.comingSoon,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}