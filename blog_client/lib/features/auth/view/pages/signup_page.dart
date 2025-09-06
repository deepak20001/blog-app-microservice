import 'package:auto_route/auto_route.dart';
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
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthSignupEvent(
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          bio: _bioController.text.trim(),
        ),
      );
    }
  }

  void _onBlocListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthSignupSuccessState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        break;
      case AuthSignupFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: _onBlocListener,
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: context.paddingSymmetric(
                horizontal: numD035,
                vertical: numD2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: size.width * numD01,
                  children: [
                    CommonText(
                      text: 'Create Account',
                      style: context.displaySmall,
                    ),
                    CommonText(
                      text: 'Sign up to get started',
                      style: context.bodyMedium,
                    ),
                    context.sizedBoxHeight(numD05),
                    CommonTextFormField(
                      controller: _usernameController,
                      hintText: 'Enter your username',
                      label: 'Username',
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppPallete.primaryColor,
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          ValidationHelper.validateRequiredFields(
                            value: value,
                            fieldName: 'Username',
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
                      controller: _passwordController,
                      hintText: 'Enter your password',
                      label: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: AppPallete.primaryColor,
                      ),
                      obscureText: true,
                      validator: ValidationHelper.validatePassword,
                    ),
                    CommonTextFormField(
                      controller: _bioController,
                      hintText: 'Tell us about yourself',
                      label: 'Bio',
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: AppPallete.primaryColor,
                      ),
                      maxLines: 3,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) =>
                          ValidationHelper.validateRequiredFields(
                            value: value,
                            fieldName: 'Bio',
                          ),
                    ),
                    context.sizedBoxHeight(numD035),
                    BlocSelector<AuthBloc, AuthState, bool>(
                      bloc: _authBloc,
                      selector: (state) => state is AuthSignupLoadingState,
                      builder: (context, isLoading) {
                        return CommonButton(
                          isLoading: isLoading,
                          text: 'Sign Up',
                          onPressed: isLoading ? null : _handleSignup,
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(
                          text: 'Already have an account?',
                          style: context.bodyMedium.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.router.replace(LoginRoute()),
                          child: Text(
                            'Login',
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
        ),
      ),
    );
  }
}
