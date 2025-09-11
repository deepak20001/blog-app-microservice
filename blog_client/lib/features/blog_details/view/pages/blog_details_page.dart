import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/date_time_extensions.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blog_details/view/widgets/build_sliver_blog_details_appbar.dart';
import 'package:blog_client/features/blog_details/viewmodel/blogs_details_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BlogDetailsPage extends StatefulWidget {
  const BlogDetailsPage({super.key, required this.blogId});
  final int blogId;

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  final BlogDetailsBloc _blogDetailsBloc = getIt<BlogDetailsBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _blogDetailsBloc.add(BlogDetailsFetchEvent(id: widget.blogId.toString()));
    });
  }

  void _onUpvoteBlog(BuildContext context) {
    _blogDetailsBloc.add(UpvoteBlogEvent(blogId: widget.blogId));
  }

  void _onUnupvoteBlog(BuildContext context) {
    _blogDetailsBloc.add(UnupvoteBlogEvent(blogId: widget.blogId));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<BlogDetailsBloc, BlogDetailsState>(
      bloc: _blogDetailsBloc,
      buildWhen: (previous, current) =>
          current is BlogDetailsFetchLoadingState ||
          current is BlogDetailsFetchSuccessState ||
          current is BlogDetailsFetchFailureState,
      listener: (context, state) {},
      builder: (context, state) {
        final BlogModel blog = state.blog;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: AppPallete.primaryColor,
            foregroundColor: AppPallete.whiteColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * numD04),
            ),
            icon: Icon(Icons.auto_awesome, size: size.width * numD05),
            label: CommonText(
              text: 'AI Summarize',
              fontSize: size.width * numD035,
              fontWeight: FontWeight.w600,
              color: AppPallete.whiteColor,
            ),
          ),
          body: (state is BlogDetailsFetchLoadingState)
              ? Loader(color: AppPallete.primaryColor)
              : CustomScrollView(
                  slivers: [
                    BuildSliverBlogDetailsAppbar(
                      blog: blog,
                      size: size,
                      blogDetailsBloc: _blogDetailsBloc,
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: context.paddingAll(
                        numD035,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            CommonText(
                              text: blog.title,
                              style: context.headlineMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppPallete.textPrimary,
                              ),
                            ),
                            context.sizedBoxHeight(numD025),
                            Row(
                              children: [
                                Container(
                                  width: size.width * numD1,
                                  height: size.width * numD1,
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
                                context.sizedBoxWidth(numD02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommonText(
                                        text: blog.author.username,
                                        fontWeight: FontWeight.w600,
                                        color: AppPallete.textPrimary,
                                      ),
                                      CommonText(
                                        text: blog.createdAt.toTimeAgo(),
                                        color: AppPallete.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  color: AppPallete.transparentColor,
                                  borderRadius: BorderRadius.circular(
                                    size.width * numD08,
                                  ),
                                  child: BlocBuilder<BlogDetailsBloc, BlogDetailsState>(
                                    bloc: _blogDetailsBloc,
                                    buildWhen: (previous, current) =>
                                        current
                                            is BlogDetailsUpvoteBlogLoadingState ||
                                        current
                                            is BlogDetailsUnupvoteBlogLoadingState,
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          state.blog.isLiked
                                              ? _onUnupvoteBlog(context)
                                              : _onUpvoteBlog(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: state.blog.isLiked
                                                ? AppPallete.primaryColor
                                                      .withValues(alpha: numD1)
                                                : AppPallete.cardBackground,
                                            borderRadius: BorderRadius.circular(
                                              size.width * numD08,
                                            ),
                                            border: Border.all(
                                              color: state.blog.isLiked
                                                  ? AppPallete.primaryColor
                                                        .withValues(
                                                          alpha: numD3,
                                                        )
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
                                                  state.blog.isLiked
                                                      ? Icons.thumb_up
                                                      : Icons.thumb_up_outlined,
                                                  color: state.blog.isLiked
                                                      ? AppPallete.primaryColor
                                                      : AppPallete.greyColor400,
                                                  size: size.width * numD05,
                                                ),
                                                CommonText(
                                                  text: state.blog.voteCount
                                                      .toString(),
                                                  style: context.bodySmall
                                                      .copyWith(
                                                        color:
                                                            state.blog.isLiked
                                                            ? AppPallete
                                                                  .primaryColor
                                                            : AppPallete
                                                                  .textSecondary,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                            context.sizedBoxHeight(numD035),
                            Container(
                              width: double.infinity,
                              padding: context.paddingAll(numD035).padding,
                              decoration: BoxDecoration(
                                color: AppPallete.cardBackground,
                                borderRadius: BorderRadius.circular(
                                  size.width * numD03,
                                ),
                                border: Border.all(
                                  color: AppPallete.greyColor300,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    text: 'Description',
                                    style: context.titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppPallete.textPrimary,
                                    ),
                                  ),
                                  context.sizedBoxHeight(numD015),
                                  CommonText(
                                    text: blog.description,
                                    color: AppPallete.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                            context.sizedBoxHeight(numD08),
                            CommonText(
                              text: 'Comments (12)',
                              style: context.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppPallete.textPrimary,
                              ),
                            ),

                            context.sizedBoxHeight(numD03),

                            // Comment Input
                            Container(
                              padding: context.paddingAll(numD025).padding,
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
                              child: Row(
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
                                        imageUrl:
                                            'https://via.placeholder.com/40',
                                      ),
                                    ),
                                  ),
                                  context.sizedBoxWidth(numD02),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: size.width * numD03,
                                        vertical: size.width * numD02,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppPallete.backgroundColor,
                                        borderRadius: BorderRadius.circular(
                                          size.width * numD08,
                                        ),
                                        border: Border.all(
                                          color: AppPallete.greyColor300,
                                          width: 1,
                                        ),
                                      ),
                                      child: CommonText(
                                        text: 'Write a comment...',
                                        style: context.bodyMedium.copyWith(
                                          color: AppPallete.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  context.sizedBoxWidth(numD02),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.send,
                                      color: AppPallete.primaryColor,
                                      size: size.width * numD06,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            context.sizedBoxHeight(numD04),

                            // Comment Filters
                            /* Row(
                              children: [
                                CommonText(
                                  text: 'Sort by:',
                                  style: context.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppPallete.textPrimary,
                                  ),
                                ),
                                context.sizedBoxWidth(numD02),
                                _buildFilterChip(
                                  context,
                                  size,
                                  'Latest',
                                  'latest',
                                  Icons.access_time,
                                ),
                                context.sizedBoxWidth(numD015),
                                _buildFilterChip(
                                  context,
                                  size,
                                  'Most Upvoted',
                                  'most_upvoted',
                                  Icons.thumb_up,
                                ),
                              ],
                            ), */
                            context.sizedBoxHeight(numD03),

                            // Comments List
                            // ..._buildCommentsList(context, size),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  /* 
  int _getCommentsCount() {
    return 12; // Mock data
  }

  Widget _buildFilterChip(
    BuildContext context,
    Size size,
    String label,
    String value,
    IconData icon,
  ) {
    final isSelected = _commentSortBy == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _commentSortBy = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * numD03,
          vertical: size.width * numD02,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppPallete.primaryColor.withValues(alpha: 0.1)
              : AppPallete.cardBackground,
          borderRadius: BorderRadius.circular(size.width * numD08),
          border: Border.all(
            color: isSelected
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
              color: isSelected
                  ? AppPallete.primaryColor
                  : AppPallete.greyColor400,
            ),
            SizedBox(width: size.width * numD015),
            CommonText(
              text: label,
              style: context.bodySmall.copyWith(
                color: isSelected
                    ? AppPallete.primaryColor
                    : AppPallete.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommentsList(BuildContext context, Size size) {
    final comments = [
      {
        'author': 'John Doe',
        'avatar': 'https://via.placeholder.com/40',
        'time': '2 hours ago',
        'comment':
            'Great article! This really helped me understand the concept better. Thanks for sharing your insights.',
        'likes': 5,
        'isLiked': false,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'author': 'Sarah Wilson',
        'avatar': 'https://via.placeholder.com/40',
        'time': '4 hours ago',
        'comment':
            'I completely agree with your points. The examples you provided were very clear and easy to follow.',
        'likes': 3,
        'isLiked': true,
        'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      },
      {
        'author': 'Mike Johnson',
        'avatar': 'https://via.placeholder.com/40',
        'time': '6 hours ago',
        'comment':
            'This is exactly what I was looking for. Could you write more about the advanced techniques?',
        'likes': 8,
        'isLiked': false,
        'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      },
      {
        'author': 'Emily Chen',
        'avatar': 'https://via.placeholder.com/40',
        'time': '1 day ago',
        'comment':
            'Very informative post! I\'ve bookmarked this for future reference. Keep up the great work!',
        'likes': 2,
        'isLiked': false,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        'author': 'Alex Rodriguez',
        'avatar': 'https://via.placeholder.com/40',
        'time': '30 minutes ago',
        'comment':
            'Amazing content! This is exactly what I needed for my project. Thank you for the detailed explanation.',
        'likes': 12,
        'isLiked': true,
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      },
      {
        'author': 'Lisa Park',
        'avatar': 'https://via.placeholder.com/40',
        'time': '3 days ago',
        'comment':
            'I\'ve been following your blog for a while now. This post is another excellent addition to your collection.',
        'likes': 1,
        'isLiked': false,
        'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      },
    ];

    // Sort comments based on selected filter
    List<Map<String, dynamic>> sortedComments = List.from(comments);
    if (_commentSortBy == 'latest') {
      sortedComments.sort(
        (a, b) =>
            (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
      );
    } else if (_commentSortBy == 'most_upvoted') {
      sortedComments.sort(
        (a, b) => (b['likes'] as int).compareTo(a['likes'] as int),
      );
    }

    return sortedComments.map((comment) {
      return Container(
        margin: context.paddingBottom(numD03).padding,
        padding: context.paddingAll(numD03).padding,
        decoration: BoxDecoration(
          color: AppPallete.cardBackground,
          borderRadius: BorderRadius.circular(size.width * numD03),
          border: Border.all(color: AppPallete.greyColor300, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comment Header
            Row(
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
                      imageUrl: comment['avatar'] as String,
                    ),
                  ),
                ),
                context.sizedBoxWidth(numD02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        text: comment['author'] as String,
                        style: context.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppPallete.textPrimary,
                        ),
                      ),
                      CommonText(
                        text: comment['time'] as String,
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
                    color: (comment['isLiked'] as bool)
                        ? AppPallete.primaryColor.withValues(alpha: 0.1)
                        : AppPallete.transparentColor,
                    borderRadius: BorderRadius.circular(size.width * numD06),
                    border: Border.all(
                      color: (comment['isLiked'] as bool)
                          ? AppPallete.primaryColor.withValues(alpha: 0.3)
                          : AppPallete.greyColor300,
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: AppPallete.transparentColor,
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(size.width * numD06),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * numD03,
                          vertical: size.width * numD02,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              (comment['isLiked'] as bool)
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: (comment['isLiked'] as bool)
                                  ? AppPallete.primaryColor
                                  : AppPallete.greyColor400,
                              size: size.width * numD04,
                            ),
                            SizedBox(width: size.width * numD015),
                            CommonText(
                              text: (comment['likes'] as int).toString(),
                              style: context.bodySmall.copyWith(
                                color: (comment['isLiked'] as bool)
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

            context.sizedBoxHeight(numD02),

            // Comment Text
            CommonText(
              text: comment['comment'] as String,
              style: context.bodyMedium.copyWith(
                color: AppPallete.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }).toList();
  } */
}
