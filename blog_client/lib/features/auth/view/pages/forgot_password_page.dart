import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/enums/verify_otp_purpose_enums.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/auth/viewmodel/auth_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  void _handleForgotPassword() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthForgotPasswordEvent(email: _emailController.text.trim()),
      );
    }
  }

  void _onBlocListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthForgotPasswordSuccessState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        context.router.push(
          VerifyOtpRoute(
            email: _emailController.text.trim(),
            purpose: VerifyOtpPurposeEnums.passwordReset,
          ),
        );
        break;
      case AuthForgotPasswordFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              selector: (state) {
                return state is AuthForgotPasswordLoadingState;
              },
              builder: (context, isLoading) {
                return CommonButton(
                  isLoading: isLoading,
                  text: 'Send Reset Code',
                  onPressed: _handleForgotPassword,
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
                      Icons.lock_reset,
                      size: 60,
                      color: AppPallete.primaryColor,
                    ),
                  ),
                  CommonText(
                    text: 'Forgot Password?',
                    style: context.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  CommonText(
                    text:
                        'No worries! Enter your email address and we\'ll send you a code to reset your password.',
                    style: context.bodyMedium.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  CommonTextFormField(
                    controller: _emailController,
                    hintText: 'Enter your email address',
                    label: 'Email Address',
                    prefixIcon: Icon(
                      Icons.email,
                      color: AppPallete.primaryColor,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Please enter a valid email';
                      }
                      return null;
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
