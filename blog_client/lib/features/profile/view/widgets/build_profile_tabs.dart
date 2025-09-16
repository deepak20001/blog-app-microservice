import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BuildProfileTabs extends StatelessWidget {
  const BuildProfileTabs({
    super.key,
    required this.tabController,
    required this.size,
    required this.onTabSelected,
  });

  final TabController tabController;
  final Size size;
  final Function(int) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * numD02),
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
      child: TabBar(
        onTap: onTabSelected,
        controller: tabController,
        indicator: BoxDecoration(
          color: AppPallete.primaryColor,
          borderRadius: BorderRadius.circular(size.width * numD03),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppPallete.whiteColor,
        unselectedLabelColor: AppPallete.textSecondary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: size.width * numD035,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: size.width * numD035,
        ),
        tabs: [
          Tab(text: 'My Blogs'),
          Tab(text: 'Saved Blogs'),
        ],
      ),
    );
  }
}
