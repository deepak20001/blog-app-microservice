import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/widgets/common_button.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/common_text_form_field_first.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/core/utils/validation_helper.dart';
import 'package:blog_client/features/security/viewmodel/security_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _passwordController = TextEditingController();
  final SecurityBloc _securityBloc = getIt<SecurityBloc>();
  final ValueNotifier<bool> _obscure = ValueNotifier(true);
  final ValueNotifier<bool> _acknowledged = ValueNotifier(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onDeleteAccount() {
    if (_formKey.currentState!.validate()) {
      if (!_acknowledged.value) {
        SnackbarUtils.showError(
          context: context,
          message: 'Please acknowledge the action',
        );
        return;
      }
      _securityBloc.add(
        SecurityDeleteAccountEvent(password: _passwordController.text),
      );
    }
  }

  void _onBlocListener(BuildContext context, SecurityState state) {
    switch (state) {
      case SecurityDeleteAccountSuccessState(:final successMessage):
        SnackbarUtils.showSuccess(context: context, message: successMessage);
        context.router.replaceAll([const LoginRoute()]);
        break;
      case SecurityDeleteAccountFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _obscure.dispose();
    _acknowledged.dispose();
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
            title: const CommonText(text: 'Delete Account'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: context.paddingSymmetric(
              horizontal: numD04,
              vertical: numD04,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CommonText(
                    text:
                        'Confirm your current password to delete your account.',
                    color: AppPallete.greyColor700,
                  ),
                  ValueListenableBuilder(
                    valueListenable: (_obscure),
                    builder: (context, value, child) {
                      return CommonTextFormField(
                        controller: _passwordController,
                        hintText: 'Current password',
                        label: 'Current password',
                        obscureText: !value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            value ? Icons.visibility : Icons.visibility_off,
                            color: AppPallete.greyColor700,
                          ),
                          onPressed: () => _obscure.value = !value,
                        ),
                        validator: ValidationHelper.validateOldPassword,
                      );
                    },
                  ),
                  Spacer(),
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: (_acknowledged),
                        builder: (context, value, child) {
                          return Checkbox(
                            value: value,
                            onChanged: (val) => setState(() {
                              _acknowledged.value = val ?? false;
                            }),
                            activeColor: AppPallete.errorColor,
                          );
                        },
                      ),
                      const Expanded(
                        child: CommonText(
                          text: 'I understand this action cannot be undone.',
                          color: AppPallete.greyColor700,
                        ),
                      ),
                    ],
                  ),
                  BlocSelector<SecurityBloc, SecurityState, bool>(
                    selector: (state) {
                      return state is SecurityDeleteAccountLoadingState;
                    },
                    builder: (context, isLoading) {
                      return CommonButton(
                        isLoading: isLoading,
                        text: 'Delete Account',
                        onPressed: _onDeleteAccount,
                        backgroundColor: AppPallete.errorColor,
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
