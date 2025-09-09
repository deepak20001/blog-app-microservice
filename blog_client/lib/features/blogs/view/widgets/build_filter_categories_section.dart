import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blogs/models/category_model.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildFilterCategoriesSection extends StatelessWidget {
  const BuildFilterCategoriesSection({
    super.key,
    required this.size,
    required this.onCategorySelected,
  });

  final Function(int) onCategorySelected;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: size.width * numD15,
          decoration: BoxDecoration(
            color: AppPallete.cardBackground,
            border: Border.all(
              color: AppPallete.greyColor300.withValues(alpha: numD5),
            ),
          ),
          child: BlocBuilder<BlogsBloc, BlogsState>(
            builder: (context, state) {
              return ListView.separated(
                padding: context
                    .paddingSymmetric(horizontal: numD02, vertical: numD015)
                    .padding,
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                separatorBuilder: (context, index) =>
                    context.sizedBoxWidth(numD015),
                itemBuilder: (context, index) {
                  final category = state.categories[index];

                  return _buildCategoryChip(
                    context: context,
                    size: size,
                    category: category,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required Size size,
    required CategoryModel category,
  }) {
    return GestureDetector(
      onTap: () => onCategorySelected(category.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: context
            .paddingSymmetric(horizontal: numD05, vertical: numD02)
            .padding,
        decoration: BoxDecoration(
          gradient: category.isSelected
              ? LinearGradient(
                  colors: [
                    AppPallete.primaryColor,
                    AppPallete.primaryColor.withValues(alpha: numD6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !category.isSelected
              ? AppPallete.backgroundColor
              : AppPallete.primaryColor,
          border: Border.all(
            color: category.isSelected
                ? AppPallete.primaryColor
                : AppPallete.greyColor300,
            width: category.isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: CommonText(
          text: category.title,
          style: context.labelLarge.copyWith(
            fontWeight: category.isSelected ? FontWeight.w700 : FontWeight.w600,
            color: category.isSelected
                ? AppPallete.backgroundColor
                : AppPallete.textPrimary,
          ),
        ),
      ),
    );
  }
}
