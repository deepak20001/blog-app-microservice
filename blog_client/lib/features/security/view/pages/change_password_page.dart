import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/core/utils/validation_helper.dart';
import 'package:blog_client/features/security/viewmodel/security_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final SecurityBloc _securityBloc = getIt<SecurityBloc>();
  final ValueNotifier<bool> _obscureCurrent = ValueNotifier(true);
  final ValueNotifier<bool> _obscureNew = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirm = ValueNotifier(true);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onChangePassword() {
    if (_formKey.currentState!.validate()) {
      _securityBloc.add(
        SecurityChangePasswordEvent(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      );
    }
  }

  void _onBlocListener(BuildContext context, SecurityState state) {
    switch (state) {
      case SecurityChangePasswordSuccessState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        context.router.maybePop();
        break;
      case SecurityChangePasswordFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _obscureCurrent.dispose();
    _obscureNew.dispose();
    _obscureConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<SecurityBloc, SecurityState>(
      bloc: _securityBloc,
      listener: _onBlocListener,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const CommonText(text: 'Change Password'),
            centerTitle: true,
          ),
          bottomNavigationBar: SafeArea(
            child: context.paddingSymmetric(
              horizontal: numD035,
              vertical: numD015,
              child: BlocSelector<SecurityBloc, SecurityState, bool>(
                selector: (state) {
                  return state is SecurityChangePasswordLoadingState;
                },
                builder: (context, isLoading) {
                  return CommonButton(
                    isLoading: isLoading,
                    text: 'Save Changes',
                    onPressed: _onChangePassword,
                  );
                },
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: context.paddingSymmetric(
                horizontal: numD04,
                vertical: numD04,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: size.width * numD035,
                  children: [
                    CommonText(
                      text:
                          'Keep your account secure by using a strong password.',
                      style: context.bodyMedium.copyWith(
                        color: AppPallete.greyColor700,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: (_obscureCurrent),
                      builder: (context, value, child) {
                        return CommonTextFormField(
                          controller: _currentPasswordController,
                          hintText: 'Current password',
                          label: 'Current password',
                          obscureText: !value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                              color: AppPallete.greyColor700,
                            ),
                            onPressed: () => _obscureCurrent.value = !value,
                          ),
                          validator: ValidationHelper.validateOldPassword,
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: (_obscureNew),
                      builder: (context, value, child) {
                        return CommonTextFormField(
                          controller: _newPasswordController,
                          hintText: 'New password',
                          label: 'New password',
                          obscureText: !value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                              color: AppPallete.greyColor700,
                            ),
                            onPressed: () => _obscureNew.value = !value,
                          ),
                          validator: (val) =>
                              ValidationHelper.validateNewPassword(
                                oldPassword: _currentPasswordController.text
                                    .trim(),
                                newPassword: val,
                              ),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: (_obscureConfirm),
                      builder: (context, value, child) {
                        return CommonTextFormField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm new password',
                          label: 'Confirm new password',
                          obscureText: !value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                              color: AppPallete.greyColor700,
                            ),
                            onPressed: () => _obscureConfirm.value = !value,
                          ),
                          validator: (val) =>
                              ValidationHelper.validateConfirmPassword(
                                password: _newPasswordController.text.trim(),
                                confirmPassword: val,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
