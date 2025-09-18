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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

@RoutePage()
class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({
    super.key,
    required this.email,
    this.purpose = VerifyOtpPurposeEnums.emailVerification,
  });
  final String email;
  final VerifyOtpPurposeEnums purpose;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final ValueNotifier<int> _resendCountdownNotifier = ValueNotifier(0);
  final AuthBloc _authBloc = getIt<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendCountdownNotifier.value = 60;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_resendCountdownNotifier.value > 0) {
          _resendCountdownNotifier.value--;
        } else {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _handleVerifyOtp() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthVerifyEmailEvent(email: widget.email, otp: _otpController.text),
      );
    }
  }

  void _handleResendOtp() {
    _authBloc.add(AuthResendVerificationOtpEvent(email: widget.email));
  }

  void _handleVerifyPasswordResetOtp() {
    _authBloc.add(
      AuthVerifyPasswordResetOtpEvent(
        email: widget.email,
        otp: _otpController.text,
      ),
    );
  }

  void _handleResendPasswordResetOtp() {
    _authBloc.add(AuthResendPasswordResetOtpEvent(email: widget.email));
  }

  String _getTitle() {
    return widget.purpose == VerifyOtpPurposeEnums.passwordReset
        ? 'Verify Password Reset'
        : 'Verify Email';
  }

  String _getSubtitle() {
    return widget.purpose == VerifyOtpPurposeEnums.passwordReset
        ? 'Enter the code sent to your email to reset your password'
        : 'Enter the verification code sent to your email';
  }

  void _onBlocListener(BuildContext context, AuthState state) {
    switch (state) {
      case AuthVerifyEmailSuccessState(:final successMessage) ||
          AuthResendVerificationOtpSuccessState(:final successMessage):
        if (state is AuthResendVerificationOtpSuccessState) {
          _startResendCountdown();
          _otpController.clear();
        }
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        if (state is AuthVerifyEmailSuccessState) {
          context.router.replace(const BlogsRoute());
        }
        break;
      case AuthVerifyPasswordResetOtpSuccessState(:final successMessage) ||
          AuthResendPasswordResetOtpSuccessState(:final successMessage):
        if (state is AuthResendPasswordResetOtpSuccessState) {
          _startResendCountdown();
          _otpController.clear();
        }
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        if (state is AuthVerifyPasswordResetOtpSuccessState) {
          context.router.replace(
            ResetPasswordRoute(
              email: widget.email,
              otp: _otpController.text.trim(),
            ),
          );
        }

        break;
      case AuthVerifyEmailFailureState(:final errorMessage) ||
          AuthResendVerificationOtpFailureState(:final errorMessage) ||
          AuthVerifyPasswordResetOtpFailureState(:final errorMessage) ||
          AuthResendPasswordResetOtpFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendCountdownNotifier.dispose();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: size.width * numD015,
              children: [
                BlocSelector<AuthBloc, AuthState, bool>(
                  bloc: _authBloc,
                  selector: (state) {
                    return state is AuthVerifyEmailLoadingState ||
                        state is AuthResendVerificationOtpLoadingState ||
                        state is AuthVerifyPasswordResetOtpLoadingState ||
                        state is AuthResendPasswordResetOtpLoadingState;
                  },
                  builder: (context, isLoading) {
                    return CommonButton(
                      isLoading: isLoading,
                      text: 'Verify Code',
                      onPressed:
                          widget.purpose == VerifyOtpPurposeEnums.passwordReset
                          ? _handleVerifyPasswordResetOtp
                          : _handleVerifyOtp,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(
                      text: "Didn't receive the code? ",
                      style: context.bodyMedium.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _resendCountdownNotifier,
                      builder: (context, value, child) {
                        if (value == 0) {
                          return TextButton(
                            onPressed:
                                widget.purpose ==
                                    VerifyOtpPurposeEnums.passwordReset
                                ? _handleResendPasswordResetOtp
                                : _handleResendOtp,
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                color: AppPallete.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        } else {
                          return Text(
                            'Resend in ${value}s',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
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
                spacing: size.width * numD03,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppPallete.primaryColor.withValues(alpha: numD1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      size: size.width * numD1,
                      color: AppPallete.primaryColor,
                    ),
                  ),
                  CommonText(
                    text: _getTitle(),
                    style: context.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  CommonText(
                    text: _getSubtitle(),
                    style: context.bodyMedium.copyWith(
                      color: AppPallete.greyColor400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * numD035,
                      vertical: size.width * numD025,
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
                        CommonText(
                          text: widget.email,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  CommonTextFormField(
                    controller: _otpController,
                    hintText: 'Enter 6-digit code',
                    label: 'Verification Code',
                    prefixIcon: Icon(
                      Icons.security,
                      color: AppPallete.primaryColor,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the verification code';
                      }
                      if (value.length != 6) {
                        return 'Please enter a 6-digit code';
                      }
                      return null;
                    },
                    textStyle: context.headlineSmall.copyWith(
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
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
