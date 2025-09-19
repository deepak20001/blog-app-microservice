import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/enums/api_state_enums.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/profile/view/widgets/build_profile_header.dart';
import 'package:blog_client/features/profile/view/widgets/build_profile_stats.dart';
import 'package:blog_client/features/profile/view/widgets/build_profile_tabs.dart';
import 'package:blog_client/features/profile/view/widgets/build_blogs_section.dart';
import 'package:blog_client/features/profile/viewmodel/profile_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.id});
  final String id;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final ProfileBloc _profileBloc = getIt<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _profileBloc.add(ProfileGetUserProfileEvent(id: widget.id));
      _onTabSelected(0);

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
          final currentState = _profileBloc.state;
          if (!currentState.isLoadingMore && !_profileBloc.allItemsLoaded) {
            _tabController.index == 0
                ? _profileBloc.add(
                    ProfileGetMyBlogsEvent(id: widget.id, isLoadMore: true),
                  )
                : _profileBloc.add(
                    ProfileGetSavedBlogsEvent(id: widget.id, isLoadMore: true),
                  );
          }
        }
      });
    });
  }

  // Logout
  void _onLogout() {
    _profileBloc.add(const ProfileLogoutEvent());
  }

  // Tab Selected
  void _onTabSelected(int index) {
    index == 0
        ? _profileBloc.add(
            ProfileGetMyBlogsEvent(id: widget.id, isLoadMore: false),
          )
        : _profileBloc.add(
            ProfileGetSavedBlogsEvent(id: widget.id, isLoadMore: false),
          );
  }

  // Follow Profile
  void _onFollowProfile() {
    _profileBloc.add(ProfileFollowProfileEvent(id: widget.id));
  }

  // Unfollow Profile
  void _onUnfollowProfile() {
    _profileBloc.add(ProfileUnfollowProfileEvent(id: widget.id));
  }

  void _onBlocListener(BuildContext context, ProfileState state) {
    switch (state) {
      case ProfileGetMyBlogsFailureState(:final errorMessage) ||
          ProfileGetSavedBlogsFailureState(:final errorMessage) ||
          ProfileDeleteBlogFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      case ProfileDeleteBlogSuccessState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        break;
      case ProfileLogoutState():
        SnackbarUtils.showSuccess(
          context: context,
          message: 'Logged out successfully',
        );
        context.router.replace(const LoginRoute());
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: _onBlocListener,
      child: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppPallete.backgroundColor,
          elevation: 0,
          title: CommonText(
            text: 'Profile',
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: widget.id.isNotEmpty
              ? [
                  BlocBuilder<ProfileBloc, ProfileState>(
                    bloc: _profileBloc,
                    buildWhen: (previous, current) =>
                        current is ProfileGetUserProfileLoadingState ||
                        current is ProfileGetUserProfileSuccessState ||
                        current is ProfileGetUserProfileFailureState ||
                        current is ProfileFollowProfileLoadingState ||
                        current is ProfileUnfollowProfileLoadingState,
                    builder: (context, state) {
                      if (state.profileApiState == ApiStateEnums.loading) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(right: size.width * numD03),
                        child: TextButton.icon(
                          onPressed: () =>
                              _profileBloc.state.profileData.isFollowing
                              ? _onUnfollowProfile()
                              : _onFollowProfile(),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                _profileBloc.state.profileData.isFollowing
                                ? AppPallete.errorColor
                                : AppPallete.primaryColor,
                            overlayColor:
                                _profileBloc.state.profileData.isFollowing
                                ? AppPallete.errorColor.withValues(alpha: 0.08)
                                : AppPallete.primaryColor.withValues(
                                    alpha: 0.08,
                                  ),
                            side: BorderSide(
                              color: _profileBloc.state.profileData.isFollowing
                                  ? AppPallete.errorColor
                                  : AppPallete.primaryColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD03,
                              vertical: size.width * numD015,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: Icon(Icons.person_add_alt_1, size: 18),
                          label: CommonText(
                            text: _profileBloc.state.profileData.isFollowing
                                ? 'Unfollow'
                                : 'Follow',
                            style: context.labelLarge.copyWith(
                              color: _profileBloc.state.profileData.isFollowing
                                  ? AppPallete.errorColor
                                  : AppPallete.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]
              : [
                  IconButton(
                    onPressed: () {
                      context.router.push(const EditProfileRoute()).then((_) {
                        _profileBloc.add(
                          const ProfileGetUpdatedDataFromLocalStorageEvent(),
                        );
                      });
                    },
                    icon: Icon(Icons.edit, color: AppPallete.primaryColor),
                  ),
                  IconButton(
                    onPressed: _onLogout,
                    icon: Icon(Icons.logout, color: AppPallete.errorColor),
                  ),
                ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: _profileBloc,
          buildWhen: (previous, current) =>
              current is ProfileGetUserProfileLoadingState ||
              current is ProfileGetUserProfileSuccessState ||
              current is ProfileGetUserProfileFailureState,
          builder: (context, state) {
            if (state.profileApiState == ApiStateEnums.loading) {
              return Loader(color: AppPallete.primaryColor);
            }
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    spacing: size.width * numD02,
                    children: [
                      BuildProfileHeader(size: size, profileBloc: _profileBloc),
                      BuildProfileStats(size: size, profileBloc: _profileBloc),
                      BuildProfileTabs(
                        tabController: _tabController,
                        size: size,
                        onTabSelected: _onTabSelected,
                      ),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  BuildBlogsSection(
                    size: size,
                    profileBloc: _profileBloc,
                    scrollController: _scrollController,
                  ),
                  BuildBlogsSection(
                    size: size,
                    profileBloc: _profileBloc,
                    scrollController: _scrollController,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
