import 'package:blog_client/core/common/extensions/date_time_extensions.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blog_details/viewmodel/blogs_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildBlogCommentsSection extends StatelessWidget {
  const BuildBlogCommentsSection({
    super.key,
    required this.size,
    required this.blogDetailsBloc,
    required this.commentController,
  });
  final Size size;
  final BlogDetailsBloc blogDetailsBloc;
  final TextEditingController commentController;

  // Handle comment submitted
  void _onCommentSubmitted(BuildContext context) {
    if (!commentController.text.isEmpty) {
      blogDetailsBloc.add(
        BlogDetailsCreateCommentEvent(
          comment: commentController.text.trim(),
          blogId: blogDetailsBloc.state.blog.id,
        ),
      );
      commentController.clear();
    }
  }

  // Handle upvote comment
  void _onUpvoteComment({required int commentId}) {
    blogDetailsBloc.add(
      BlogDetailsUpvoteCommentEvent(
        commentId: commentId,
        blogId: blogDetailsBloc.state.blog.id,
      ),
    );
  }

  // Handle unupvote comment
  void _onUnupvoteComment({required int commentId}) {
    blogDetailsBloc.add(
      BlogDetailsUnupvoteCommentEvent(
        commentId: commentId,
        blogId: blogDetailsBloc.state.blog.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogDetailsBloc, BlogDetailsState>(
      bloc: blogDetailsBloc,
      builder: (context, state) {
        final comments = blogDetailsBloc.state.comments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: size.width * numD03,
          children: [
            CommonText(
              text: 'Comments (${comments.length})',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppPallete.textPrimary,
              ),
            ),
            Container(
              padding: context.paddingAll(numD025).padding,
              decoration: BoxDecoration(
                color: AppPallete.cardBackground,
                borderRadius: BorderRadius.circular(size.width * numD03),
                border: Border.all(color: AppPallete.greyColor300, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: size.width * numD08,
                    height: size.width * numD08,
                    decoration: BoxDecoration(
                      color: AppPallete.primaryColor.withValues(alpha: numD1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CommonCachedImage(
                        imageUrl: blogDetailsBloc.userProfileImage,
                      ),
                    ),
                  ),
                  context.sizedBoxWidth(numD02),
                  Expanded(
                    child: CommonTextFormField(
                      controller: commentController,
                      hintText: 'Write a comment...',
                      fillColor: AppPallete.whiteColor,
                    ),
                  ),
                  context.sizedBoxWidth(numD02),
                  IconButton(
                    onPressed: () => _onCommentSubmitted(context),
                    icon: Icon(
                      Icons.send,
                      color: AppPallete.primaryColor,
                      size: size.width * numD06,
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: comments.length,

              itemBuilder: (context, index) {
                final comment = comments[index];

                return Container(
                  padding: context.paddingAll(numD03).padding,
                  decoration: BoxDecoration(
                    color: AppPallete.cardBackground,
                    borderRadius: BorderRadius.circular(size.width * numD03),
                    border: Border.all(
                      color: AppPallete.greyColor300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: size.width * numD015,
                    children: [
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
                                imageUrl: comment.author.avatar,
                              ),
                            ),
                          ),
                          context.sizedBoxWidth(numD02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text: comment.author.username,
                                  style: context.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppPallete.textPrimary,
                                  ),
                                ),
                                CommonText(
                                  text: comment.createdAt.toTimeAgo(),
                                  style: context.bodySmall.copyWith(
                                    color: AppPallete.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Like Button
                          Container(
                            decoration: BoxDecoration(
                              color: comment.isVoted
                                  ? AppPallete.primaryColor.withValues(
                                      alpha: 0.1,
                                    )
                                  : AppPallete.transparentColor,
                              borderRadius: BorderRadius.circular(
                                size.width * numD06,
                              ),
                              border: Border.all(
                                color: comment.isVoted
                                    ? AppPallete.primaryColor.withValues(
                                        alpha: 0.3,
                                      )
                                    : AppPallete.greyColor300,
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: AppPallete.transparentColor,
                              child: InkWell(
                                onTap: () {
                                  comment.isVoted
                                      ? _onUnupvoteComment(
                                          commentId: comment.id,
                                        )
                                      : _onUpvoteComment(commentId: comment.id);
                                },
                                borderRadius: BorderRadius.circular(
                                  size.width * numD06,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * numD03,
                                    vertical: size.width * numD02,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        comment.isVoted
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_outlined,
                                        color: comment.isVoted
                                            ? AppPallete.primaryColor
                                            : AppPallete.greyColor400,
                                        size: size.width * numD04,
                                      ),
                                      SizedBox(width: size.width * numD015),
                                      CommonText(
                                        text: comment.voteCount.toString(),
                                        style: context.bodySmall.copyWith(
                                          color: comment.isVoted
                                              ? AppPallete.primaryColor
                                              : AppPallete.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CommonText(
                        text: comment.comment,
                        style: context.bodyMedium.copyWith(
                          color: AppPallete.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return context.sizedBoxHeight(numD03);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    Size size,
    String label,
    String value,
    IconData icon,
  ) {
    // final isSelected = _commentSortBy == value;

    return GestureDetector(
      onTap: () {
        /*  setState(() {
          _commentSortBy = value;
        }); */
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * numD03,
          vertical: size.width * numD02,
        ),
        decoration: BoxDecoration(
          color: false
              ? AppPallete.primaryColor.withValues(alpha: 0.1)
              : AppPallete.cardBackground,
          borderRadius: BorderRadius.circular(size.width * numD08),
          border: Border.all(
            color: false
                ? AppPallete.primaryColor.withValues(alpha: 0.3)
                : AppPallete.greyColor300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: size.width * numD04,
              color: false ? AppPallete.primaryColor : AppPallete.greyColor400,
            ),
            SizedBox(width: size.width * numD015),
            CommonText(
              text: label,
              style: context.bodySmall.copyWith(
                color: false
                    ? AppPallete.primaryColor
                    : AppPallete.textSecondary,
                fontWeight: false ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
