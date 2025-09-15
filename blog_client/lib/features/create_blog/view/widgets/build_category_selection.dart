import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/create_blog/viewmodel/create_blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildCategorySelection extends StatelessWidget {
  const BuildCategorySelection({
    super.key,
    required this.size,
    required this.createBlogBloc,
  });
  final Size size;
  final CreateBlogBloc createBlogBloc;

  void _onSelectCategory(int categoryId) {
    createBlogBloc.add(CreateBlogSelectCategoryEvent(categoryId: categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: 'Category',
          style: context.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        context.sizedBoxHeight(numD015),
        Container(
          height: size.width * numD15,
          decoration: BoxDecoration(
            color: AppPallete.cardBackground,
            border: Border.all(
              color: AppPallete.greyColor300.withValues(alpha: numD5),
            ),
          ),
          child: BlocBuilder<CreateBlogBloc, CreateBlogState>(
            bloc: createBlogBloc,
            builder: (context, state) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: context
                    .paddingSymmetric(horizontal: numD02, vertical: numD015)
                    .padding,
                itemCount: state.categories.length,
                separatorBuilder: (context, index) =>
                    context.sizedBoxWidth(numD015),
                itemBuilder: (context, index) {
                  final item = state.categories[index];

                  return GestureDetector(
                    onTap: () => _onSelectCategory(item.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: context
                          .paddingSymmetric(
                            horizontal: numD05,
                            vertical: numD02,
                          )
                          .padding,
                      decoration: BoxDecoration(
                        gradient: item.isSelected
                            ? LinearGradient(
                                colors: [
                                  AppPallete.primaryColor,
                                  AppPallete.primaryColor.withValues(
                                    alpha: numD6,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: !item.isSelected
                            ? AppPallete.backgroundColor
                            : AppPallete.primaryColor,
                        border: Border.all(
                          color: item.isSelected
                              ? AppPallete.primaryColor
                              : AppPallete.greyColor300,
                          width: item.isSelected ? 2 : 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: CommonText(
                        text: item.title,
                        style: context.labelLarge.copyWith(
                          fontWeight: item.isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: item.isSelected
                              ? AppPallete.backgroundColor
                              : AppPallete.textPrimary,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
