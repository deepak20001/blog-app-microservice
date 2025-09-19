import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/enums/api_state_enums.dart';
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
  final ScrollController _scrollController = ScrollController();
  final BlogsBloc _blogsBloc = getIt<BlogsBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _blogsBloc.add(const BlogsCategoriesFetchEvent());
      _blogsBloc.add(BlogsFetchEvent(categoryId: 0, search: ''));

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          final currentState = _blogsBloc.state;
          if (!currentState.isLoadingMore && !_blogsBloc.allItemsLoaded) {
            final selectedCategory = currentState.categories
                .where((category) => category.isSelected)
                .firstOrNull;

            if (selectedCategory != null) {
              _blogsBloc.add(
                BlogsFetchEvent(
                  search: _searchController.text.trim(),
                  isLoadMore: true,
                  categoryId: selectedCategory.id,
                ),
              );
            }
          }
        }
      });
    });
  }

  // Handle refresh
  void _onRefresh() {
    final selectedCategory = _blogsBloc.state.categories
        .where((category) => category.isSelected)
        .firstOrNull;

    if (selectedCategory != null) {
      _blogsBloc.add(
        BlogsFetchEvent(
          categoryId: selectedCategory.id,
          search: _searchController.text.trim(),
        ),
      );
    }
  }

  // Handle category selected
  void _onCategorySelected(int category) {
    _blogsBloc.add(
      BlogsFetchEvent(
        categoryId: category,
        search: _searchController.text.trim(),
      ),
    );
  }

  // Handle search changed
  void _onSearchChanged(String value) {
    getIt<Debouncer>().run(() async {
      final selectedCategory = _blogsBloc.state.categories
          .where((category) => category.isSelected)
          .firstOrNull;

      if (selectedCategory != null) {
        _blogsBloc.add(
          BlogsFetchEvent(
            search: value.trim(),
            categoryId: selectedCategory.id,
          ),
        );
      }
    });
  }

  // Handle bloc listener
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
    _scrollController.dispose();
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
            actions: [
              IconButton(
                onPressed: () {
                  context.router.push(SearchRoute());
                },
                icon: Icon(Icons.search, color: AppPallete.primaryColor),
              ),
              IconButton(
                onPressed: () {
                  context.router.push(ProfileRoute(id: ''));
                },
                icon: Icon(Icons.person, color: AppPallete.primaryColor),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppPallete.primaryColor,
            foregroundColor: AppPallete.whiteColor,
            onPressed: () => context.router.push(const CreateBlogRoute()),
            child: const Icon(Icons.add),
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

                if (state.blogsApiState == ApiStateEnums.loading &&
                    !state.isLoadingMore)
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
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              itemCount:
                                  state.blogs.length +
                                  (state.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.blogs.length &&
                                    state.isLoadingMore) {
                                  return context.paddingAll(
                                    numD05,
                                    child: Loader(
                                      color: AppPallete.primaryColor,
                                    ),
                                  );
                                }

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
