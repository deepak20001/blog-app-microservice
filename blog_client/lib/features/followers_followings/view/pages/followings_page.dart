import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/common/widgets/loader.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:blog_client/core/utils/snack_bar_utils.dart';
import 'package:blog_client/features/followers_followings/view/widgets/user_card.dart';
import 'package:blog_client/features/followers_followings/viewmodel/follow_followings_bloc.dart';
import 'package:blog_client/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class FollowingsPage extends StatefulWidget {
  const FollowingsPage({super.key, required this.userId});
  final String userId;

  @override
  State<FollowingsPage> createState() => _FollowingsPageState();
}

class _FollowingsPageState extends State<FollowingsPage> {
  final FollowFollowingsBloc _followFollowingsBloc =
      getIt<FollowFollowingsBloc>();

  @override
  void initState() {
    super.initState();
    _followFollowingsBloc.add(
      FollowFollowingsGetFollowingsEvent(id: widget.userId),
    );
  }

  void _onBlocListener(BuildContext context, FollowFollowingsState state) {
    switch (state) {
      case FollowFollowingsGetFollowingsFailureState(:final errorMessage):
        SnackbarUtils.showError(context: context, message: errorMessage);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocListener<FollowFollowingsBloc, FollowFollowingsState>(
      bloc: _followFollowingsBloc,
      listener: _onBlocListener,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppPallete.backgroundColor,
          elevation: 0,
          title: CommonText(
            text: 'Following',
            style: context.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppPallete.textPrimary,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.router.maybePop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppPallete.textPrimary,
              size: size.width * numD06,
            ),
          ),
        ),
        body: BlocBuilder<FollowFollowingsBloc, FollowFollowingsState>(
          bloc: _followFollowingsBloc,
          buildWhen: (previous, current) =>
              current is! FollowFollowingsGetFollowingsLoadingState ||
              current is! FollowFollowingsGetFollowingsSuccessState ||
              current is! FollowFollowingsGetFollowingsFailureState,
          builder: (context, state) {
            if (state is FollowFollowingsGetFollowingsLoadingState) {
              return Loader(color: AppPallete.primaryColor);
            }

            if (state.data.isEmpty) {
              return _buildEmptyState(context, size);
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: size.width * numD01),
              itemCount: state.data.length,
              itemBuilder: (context, index) {
                return UserCard(
                  size: size,
                  followFollowingsBloc: _followFollowingsBloc,
                  user: state.data[index],
                  isFollowers: false,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: size.width * numD2,
            color: AppPallete.greyColor400,
          ),
          context.sizedBoxHeight(numD02),
          CommonText(
            text: 'No followings yet',
            style: context.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppPallete.textSecondary,
            ),
          ),
          context.sizedBoxHeight(numD01),
          CommonText(
            text: 'When you follow someone, they\'ll appear here',
            style: context.bodyMedium.copyWith(color: AppPallete.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
