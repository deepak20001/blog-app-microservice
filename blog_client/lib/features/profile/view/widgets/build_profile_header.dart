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
              imageUrl: profileBloc.userProfileImage,
              width: size.width * numD25,
              height: size.width * numD25,
              fit: BoxFit.cover,
            ),
          ),
        ),
        CommonText(
          text: profileBloc.userName,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppPallete.textPrimary,
          ),
        ),
        CommonText(
          text: profileBloc.userBio,
          style: context.bodyMedium.copyWith(color: AppPallete.textSecondary),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ],
    );
  }
}
