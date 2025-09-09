import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/utils/debouncer.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/blogs/view/widgets/build_blog_card.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/blogs/view/widgets/build_empty_blog_section.dart';
import 'package:blog_client/features/blogs/view/widgets/build_filter_categories_section.dart';
import 'package:blog_client/features/blogs/viewmodel/blogs_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  final _searchController = TextEditingController();
  final BlogsBloc _blogsBloc = getIt<BlogsBloc>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _blogsBloc.add(const CategoriesFetchEvent());
      _blogsBloc.add(BlogsFetchEvent(categoryId: 0, search: ''));
    });
  }

  void _onRefresh() {
    _blogsBloc.add(
      BlogsFetchEvent(
        categoryId: _blogsBloc.state.categories
            .where((category) => category.isSelected)
            .first
            .id,
        search: _searchController.text.trim(),
      ),
    );
  }

  void _onCategorySelected(int category) {
    _blogsBloc.add(
      BlogsFetchEvent(
        categoryId: category,
        search: _searchController.text.trim(),
      ),
    );
  }

  void _onSearchChanged(String value) {
    getIt<Debouncer>().run(() async {
      _blogsBloc.add(
        BlogsFetchEvent(
          search: value.trim(),
          categoryId: _blogsBloc.state.categories
              .where((category) => category.isSelected)
              .first
              .id,
        ),
      );
    });
  }

  void _onBlocListener(BuildContext context, BlogsState state) {
    switch (state) {
      case BlogsFetchFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<BlogsBloc, BlogsState>(
      bloc: _blogsBloc,
      buildWhen: (previous, current) =>
          current is BlogsFetchLoadingState ||
          current is BlogsFetchSuccessState ||
          current is BlogsFetchFailureState,
      listener: _onBlocListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppPallete.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppPallete.backgroundColor,
            elevation: 0,
            title: CommonText(
              text: 'Blogs',
              style: context.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppPallete.textPrimary,
              ),
            ),
            centerTitle: true,
          ),
          body: context.paddingHorizontal(
            numD035,
            child: Column(
              spacing: size.width * numD025,
              children: [
                CommonTextFormField(
                  controller: _searchController,
                  hintText: 'Search blogs, authors, or topics...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppPallete.primaryColor,
                    size: size.width * numD05,
                  ),
                  onChanged: (value) {
                    _onSearchChanged(value ?? '');
                    return null;
                  },
                ),
                BuildFilterCategoriesSection(
                  size: size,
                  onCategorySelected: _onCategorySelected,
                ),

                if (state is BlogsFetchLoadingState)
                  Expanded(child: Loader(color: AppPallete.primaryColor))
                else
                  Expanded(
                    child: state.blogs.isEmpty
                        ? BuildEmptyBlogSection(
                            size: size,
                            onRefresh: _onRefresh,
                          )
                        : RefreshIndicator(
                            onRefresh: () async => _onRefresh(),
                            color: AppPallete.primaryColor,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.blogs.length,
                              itemBuilder: (context, index) {
                                final blog = state.blogs[index];

                                return BuildBlogCard(
                                  blog: blog,
                                  onTap: () {
                                    context.router.push(
                                      BlogDetailsRoute(blogId: blog.id),
                                    );
                                  },
                                  blogsBloc: _blogsBloc,
                                );
                              },
                            ),
                          ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
