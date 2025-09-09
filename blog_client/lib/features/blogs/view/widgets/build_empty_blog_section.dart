import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BuildEmptyBlogSection extends StatelessWidget {
  const BuildEmptyBlogSection({
    super.key,
    required this.size,
    required this.onRefresh,
  });
  final Size size;
  final Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppPallete.primaryColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: size.width * numD2,
              color: AppPallete.greyColor300,
            ),
            const SizedBox(height: 12),
            CommonText(
              text: 'No blogs found',
              style: context.titleMedium.copyWith(
                color: AppPallete.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            CommonText(
              text: 'Try adjusting filters or searching something else.',
              style: context.bodySmall.copyWith(
                color: AppPallete.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
