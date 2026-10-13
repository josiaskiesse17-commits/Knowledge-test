import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = color ?? colorScheme.surface;
    final radius = borderRadius ?? BorderRadius.circular(AppDimensions.radiusMd);

    final card = Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: radius,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.spacingMd),
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: card,
        ),
      );
    }

    return card;
  }
}

class AppCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final IconData? leadingIcon;

  const AppCardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: AppDimensions.iconLg, color: colorScheme.primary),
          const SizedBox(width: AppDimensions.spacingSm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        ...action != null ? [action!] : [],
      ],
    );
  }
}