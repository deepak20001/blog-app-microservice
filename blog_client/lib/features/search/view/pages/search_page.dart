import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/debouncer.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/search/view/widgets/build_user_search_result_card.dart';
import 'package:blog_client/features/search/viewmodel/search_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchBloc _searchBloc = getIt<SearchBloc>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _searchBloc.add(
        SearchGetUsersEvent(search: _searchController.text.trim()),
      );

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          final currentState = _searchBloc.state;
          if (!currentState.isLoadingMore && !_searchBloc.allItemsLoaded) {
            _searchBloc.add(
              SearchGetUsersEvent(
                search: _searchController.text.trim(),
                isLoadMore: true,
              ),
            );
          }
        }
      });
    });
  }

  void _onSearchChanged() {
    getIt<Debouncer>().run(() async {
      _searchBloc.add(
        SearchGetUsersEvent(search: _searchController.text.trim()),
      );
    });
  }

  void _onBlocListener(BuildContext context, SearchState state) {
    switch (state) {
      case SearchGetUsersFailureState(:final errorMessage):
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

    return BlocListener<SearchBloc, SearchState>(
      bloc: _searchBloc,
      listener: _onBlocListener,
      child: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppPallete.backgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.router.maybePop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppPallete.textPrimary,
              size: size.width * numD05,
            ),
          ),
          title: CommonText(
            text: 'Search Users',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: size.width * numD035,
            children: [
              CommonTextFormField(
                controller: _searchController,
                hintText: 'Search users by name or email...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppPallete.primaryColor,
                  size: size.width * numD05,
                ),
                onChanged: (value) {
                  _onSearchChanged();
                  return null;
                },
              ),
              BlocBuilder<SearchBloc, SearchState>(
                bloc: _searchBloc,
                buildWhen: (previous, current) =>
                    current is! SearchGetUsersLoadingState ||
                    current is! SearchGetUsersSuccessState ||
                    current is! SearchGetUsersFailureState,
                builder: (context, state) {
                  if (state is SearchGetUsersLoadingState &&
                      !state.isLoadingMore) {
                    return Expanded(
                      child: Loader(color: AppPallete.primaryColor),
                    );
                  }
                  return Expanded(
                    child: state.users.isEmpty
                        ? _buildEmptyState(size)
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount:
                                state.users.length +
                                (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == state.users.length &&
                                  state.isLoadingMore) {
                                return context.paddingAll(
                                  numD05,
                                  child: Loader(color: AppPallete.primaryColor),
                                );
                              }

                              final user = state.users[index];
                              return BuildUserSearchResultCard(
                                size: size,
                                user: user,
                              );
                            },
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: size.width * numD2,
            color: AppPallete.greyColor400,
          ),
          context.sizedBoxHeight(numD02),
          CommonText(
            text: 'No users found matching your search',
            style: context.bodyLarge.copyWith(
              color: AppPallete.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchController.text.isNotEmpty) ...[
            context.sizedBoxHeight(numD01),
            CommonText(
              text: 'Try adjusting your search terms or filters',
              style: context.bodyMedium.copyWith(
                color: AppPallete.greyColor400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
