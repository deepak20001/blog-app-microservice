import 'dart:developer' as devtools show log;
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../theme/app_pallete.dart';
import 'loader.dart';

class CommonCachedImage extends StatelessWidget {
  const CommonCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.emptyPhotoPadding,
    this.fit = BoxFit.cover,
    this.loaderColor = AppPallete.primaryColor,
    this.text = '',
    this.textStyle,
    this.textContainerMargin,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final double? emptyPhotoPadding;
  final BoxFit fit;
  final Color loaderColor;
  final String text;
  final TextStyle? textStyle;
  final EdgeInsets? textContainerMargin;

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return '${words[0][0]}${words[words.length - 1][0]}'.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => Container(
        padding: EdgeInsets.all(emptyPhotoPadding ?? size.width * numD05),
        color: AppPallete.greyColor300.withValues(alpha: numD2),
        width: width ?? double.maxFinite,
        height: height ?? double.maxFinite,
        child: Loader(color: loaderColor),
      ),
      errorWidget: (context, url, error) {
        devtools.log('Error loading image: $error');
        return Container(
          color: AppPallete.greyColor300.withValues(alpha: numD2),
          width: width ?? double.maxFinite,
          height: height ?? double.maxFinite,
          child: text.isNotEmpty
              ? Center(
                  child: Container(
                    margin:
                        textContainerMargin ??
                        EdgeInsets.all(size.width * numD02),
                    decoration: BoxDecoration(
                      color: AppPallete.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppPallete.primaryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: CommonText(
                      text: _getInitials(text),
                      style:
                          textStyle ??
                          context.bodyMedium.copyWith(
                            color: AppPallete.primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ),
                )
              : Placeholder(
                  color: AppPallete.transparentColor,
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppPallete.greyColor400,
                  ),
                ),
        );
      },
      width: width,
      height: height,
      fit: fit,
    );
  }
}
