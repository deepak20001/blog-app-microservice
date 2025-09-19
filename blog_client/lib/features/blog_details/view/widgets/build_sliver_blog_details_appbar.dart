import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blog_details/viewmodel/blog_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildSliverBlogDetailsAppbar extends StatelessWidget {
  const BuildSliverBlogDetailsAppbar({
    super.key,
    required this.blog,
    required this.size,
    required this.blogDetailsBloc,
  });
  final BlogModel blog;
  final Size size;
  final BlogDetailsBloc blogDetailsBloc;

  void _onSaveBlog(BuildContext context) {
    blogDetailsBloc.add(BlogDetailsSaveBlogEvent(blogId: blog.id));
  }

  void _onUnsaveBlog(BuildContext context) {
    blogDetailsBloc.add(BlogDetailsUnsaveBlogEvent(blogId: blog.id));
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppPallete.backgroundColor,
      elevation: 0,
      pinned: true,
      actionsPadding: EdgeInsets.symmetric(horizontal: size.width * numD01),
      expandedHeight: size.width * numD8,
      leading: IconButton(
        onPressed: () => context.router.maybePop(),
        icon: const Icon(Icons.arrow_back, color: AppPallete.textPrimary),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            AppPallete.whiteColor.withValues(alpha: numD5),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * numD03),
            ),
          ),
        ),
      ),
      actions: [
        BlocBuilder<BlogDetailsBloc, BlogDetailsState>(
          bloc: blogDetailsBloc,
          buildWhen: (previous, current) =>
              current is BlogDetailsSaveBlogLoadingState ||
              current is BlogDetailsUnsaveBlogLoadingState,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                state.blog.isSaved
                    ? _onUnsaveBlog(context)
                    : _onSaveBlog(context);
              },
              icon: Icon(
                state.blog.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: state.blog.isSaved
                    ? AppPallete.primaryColor
                    : AppPallete.textPrimary,
                size: size.width * numD06,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  AppPallete.whiteColor.withValues(alpha: numD5),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * numD03),
                  ),
                ),
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: AppPallete.greyColor300,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(size.width * numD06),
              bottomRight: Radius.circular(size.width * numD06),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(size.width * numD06),
              bottomRight: Radius.circular(size.width * numD06),
            ),
            child: CommonCachedImage(
              imageUrl: blog.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
