import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/features/profile/viewmodel/profile_bloc.dart';
import 'package:flutter/material.dart';

class BuildProfileStats extends StatelessWidget {
  const BuildProfileStats({
    super.key,
    required this.size,
    required this.profileBloc,
  });
  final Size size;
  final ProfileBloc profileBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * numD02),
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
        children: [
          // Blogs Count
          Expanded(
            child: _buildStatItem(
              context: context,
              title: 'Blogs',
              count: profileBloc.state.profileData.userPostedBlogsCount
                  .toString(),
              icon: Icons.article_outlined,
            ),
          ),

          Container(
            width: 1,
            height: size.width * numD15,
            color: AppPallete.greyColor300,
          ),

          // Followers Count
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.router.push(
                  FollowersRoute(userId: profileBloc.state.profileData.id),
                );
              },
              child: _buildStatItem(
                context: context,
                title: 'Followers',
                count: profileBloc.state.profileData.followersCount.toString(),
                icon: Icons.people_outline,
              ),
            ),
          ),

          Container(
            width: 1,
            height: size.width * numD15,
            color: AppPallete.greyColor300,
          ),

          // Following Count
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.router.push(
                  FollowingsRoute(userId: profileBloc.state.profileData.id),
                );
              },
              child: _buildStatItem(
                context: context,
                title: 'Following',
                count: profileBloc.state.profileData.followingsCount.toString(),
                icon: Icons.person_add_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String title,
    required String count,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppPallete.primaryColor, size: size.width * numD06),

        context.sizedBoxHeight(numD01),

        CommonText(
          text: count,
          style: context.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppPallete.textPrimary,
          ),
        ),

        context.sizedBoxHeight(numD005),

        CommonText(
          text: title,
          style: context.bodySmall.copyWith(color: AppPallete.textSecondary),
        ),
      ],
    );
  }
}
