import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/core/utils/validation_helper.dart';
import 'package:blog_client/features/auth/viewmodel/auth_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthResetPasswordEvent(
          email: widget.email,
          otp: widget.otp,
          newPassword: _newPasswordController.text.trim(),
          confirmPassword: _confirmPasswordController.text.trim(),
        ),
      );
    }
  }

  void _onBlocListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthResetPasswordSuccessState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        context.router.replaceAll([const LoginRoute()]);
        break;
      case AuthResetPasswordFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _onBlocListener,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppPallete.primaryColor),
            onPressed: () => context.router.maybePop(),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: context.paddingSymmetric(
            horizontal: numD035,
            vertical: numD015,
            child: BlocSelector<AuthBloc, AuthState, bool>(
              bloc: _authBloc,
              selector: (state) {
                return state is AuthResetPasswordLoadingState ||
                    state is AuthResetPasswordLoadingState;
              },
              builder: (context, isLoading) {
                return CommonButton(
                  isLoading: isLoading,
                  text: 'Reset Password',
                  onPressed: _handleResetPassword,
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: context.paddingHorizontal(
            numD035,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: size.width * numD035,
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * numD04),
                    decoration: BoxDecoration(
                      color: AppPallete.primaryColor.withValues(alpha: numD1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: size.width * numD06,
                      color: AppPallete.primaryColor,
                    ),
                  ),
                  CommonText(
                    text: 'Reset Password',
                    style: context.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  CommonText(
                    text: 'Enter your new password below',
                    style: context.bodyMedium.copyWith(
                      color: AppPallete.greyColor400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * numD04,
                      vertical: size.width * numD03,
                    ),
                    decoration: BoxDecoration(
                      color: AppPallete.cardBackground,
                      borderRadius: BorderRadius.circular(size.width * numD015),
                      border: Border.all(color: AppPallete.greyColor300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: size.width * numD015,
                      children: [
                        Icon(
                          Icons.email,
                          color: AppPallete.primaryColor,
                          size: size.width * numD04,
                        ),
                        const SizedBox(width: 8),
                        CommonText(
                          text: widget.email,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: (_obscureNewPassword),
                    builder: (context, value, child) {
                      return CommonTextFormField(
                        controller: _newPasswordController,
                        hintText: 'Enter new password',
                        label: 'New password',
                        obscureText: !value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: AppPallete.greyColor700,
                          ),
                          onPressed: () => _obscureNewPassword.value = !value,
                        ),
                        validator: ValidationHelper.validatePassword,
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: (_obscureConfirmPassword),
                    builder: (context, value, child) {
                      return CommonTextFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Enter new password',
                        label: 'New password',
                        obscureText: !value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: AppPallete.greyColor700,
                          ),
                          onPressed: () =>
                              _obscureConfirmPassword.value = !value,
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
    );
  }
}
