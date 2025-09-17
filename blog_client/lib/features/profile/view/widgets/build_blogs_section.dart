import 'package:blog_client/core/common/enums/api_state_enums.dart';
import 'package:blog_client/core/common/extensions/date_time_extensions.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/profile/viewmodel/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class BuildBlogsSection extends StatelessWidget {
  const BuildBlogsSection({
    super.key,
    required this.size,
    required this.profileBloc,
  });
  final Size size;
  final ProfileBloc profileBloc;

  // Save blog
  void _onSaveBlog(int blogId) {
    profileBloc.add(ProfileSaveBlogEvent(blogId: blogId));
  }

  // Unsave blog
  void _onUnsaveBlog(int blogId) {
    profileBloc.add(ProfileUnsaveBlogEvent(blogId: blogId));
  }

  // Upvote blog
  void _onUpvoteBlog(int blogId) {
    profileBloc.add(ProfileUpvoteBlogEvent(blogId: blogId));
  }

  // Unupvote blog
  void _onUnupvoteBlog(int blogId) {
    profileBloc.add(ProfileUnupvoteBlogEvent(blogId: blogId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
          previous.blogs != current.blogs ||
          current is ProfileGetMyBlogsLoadingState ||
          current is ProfileGetMyBlogsFailureState ||
          current is ProfileGetMyBlogsSuccessState ||
          current is ProfileGetSavedBlogsLoadingState ||
          current is ProfileGetSavedBlogsFailureState ||
          current is ProfileGetSavedBlogsSuccessState,
      bloc: profileBloc,
      builder: (context, state) {
        if (state.blogsApiState == ApiStateEnums.loading) {
          return Loader(color: AppPallete.primaryColor);
        }
        if (state.blogs.isEmpty) {
          return _buildEmptyBlogsState(context);
        }
        return ListView.builder(
          padding: EdgeInsets.all(size.width * numD035),
          itemCount: state.blogs.length,
          itemBuilder: (context, index) {
            final blog = state.blogs[index];

            return Container(
              margin: EdgeInsets.only(bottom: size.width * numD03),
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
                    child: CommonCachedImage(
                      imageUrl: blog.imageUrl,
                      width: double.infinity,
                      height: size.height * numD15,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.width * numD035),
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
                                IconButton(
                                  onPressed: () => blog.isSaved
                                      ? _onUnsaveBlog(blog.id)
                                      : _onSaveBlog(blog.id),
                                  icon: Icon(
                                    blog.isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: blog.isSaved
                                        ? AppPallete.primaryColor
                                        : AppPallete.greyColor400,
                                    size: size.width * numD06,
                                  ),
                                ),
                                Material(
                                  color: AppPallete.transparentColor,
                                  borderRadius: BorderRadius.circular(
                                    size.width * numD08,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => blog.isLiked
                                        ? _onUnupvoteBlog(blog.id)
                                        : _onUpvoteBlog(blog.id),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppPallete.cardBackground,
                                        borderRadius: BorderRadius.circular(
                                          size.width * numD08,
                                        ),
                                        border: Border.all(
                                          color: AppPallete.greyColor300,
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
                                              blog.isLiked
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_outlined,
                                              color: blog.isLiked
                                                  ? AppPallete.primaryColor
                                                  : AppPallete.greyColor400,
                                              size: size.width * numD05,
                                            ),
                                            CommonText(
                                              text: blog.voteCount.toString(),
                                              style: context.bodySmall.copyWith(
                                                color: blog.isLiked
                                                    ? AppPallete.primaryColor
                                                    : AppPallete.textSecondary,
                                                fontWeight: FontWeight.w600,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyBlogsState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(size.width * numD06),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: size.width * numD03,
          children: [
            Container(
              padding: EdgeInsets.all(size.width * numD04),
              decoration: BoxDecoration(
                color: AppPallete.primaryColor.withValues(alpha: numD05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.article_outlined,
                color: AppPallete.primaryColor,
                size: size.width * numD1,
              ),
            ),
            CommonText(
              text: 'No blogs found',
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppPallete.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            CommonText(
              text: 'You don\'t have any blogs here yet.',
              style: context.bodyMedium.copyWith(
                color: AppPallete.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
