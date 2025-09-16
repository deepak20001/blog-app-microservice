import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_cached_image.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/validation_helper.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _bioController = TextEditingController(
    text:
        'Passionate blogger sharing thoughts on technology, lifestyle, and everything in between. Always learning, always growing!',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppPallete.successColor,
        ),
      );
      context.router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppPallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppPallete.backgroundColor,
        elevation: 0,
        title: CommonText(
          text: 'Edit Profile',
          style: context.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppPallete.textPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.router.pop(),
          icon: Icon(Icons.arrow_back, color: AppPallete.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              context.sizedBoxHeight(numD02),

              // Profile Picture Section
              _buildProfilePictureSection(context, size),

              context.sizedBoxHeight(numD03),

              // Form Fields
              context.paddingHorizontal(
                numD035,
                child: Column(
                  spacing: size.width * numD02,
                  children: [
                    CommonTextFormField(
                      controller: _nameController,
                      hintText: 'Enter your full name',
                      label: 'Full Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppPallete.primaryColor,
                      ),
                      validator: (value) => ValidationHelper.validateName(
                        fieldName: 'Name',
                        value: value,
                      ),
                    ),

                    CommonTextFormField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      label: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppPallete.primaryColor,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: ValidationHelper.validateEmail,
                    ),

                    CommonTextFormField(
                      controller: _bioController,
                      hintText: 'Tell us about yourself',
                      label: 'Bio',
                      prefixIcon: Icon(
                        Icons.info,
                        color: AppPallete.primaryColor,
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bio is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Bio must be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              context.sizedBoxHeight(numD03),

              // Save Button
              context.paddingHorizontal(
                numD035,
                child: CommonButton(
                  text: 'Save Changes',
                  onPressed: _handleSave,
                ),
              ),

              context.sizedBoxHeight(numD02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context, Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * numD035),
      padding: EdgeInsets.all(size.width * numD03),
      decoration: BoxDecoration(
        color: AppPallete.cardBackground,
        borderRadius: BorderRadius.circular(size.width * numD03),
        border: Border.all(color: AppPallete.greyColor300),
      ),
      child: Column(
        children: [
          // Current Profile Picture
          Stack(
            children: [
              Container(
                width: size.width * numD25,
                height: size.width * numD25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPallete.primaryColor, width: 3),
                ),
                child: ClipOval(
                  child: CommonCachedImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                    width: size.width * numD25,
                    height: size.width * numD25,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Edit Button
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: size.width * numD12,
                  height: size.width * numD12,
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppPallete.whiteColor, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppPallete.whiteColor,
                    size: size.width * numD05,
                  ),
                ),
              ),
            ],
          ),

          context.sizedBoxHeight(numD02),

          // Change Photo Button
          TextButton(
            onPressed: () {
              // TODO: Implement image picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image picker functionality coming soon!'),
                ),
              );
            },
            child: CommonText(
              text: 'Change Photo',
              style: context.bodyMedium.copyWith(
                color: AppPallete.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
