import 'dart:developer' as devtools show log;
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
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final double? emptyPhotoPadding;
  final BoxFit fit;
  final Color loaderColor;

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
          child: Placeholder(
            color: AppPallete.transparentColor,
            child: Icon(
              Icons.image_not_supported,
              color: AppPallete.greyColor400,
              size: size.width * numD12,
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
