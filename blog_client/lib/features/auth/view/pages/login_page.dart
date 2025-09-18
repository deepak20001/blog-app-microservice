import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/enums/verify_otp_purpose_enums.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
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
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthLoginEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onBlocListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoginSuccessState(:final successMessage, :final user):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        (user.isVerified)
            ? context.router.replace(const BlogsRoute())
            : context.router.push(
                VerifyOtpRoute(
                  email: _emailController.text.trim(),
                  purpose: VerifyOtpPurposeEnums.emailVerification,
                ),
              );
        break;
      case AuthLoginFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: _onBlocListener,
      child: Scaffold(
        body: context.paddingHorizontal(
          numD035,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: size.width * numD01,
              children: [
                CommonText(text: 'Welcome Back', style: context.displaySmall),
                CommonText(
                  text: 'Sign in to your account',
                  style: context.bodyMedium,
                ),
                context.sizedBoxHeight(numD05),
                CommonTextFormField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  label: 'Email',
                  prefixIcon: Icon(Icons.email, color: AppPallete.primaryColor),
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationHelper.validateEmail,
                ),
                SizedBox.shrink(),
                CommonTextFormField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  label: 'Password',
                  prefixIcon: Icon(Icons.lock, color: AppPallete.primaryColor),
                  obscureText: true,
                  validator: ValidationHelper.validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        context.router.push(const ForgotPasswordRoute()),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppPallete.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                BlocSelector<AuthBloc, AuthState, bool>(
                  bloc: _authBloc,
                  selector: (state) => state is AuthLoginLoadingState,
                  builder: (context, isLoading) {
                    return CommonButton(
                      isLoading: isLoading,
                      text: 'Login',
                      onPressed: isLoading ? null : _handleLogin,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      text: 'Don\'t have an account?',
                      style: context.bodyMedium.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.router.replace(SignupRoute()),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppPallete.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
