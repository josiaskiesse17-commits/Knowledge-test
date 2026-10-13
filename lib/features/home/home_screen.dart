import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_test/app/router.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/widgets/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final contentWidth = maxWidth > AppDimensions.maxContentWidth
                ? AppDimensions.maxContentWidth
                : maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppDimensions.spacingXl),
                      Text(
                        'Bienvenue',
                        style: textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingSm),
                      Text(
                        'Organisez des quiz en personne avec vos amis',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingXxl),
                      _buildMenuButton(
                        context,
                        label: AppStrings.newGame,
                        icon: Icons.play_circle_outline,
                        onTap: () => context.go(AppRoute.gameSetup.path),
                        isPrimary: true,
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _buildMenuButton(
                        context,
                        label: AppStrings.questionLibrary,
                        icon: Icons.menu_book_outlined,
                        onTap: () => context.go(AppRoute.questionLibrary.path),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _buildMenuButton(
                        context,
                        label: AppStrings.sessionHistory,
                        icon: Icons.history_outlined,
                        onTap: () => context.go(AppRoute.sessionHistory.path),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _buildMenuButton(
                        context,
                        label: AppStrings.settings,
                        icon: Icons.settings_outlined,
                        onTap: () => context.go(AppRoute.settings.path),
                      ),
                      const Spacer(),
                      Text(
                        'v0.1.0',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isPrimary) {
      return PrimaryButton(
        label: label,
        icon: icon,
        onPressed: onTap,
      );
    }

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: colorScheme.primary, size: AppDimensions.iconMd),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
            size: AppDimensions.iconMd,
          ),
        ],
      ),
    );
  }
}