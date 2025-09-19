import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/followers_followings/models/follower_following_model.dart';
import 'package:blog_client/features/followers_followings/viewmodel/follow_followings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.size,
    required this.followFollowingsBloc,
    required this.user,
    required this.isFollowers,
  });

  final Size size;
  final FollowFollowingsBloc followFollowingsBloc;
  final FollowerFollowingModel user;
  final bool isFollowers;

  void _onFollowTap() {
    followFollowingsBloc.add(
      FollowFollowingsFollowProfileEvent(
        id: isFollowers ? user.follower.id : user.following.id,
      ),
    );
  }

  void _onUnfollowTap() {
    followFollowingsBloc.add(
      FollowFollowingsUnfollowProfileEvent(
        id: isFollowers ? user.follower.id : user.following.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * numD02,
        vertical: size.width * numD01,
      ),
      padding: EdgeInsets.all(size.width * numD035),
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
      child: Row(
        spacing: size.width * numD02,
        children: [
          Container(
            width: size.width * numD15,
            height: size.width * numD15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppPallete.primaryColor.withValues(alpha: numD3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CommonCachedImage(
                imageUrl: isFollowers
                    ? user.follower.avatar
                    : user.following.avatar,
                width: size.width * numD15,
                height: size.width * numD15,
                fit: BoxFit.cover,
                text: isFollowers
                    ? user.follower.username
                    : user.following.username,
              ),
            ),
          ),
          Expanded(
            child: CommonText(
              text: isFollowers
                  ? user.follower.username
                  : user.following.username,
              style: context.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppPallete.textPrimary,
              ),
            ),
          ),
          BlocBuilder<FollowFollowingsBloc, FollowFollowingsState>(
            bloc: followFollowingsBloc,
            buildWhen: (previous, current) =>
                current is FollowFollowingsFollowProfileLoadingState ||
                current is FollowFollowingsUnfollowProfileLoadingState ||
                current is FollowFollowingsFollowProfileSuccessState ||
                current is FollowFollowingsUnfollowProfileSuccessState ||
                current is FollowFollowingsFollowProfileFailureState ||
                current is FollowFollowingsUnfollowProfileFailureState,
            builder: (context, state) {
              final item = state.data.firstWhere(
                (data) => data.id == user.id,
                orElse: () => user,
              );

              return GestureDetector(
                onTap: item.isFollowing ? _onUnfollowTap : _onFollowTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * numD03,
                    vertical: size.width * numD015,
                  ),
                  decoration: BoxDecoration(
                    color: item.isFollowing
                        ? AppPallete.greyColor300
                        : AppPallete.primaryColor,
                    borderRadius: BorderRadius.circular(size.width * numD02),
                    border: item.isFollowing
                        ? Border.all(color: AppPallete.greyColor400, width: 1)
                        : null,
                  ),
                  child: CommonText(
                    text: item.isFollowing ? 'Following' : 'Follow',
                    style: context.bodySmall.copyWith(
                      color: item.isFollowing
                          ? AppPallete.textSecondary
                          : AppPallete.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
