import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    required this.text,
    super.key,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.letterSpacing,
    this.underline,
    this.fontFamily,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? letterSpacing;
  final bool? underline;
  final String? fontFamily;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style:
          style ??
          style?.copyWith(
            color: color ?? style?.color ?? AppPallete.blackColor,
            fontSize: fontSize ?? style?.fontSize ?? size.width * numD035,
            fontWeight: fontWeight ?? style?.fontWeight,
            letterSpacing: letterSpacing ?? style?.letterSpacing ?? 0.0,
            fontFamily: fontFamily ?? AppConstants.fontFamily,
            decoration: (underline ?? false) ? TextDecoration.underline : null,
          ) ??
          context.bodyMedium.copyWith(
            color: color ?? AppPallete.blackColor,
            fontSize: fontSize ?? size.width * numD035,
            fontWeight: fontWeight ?? FontWeight.w400,
            letterSpacing: letterSpacing ?? 0.0,
            fontFamily: fontFamily ?? AppConstants.fontFamily,
            decoration: (underline ?? false) ? TextDecoration.underline : null,
          ),
    );
  }
}
