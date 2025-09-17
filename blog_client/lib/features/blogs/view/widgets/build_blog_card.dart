import 'package:blog_client/core/common/extensions/date_time_extensions.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class BuildBlogCard extends StatelessWidget {
  const BuildBlogCard({
    required this.blog,
    required this.blogsBloc,
    super.key,
    this.onTap,
  });
  final BlogModel blog;
  final VoidCallback? onTap;
  final BlogsBloc blogsBloc;

  // Save blog
  void _onSaveBlog(BuildContext context) {
    blogsBloc.add(BlogsSaveBlogEvent(blogId: blog.id));
  }

  // Unsave blog
  void _onUnsaveBlog(BuildContext context) {
    blogsBloc.add(BlogsUnsaveBlogEvent(blogId: blog.id));
  }

  // Upvote blog
  void _onUpvoteBlog(BuildContext context) {
    blogsBloc.add(BlogsUpvoteBlogEvent(blogId: blog.id));
  }

  // Unupvote blog
  void _onUnupvoteBlog(BuildContext context) {
    blogsBloc.add(BlogsUnupvoteBlogEvent(blogId: blog.id));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: context.paddingBottom(numD03).padding,
        decoration: BoxDecoration(
          color: AppPallete.cardBackground,
          borderRadius: BorderRadius.circular(size.width * numD03),
          boxShadow: [
            BoxShadow(
              color: AppPallete.greyColor300.withValues(alpha: numD5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * numD03),
                topRight: Radius.circular(size.width * numD03),
              ),
              child: Container(
                height: size.height * numD2,
                width: double.infinity,
                decoration: BoxDecoration(color: AppPallete.greyColor300),
                child: CommonCachedImage(imageUrl: blog.imageUrl),
              ),
            ),
            context.paddingAll(
              numD035,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: size.width * numD015,
                children: [
                  CommonText(
                    text: blog.title,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppPallete.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Html(
                    data: blog.description,
                    style: {
                      'body': Style(
                        maxLines: 3,
                        textOverflow: TextOverflow.ellipsis,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      'p': Style(
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        color: AppPallete.textSecondary,
                      ),
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width * numD08,
                        height: size.width * numD08,
                        decoration: BoxDecoration(
                          color: AppPallete.primaryColor.withValues(
                            alpha: numD1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: CommonCachedImage(
                            imageUrl: blog.author.avatar,
                          ),
                        ),
                      ),
                      context.sizedBoxWidth(numD015),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: blog.author.username,
                              style: context.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppPallete.textPrimary,
                              ),
                            ),
                            CommonText(
                              text: blog.createdAt.toTimeAgo(),
                              style: context.bodySmall.copyWith(
                                color: AppPallete.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<BlogsBloc, BlogsState>(
                            bloc: blogsBloc,
                            buildWhen: (previous, current) =>
                                current is BlogsSaveLoadingState ||
                                current is BlogsUnsaveLoadingState,
                            builder: (context, state) {
                              final currentBlog = state.blogs.firstWhere(
                                (b) => b.id == blog.id,
                                orElse: () => blog,
                              );

                              return IconButton(
                                onPressed: () {
                                  currentBlog.isSaved
                                      ? _onUnsaveBlog(context)
                                      : _onSaveBlog(context);
                                },
                                icon: Icon(
                                  currentBlog.isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: currentBlog.isSaved
                                      ? AppPallete.primaryColor
                                      : AppPallete.greyColor400,
                                  size: size.width * numD06,
                                ),
                              );
                            },
                          ),
                          Material(
                            color: AppPallete.transparentColor,
                            borderRadius: BorderRadius.circular(
                              size.width * numD08,
                            ),
                            child: BlocBuilder<BlogsBloc, BlogsState>(
                              bloc: blogsBloc,
                              buildWhen: (previous, current) =>
                                  current is BlogsUpvoteLoadingState ||
                                  current is BlogsUnupvoteLoadingState,
                              builder: (context, state) {
                                final currentBlog = state.blogs.firstWhere(
                                  (b) => b.id == blog.id,
                                  orElse: () => blog,
                                );

                                return GestureDetector(
                                  onTap: () {
                                    currentBlog.isLiked
                                        ? _onUnupvoteBlog(context)
                                        : _onUpvoteBlog(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: currentBlog.isLiked
                                          ? AppPallete.primaryColor.withValues(
                                              alpha: numD1,
                                            )
                                          : AppPallete.cardBackground,
                                      borderRadius: BorderRadius.circular(
                                        size.width * numD08,
                                      ),
                                      border: Border.all(
                                        color: currentBlog.isLiked
                                            ? AppPallete.primaryColor
                                                  .withValues(alpha: numD3)
                                            : AppPallete.greyColor300,
                                        width: 1,
                                      ),
                                    ),
                                    child: context.paddingSymmetric(
                                      horizontal: numD04,
                                      vertical: numD025,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: size.width * numD02,
                                        children: [
                                          Icon(
                                            currentBlog.isLiked
                                                ? Icons.thumb_up
                                                : Icons.thumb_up_outlined,
                                            color: currentBlog.isLiked
                                                ? AppPallete.primaryColor
                                                : AppPallete.greyColor400,
                                            size: size.width * numD05,
                                          ),
                                          CommonText(
                                            text: currentBlog.voteCount
                                                .toString(),
                                            style: context.bodySmall.copyWith(
                                              color: currentBlog.isLiked
                                                  ? AppPallete.primaryColor
                                                  : AppPallete.textSecondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
