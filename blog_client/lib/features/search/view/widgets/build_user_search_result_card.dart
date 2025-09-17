import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BuildUserSearchResultCard extends StatelessWidget {
  const BuildUserSearchResultCard({
    super.key,
    required this.size,
    required this.user,
  });

  final Size size;
  final ProfileModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: size.width * numD02),
      padding: EdgeInsets.all(size.width * numD03),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(size.width * numD03),
        border: Border.all(color: AppPallete.greyColor300, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppPallete.greyColor300.withValues(alpha: numD3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        spacing: size.width * numD02,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppPallete.primaryColor.withValues(alpha: numD3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CommonCachedImage(
                imageUrl: user.avatar,
                width: size.width * numD12,
                height: size.width * numD12,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: CommonText(
              text: user.username,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppPallete.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
