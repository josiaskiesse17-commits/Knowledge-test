import 'package:flutter/material.dart';
import 'package:knowledge_test/core/constants/app_dimensions.dart';
import 'package:knowledge_test/core/constants/app_strings.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.validator,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          onTap: onTap,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: AppDimensions.iconMd, color: colorScheme.onSurfaceVariant)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMd,
              vertical: AppDimensions.spacingMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: colorScheme.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
            ),
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
            errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
          ),
        ),
      ],
    );
  }
}

class PlayerNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final VoidCallback? onClear;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const PlayerNameField({
    super.key,
    required this.controller,
    this.errorText,
    this.onClear,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      hint: AppStrings.playerNameHint,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: Icon(Icons.clear, size: AppDimensions.iconMd),
              onPressed: onClear,
              tooltip: 'Effacer',
            )
          : null,
    );
  }
}