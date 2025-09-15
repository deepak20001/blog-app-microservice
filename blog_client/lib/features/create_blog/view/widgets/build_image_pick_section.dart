import 'dart:io';

import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/create_blog/viewmodel/create_blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildImagePickSection extends StatelessWidget {
  const BuildImagePickSection({
    super.key,
    required this.size,
    required this.createBlogBloc,
  });
  final Size size;
  final CreateBlogBloc createBlogBloc;

  void _onPickImage() {
    createBlogBloc.add(CreateBlogPickImageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Cover Image',
          style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        context.sizedBoxHeight(numD015),
        BlocBuilder<CreateBlogBloc, CreateBlogState>(
          bloc: createBlogBloc,
          buildWhen: (previous, current) =>
              previous.imagePath != current.imagePath,
          builder: (context, state) {
            return GestureDetector(
              onTap: _onPickImage,
              child: Container(
                height: size.width * numD45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppPallete.cardBackground,
                  border: Border.all(color: AppPallete.greyColor300),
                ),
                alignment: Alignment.center,
                child: createBlogBloc.state.imagePath.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: size.width * numD12,
                            color: AppPallete.greyColor700,
                          ),
                          context.sizedBoxHeight(numD01),
                          CommonText(
                            text: 'Tap to select image',
                            style: context.labelMedium.copyWith(
                              color: AppPallete.greyColor700,
                            ),
                          ),
                        ],
                      )
                    : Image.file(
                        File(createBlogBloc.state.imagePath),
                        fit: BoxFit.cover,
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
