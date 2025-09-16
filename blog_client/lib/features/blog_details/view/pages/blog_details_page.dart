import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/enums/api_state_enums.dart';
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
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/blog_details/view/widgets/build_blog_%20comments_section.dart';
import 'package:blog_client/features/blog_details/view/widgets/build_sliver_blog_details_appbar.dart';
import 'package:blog_client/features/blog_details/viewmodel/blogs_details_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

@RoutePage()
class BlogDetailsPage extends StatefulWidget {
  const BlogDetailsPage({super.key, required this.blogId});
  final int blogId;

  @override
  State<BlogDetailsPage> createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  final BlogDetailsBloc _blogDetailsBloc = getIt<BlogDetailsBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _blogDetailsBloc.add(BlogDetailsFetchEvent(id: widget.blogId.toString()));
      _blogDetailsBloc.add(BlogDetailsGetCommentsEvent(blogId: widget.blogId));
    });
  }

  void _onUpvoteBlog(BuildContext context) {
    _blogDetailsBloc.add(BlogDetailsUpvoteBlogEvent(blogId: widget.blogId));
  }

  void _onUnupvoteBlog(BuildContext context) {
    _blogDetailsBloc.add(BlogDetailsUnupvoteBlogEvent(blogId: widget.blogId));
  }

  void _onBlocListener(BuildContext context, BlogDetailsState state) {
    switch (state) {
      case BlogDetailsCreateCommentLoadingState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
      listener: _onBlocListener,
      builder: (context, state) {
        final BlogModel blog = state.blog;

        return Scaffold(
          body: (state.blogDetailsApiState == ApiStateEnums.loading)
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
                              child: Html(data: blog.description),
                            ),
                            context.sizedBoxHeight(numD03),
                            BuildBlogCommentsSection(
                              size: size,
                              blogDetailsBloc: _blogDetailsBloc,
                              commentController: _commentController,
                            ),
                            context.sizedBoxHeight(numD03),
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
}
