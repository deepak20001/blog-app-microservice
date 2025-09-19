import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/profile/viewmodel/profile_bloc.dart';
import 'package:flutter/material.dart';

class BuildProfileHeader extends StatelessWidget {
  const BuildProfileHeader({
    super.key,
    required this.size,
    required this.profileBloc,
  });
  final Size size;
  final ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    final profileData = profileBloc.state.profileData;

    return Column(
      spacing: size.width * numD01,
      children: [
        Container(
          width: size.width * numD25,
          height: size.width * numD25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppPallete.primaryColor, width: 3),
          ),
          child: ClipOval(
            child: CommonCachedImage(
              textContainerMargin: EdgeInsets.all(size.width * numD04),
              imageUrl: profileData.avatar,
              width: size.width * numD25,
              height: size.width * numD25,
              fit: BoxFit.cover,
              text: profileData.username,
              textStyle: context.bodyMedium.copyWith(
                fontSize: size.width * numD08,
                color: AppPallete.primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        CommonText(
          text: profileData.username,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppPallete.textPrimary,
          ),
        ),
        CommonText(
          text: profileData.bio,
          style: context.bodyMedium.copyWith(color: AppPallete.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ],
    );
  }
}
