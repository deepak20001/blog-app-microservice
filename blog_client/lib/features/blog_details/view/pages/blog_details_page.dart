import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/date_time_extensions.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/models/profile_model.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BlogDetailsPage extends StatefulWidget {
  const BlogDetailsPage({super.key, required this.blogId});
  final int blogId;

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  final BlogsBloc _blogsBloc = getIt<BlogsBloc>();
  BlogModel? _blog;
  String _commentSortBy = 'latest';

  @override
  void initState() {
    super.initState();
    // Find the blog from the current state
    _blog = _blogsBloc.state.blogs.firstWhere(
      (blog) => blog.id == widget.blogId,
      orElse: () => BlogModel(
        id: widget.blogId,
        title: 'Loading...',
        description: 'Loading...',
        author: ProfileModel.empty(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            backgroundColor: AppPallete.backgroundColor,
            elevation: 0,
            pinned: true,
            expandedHeight: size.height * numD4,
            leading: IconButton(
              onPressed: () => context.router.maybePop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppPallete.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border,
                  color: AppPallete.greyColor400,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppPallete.greyColor300,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: CommonCachedImage(
                    imageUrl: _blog?.imageUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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
                    text: _blog?.title ?? 'Blog Title',
                    style: context.headlineMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppPallete.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  context.sizedBoxHeight(numD025),

                  // Author and Date Row
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
                            imageUrl: _blog?.author.avatar ?? '',
                          ),
                        ),
                      ),
                      context.sizedBoxWidth(numD02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: _blog?.author.username ?? 'Author Name',
                              style: context.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppPallete.textPrimary,
                              ),
                            ),
                            CommonText(
                              text:
                                  _blog?.createdAt.toTimeAgo() ?? '2 days ago',
                              style: context.bodySmall.copyWith(
                                color: AppPallete.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action Buttons
                      Row(
                        children: [
                          // Upvote Button
                          Container(
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
                            child: Material(
                              color: AppPallete.transparentColor,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(
                                  size.width * numD08,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * numD04,
                                    vertical: size.width * numD025,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.thumb_up_outlined,
                                        color: AppPallete.greyColor400,
                                        size: size.width * numD05,
                                      ),
                                      SizedBox(width: size.width * numD02),
                                      CommonText(
                                        text:
                                            _blog?.voteCount.toString() ?? '0',
                                        style: context.bodySmall.copyWith(
                                          color: AppPallete.textSecondary,
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

                  context.sizedBoxHeight(numD04),

                  // Divider
                  Container(height: 1, color: AppPallete.greyColor300),

                  context.sizedBoxHeight(numD04),

                  // Description Section
                  CommonText(
                    text: 'Description',
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppPallete.textPrimary,
                    ),
                  ),

                  context.sizedBoxHeight(numD02),

                  CommonText(
                    text:
                        _blog?.description ??
                        'This is a sample blog description that provides detailed information about the topic being discussed. It contains valuable insights and information that readers can benefit from.',
                    style: context.bodyLarge.copyWith(
                      color: AppPallete.textPrimary,
                      height: 1.6,
                    ),
                  ),

                  context.sizedBoxHeight(numD08),

                  // Additional Content Card
                  Container(
                    width: double.infinity,
                    padding: context.paddingAll(numD035).padding,
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
                      children: [
                        CommonText(
                          text: 'About this blog',
                          style: context.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppPallete.textPrimary,
                          ),
                        ),
                        context.sizedBoxHeight(numD015),
                        CommonText(
                          text:
                              'This blog post was created to share insights and knowledge with the community. Feel free to engage with the content by liking, saving, or sharing your thoughts. This blog post was created to share insights and knowledge with the community. Feel free to engage with the content by liking, saving, or sharing your thoughts. This blog post was created to share insights and knowledge with the community. Feel free to engage with the content by liking, saving, or sharing your thoughts. This blog post was created to share insights and knowledge with the community. Feel free to engage with the content by liking, saving, or sharing your thoughts.',
                          style: context.bodyMedium.copyWith(
                            color: AppPallete.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  context.sizedBoxHeight(numD08),

                  // Comments Section
                  CommonText(
                    text: 'Comments (${_getCommentsCount()})',
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
                      borderRadius: BorderRadius.circular(size.width * numD08),
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
                              imageUrl: 'https://via.placeholder.com/40',
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
                  Row(
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
                  ),

                  context.sizedBoxHeight(numD03),

                  // Comments List
                  ..._buildCommentsList(context, size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
  }
}
