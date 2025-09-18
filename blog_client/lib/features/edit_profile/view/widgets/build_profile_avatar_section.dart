import 'dart:io';

import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/edit_profile/viewmodel/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildProfileAvatarSection extends StatelessWidget {
  const BuildProfileAvatarSection({
    super.key,
    required this.size,
    required this.editProfileBloc,
    required this.onPickImage,
  });
  final Size size;
  final EditProfileBloc editProfileBloc;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * numD035),
      padding: EdgeInsets.all(size.width * numD03),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(size.width * numD03),
        border: Border.all(color: AppPallete.greyColor300),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: size.width * numD25,
                height: size.width * numD25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPallete.primaryColor, width: 3),
                ),
                child: ClipOval(
                  child: BlocBuilder<EditProfileBloc, EditProfileState>(
                    bloc: editProfileBloc,
                    buildWhen: (previous, current) =>
                        previous.imagePath != current.imagePath,
                    builder: (context, state) {
                      if (state.imagePath.isNotEmpty) {
                        return Image.file(
                          File(state.imagePath),
                          width: size.width * numD25,
                          height: size.width * numD25,
                          fit: BoxFit.cover,
                        );
                      }
                      return CommonCachedImage(
                        imageUrl: editProfileBloc.state.profile.avatar,
                        width: size.width * numD25,
                        height: size.width * numD25,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: size.width * numD12,
                  height: size.width * numD12,
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppPallete.whiteColor, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppPallete.whiteColor,
                    size: size.width * numD05,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onPickImage,
            child: CommonText(
              text: 'Change Photo',
              color: AppPallete.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
