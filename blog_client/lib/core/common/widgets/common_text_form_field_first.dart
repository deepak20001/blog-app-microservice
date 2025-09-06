import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    required this.controller,
    required this.hintText,
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.hintStyle,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.focusNode,
    this.letterSpacing = 0.0,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.autofocus = false,
    this.textColorOnReadOnly,
    this.readOnlyTextStyle,
    this.maxLength,
    this.showCharacterCount = false,
    this.label,
    this.labelStyle,
    // Border customization
    this.borderType = BorderType.outline,
    this.borderRadius = 8.0,
    this.borderWidth = 1.5,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    // Content padding
    this.contentPadding,
    // Text style
    this.textStyle,
    this.cursorColor,
    // Additional customization
    this.enabled = true,
    this.autovalidateMode,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextInputType keyboardType;
  final TextStyle? hintStyle;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final Color? fillColor;
  final FocusNode? focusNode;
  final double letterSpacing;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final bool autofocus;
  final Color? textColorOnReadOnly;
  final TextStyle? readOnlyTextStyle;
  final int? maxLength;
  final bool showCharacterCount;
  final String? label;
  final TextStyle? labelStyle;

  // Border customization
  final BorderType borderType;
  final double borderRadius;
  final double borderWidth;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;

  // Content padding
  final EdgeInsetsGeometry? contentPadding;

  // Text style
  final TextStyle? textStyle;
  final Color? cursorColor;

  // Additional properties
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  InputBorder _buildBorder(Color color) {
    switch (borderType) {
      case BorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: color, width: borderWidth),
        );
      case BorderType.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: borderWidth),
        );
      case BorderType.none:
        return InputBorder.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default colors based on theme
    final Color defaultEnabledBorderColor =
        enabledBorderColor ??
        (theme.brightness == Brightness.dark
            ? AppPallete.greyColor
            : AppPallete.greyColor400);
    final Color defaultFocusedBorderColor =
        focusedBorderColor ?? AppPallete.primaryColor;
    final Color defaultErrorBorderColor =
        errorBorderColor ?? AppPallete.errorColor;
    final Color defaultDisabledBorderColor =
        disabledBorderColor ?? AppPallete.greyColor300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style:
                  labelStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? AppPallete.greyColor300
                        : AppPallete.greyColor700,
                  ),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          onTap: onTap,
          focusNode: focusNode,
          autofocus: autofocus,
          readOnly: readOnly,
          enabled: enabled,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          autovalidateMode:
              autovalidateMode ?? AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
          obscuringCharacter: '●',
          keyboardType: keyboardType,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          validator: validator,
          cursorColor: cursorColor ?? defaultFocusedBorderColor,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          buildCounter: (showCharacterCount && maxLength != null)
              ? (
                  BuildContext context, {
                  required int currentLength,
                  required bool isFocused,
                  int? maxLength,
                }) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '$currentLength/${maxLength ?? 0}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: currentLength > (maxLength ?? 0)
                            ? defaultErrorBorderColor
                            : theme.hintColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  );
                }
              : (maxLength != null
                    ? (
                        BuildContext context, {
                        required int currentLength,
                        required bool isFocused,
                        int? maxLength,
                      }) => const SizedBox.shrink()
                    : null),
          style: enabled && !readOnly
              ? textStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      letterSpacing: letterSpacing,
                    )
              : readOnlyTextStyle ??
                    textStyle?.copyWith(
                      color: textColorOnReadOnly ?? theme.disabledColor,
                    ) ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: textColorOnReadOnly ?? theme.disabledColor,
                      letterSpacing: letterSpacing,
                    ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                  letterSpacing: letterSpacing,
                ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: fillColor != null,
            fillColor: fillColor,
            isDense: true,
            contentPadding:
                contentPadding ??
                (borderType == BorderType.outline
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                    : const EdgeInsets.symmetric(horizontal: 0, vertical: 16)),
            border: _buildBorder(defaultEnabledBorderColor),
            enabledBorder: _buildBorder(defaultEnabledBorderColor),
            focusedBorder: _buildBorder(defaultFocusedBorderColor),
            errorBorder: _buildBorder(defaultErrorBorderColor),
            focusedErrorBorder: _buildBorder(defaultFocusedBorderColor),
            disabledBorder: _buildBorder(defaultDisabledBorderColor),
            errorMaxLines: 2,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: defaultErrorBorderColor,
            ),
          ),
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        ),
      ],
    );
  }
}

enum BorderType { outline, underline, none }
