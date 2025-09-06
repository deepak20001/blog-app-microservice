import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/blogs/view/widgets/build_blog_card.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
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
  String _selectedCategory = 'All'; 

  // Define categories - you can make this dynamic from API later
  final List<String> _categories = [
    'All',
    'Technology',
    'Business',
    'Design',
    'Development',
    'Marketing',
    'Lifestyle',
    'Health',
    'Travel',
    'Food',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _blogsBloc.add(const BlogsFetchEvent());
    });
  }

  void _onRefresh() {
    _blogsBloc.add(const BlogsFetchEvent());
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    // Add category filter event to your bloc
    // _blogsBloc.add(BlogsFilterByCategoryEvent(category: category));
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
          body: Column(
            children: [
              // Search Bar
              context.paddingSymmetric(
                horizontal: numD035,
                vertical: numD02,
                child: CommonTextFormField(
                  controller: _searchController,
                  hintText: 'Search blogs, authors, or topics...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppPallete.primaryColor,
                    size: size.width * numD05,
                  ),
                  onChanged: (value) {
                    return;
                  },
                ),
              ),

              // ✅ Categories Section
              _buildCategoriesSection(context, size),

              // Content
              if (state is BlogsFetchLoadingState)
                Expanded(child: Loader(color: AppPallete.primaryColor))
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _onRefresh(),
                    color: AppPallete.primaryColor,
                    child: ListView.builder(
                      padding: context
                          .paddingSymmetric(
                            horizontal: numD035,
                            vertical: numD01,
                          )
                          .padding,
                      itemCount: state is BlogsFetchSuccessState
                          ? state.blogs.length
                          : 0,
                      itemBuilder: (context, index) {
                        final blog = state.blogs[index];

                        return BuildBlogCard(blog: blog, onTap: () {});
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSection(BuildContext context, Size size) {
    return Container(
      margin: context
          .paddingSymmetric(horizontal: numD035, vertical: numD02)
          .padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.width * numD15,
            decoration: BoxDecoration(
              color: AppPallete.cardBackground,
              border: Border.all(
                color: AppPallete.greyColor300.withValues(alpha: numD5),
              ),
            ),
            child: ListView.separated(
              padding: context
                  .paddingSymmetric(horizontal: numD02, vertical: numD015)
                  .padding,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) =>
                  context.sizedBoxWidth(numD015),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = (category == _selectedCategory);

                return _buildCategoryChip(
                  context: context,
                  size: size,
                  category: category,
                  isSelected: isSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required Size size,
    required String category,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: context
            .paddingSymmetric(horizontal: numD05, vertical: numD02)
            .padding,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppPallete.primaryColor,
                    AppPallete.primaryColor.withValues(alpha: numD6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: !isSelected
              ? AppPallete.backgroundColor
              : AppPallete.primaryColor,
          border: Border.all(
            color: isSelected
                ? AppPallete.primaryColor
                : AppPallete.greyColor300,
            width: isSelected ? 2 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: CommonText(
          text: category,
          style: context.labelLarge.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? AppPallete.backgroundColor
                : AppPallete.textPrimary,
          ),
        ),
      ),
    );
  }
}
