import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BuildSecuritySection extends StatelessWidget {
  const BuildSecuritySection({super.key, required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: size.width * numD015,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CommonText(
            text: 'Security',
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppPallete.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppPallete.greyColor300),
          ),
          child: Column(
            children: [
              ListTile(
                title: CommonText(
                  text: 'Change Password',
                  style: context.titleSmall.copyWith(
                    color: AppPallete.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: CommonText(
                  text: 'Update your account password',
                  color: AppPallete.greyColor700,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: size.width * numD04,
                  color: AppPallete.greyColor700,
                ),
                onTap: () => context.router.push(const ChangePasswordRoute()),
              ),
              Divider(height: 0, color: AppPallete.greyColor300),
              ListTile(
                title: CommonText(
                  text: 'Delete Account',
                  style: context.titleSmall.copyWith(
                    color: AppPallete.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: CommonText(
                  text: 'Delete your account and all your data',
                  color: AppPallete.greyColor700,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: size.width * numD04,
                  color: AppPallete.greyColor700,
                ),
                onTap: () => context.router.push(const DeleteAccountRoute()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
