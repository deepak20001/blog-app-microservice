import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/core/utils/validation_helper.dart';
import 'package:blog_client/features/edit_profile/view/widgets/build_profile_avatar_section.dart';
import 'package:blog_client/features/edit_profile/viewmodel/edit_profile_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final EditProfileBloc _editProfileBloc = getIt<EditProfileBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _editProfileBloc.add(const EditProfileGetUserProfileEvent());
    });
  }

  // Save Changes
  void _onSaveChanges() {
    if (_formKey.currentState!.validate()) {
      if (_editProfileBloc.state.imagePath.isNotEmpty) {
        _editProfileBloc.add(const EditProfileUploadImageEvent());
        return;
      }
      _editProfileBloc.add(
        EditProfileUpdateProfileEvent(
          userName: _nameController.text,
          bio: _bioController.text,
        ),
      );
    }
  }

  // Pick Image
  void _onPickImage() {
    _editProfileBloc.add(const EditProfilePickImageEvent());
  }

  void _onBlocListener(BuildContext context, EditProfileState state) {
    switch (state) {
      case EditProfileUploadImageSuccessState(:final uploadedImagePath):
        _editProfileBloc.add(
          EditProfileUpdateAvatarEvent(uploadedImagePath: uploadedImagePath),
        );
        break;
      case EditProfileUpdateAvatarSuccessState():
        _editProfileBloc.add(
          EditProfileUpdateProfileEvent(
            userName: _nameController.text.trim(),
            bio: _bioController.text.trim(),
          ),
        );
        break;
      case EditProfileGetUserProfileSuccessState(:final profile):
        _nameController.text = profile.username;
        _emailController.text = profile.email;
        _bioController.text = profile.bio;
        break;
      case EditProfileUpdateProfileSuccessState(:final successMessage):
        context.router.maybePop();
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        break;
      case EditProfileUpdateProfileFailureState(:final errorMessage) ||
          EditProfileUploadImageFailureState(:final errorMessage) ||
          EditProfileGetUserProfileFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: _onBlocListener,
      child: Scaffold(
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
        bottomNavigationBar: SafeArea(
          child: context.paddingSymmetric(
            horizontal: numD035,
            vertical: numD015,
            child: BlocBuilder<EditProfileBloc, EditProfileState>(
              bloc: _editProfileBloc,
              builder: (context, state) {
                if (state is EditProfileGetUserProfileLoadingState) {
                  return SizedBox.shrink();
                }
                return CommonButton(
                  isLoading:
                      state is EditProfileUpdateProfileLoadingState ||
                      state is EditProfileUploadImageLoadingState,
                  text: 'Save Changes',
                  onPressed: _onSaveChanges,
                );
              },
            ),
          ),
        ),
        body: BlocSelector<EditProfileBloc, EditProfileState, bool>(
          selector: (state) {
            return state is EditProfileGetUserProfileLoadingState;
          },
          builder: (context, isLoading) {
            if (isLoading) {
              return Loader(color: AppPallete.primaryColor);
            }
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    BuildProfileAvatarSection(
                      size: size,
                      editProfileBloc: _editProfileBloc,
                      onPickImage: _onPickImage,
                    ),
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
                            readOnly: true,
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
                            maxLines: 3,
                            validator: (value) =>
                                ValidationHelper.validateRequiredFields(
                                  value: value,
                                  fieldName: 'Bio',
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
