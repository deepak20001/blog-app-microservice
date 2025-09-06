import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.textStyle,
    this.backgroundColor = AppPallete.primaryColor,
    this.foregroundColor = AppPallete.whiteColor,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.loaderColor = AppPallete.whiteColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.elevation,
    this.loaderSize,
    this.loaderPadding,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Color loaderColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final double? elevation;
  final double? loaderSize;
  final double? loaderPadding;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ElevatedButton(
      style:
          ElevatedButton.styleFrom(
            elevation: elevation,
            shadowColor: elevation == 0 ? Colors.transparent : null,
            splashFactory: elevation == 0 ? NoSplash.splashFactory : null,
            padding: EdgeInsets.zero,
            minimumSize: Size(
              minWidth ?? double.infinity,
              minHeight ?? size.height * numD065,
            ),
            maximumSize: Size(
              maxWidth ?? double.infinity,
              maxHeight ?? size.height * numD065,
            ),
            textStyle:
                textStyle ??
                context.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: foregroundColor,
                  fontSize: size.width * numD038,
                ),

            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor:
                disabledBackgroundColor ?? AppPallete.primaryColor,
            disabledForegroundColor: disabledForegroundColor ?? foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? size.width * numD03,
              ),
              side: borderColor != null
                  ? BorderSide(color: borderColor!, width: borderWidth ?? 1)
                  : BorderSide.none,
            ),
          ).copyWith(
            elevation: elevation == 0
                ? WidgetStateProperty.resolveWith<double?>((states) => 0.0)
                : null,
          ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              height: size.width * (loaderSize ?? numD12),
              child: context.paddingAll(
                numD01,
                child: Loader(color: loaderColor),
              ),
            )
          : Text(text),
    );
  }
}
