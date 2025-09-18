import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/routes/app_routes_name.dart';
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/injection_container.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final token = getIt<SharedPreferencesStorageRepository>().accessToken;

    if (token.isNotEmpty) {
      router.replace(const BlogsRoute());
    } else {
      resolver.next(true);
    }
  }
}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // auth
    AutoRoute(
      path: AppRoutesName.login,
      page: LoginRoute.page,
      initial: true,
      guards: [AuthGuard()],
    ),
    AutoRoute(path: AppRoutesName.signup, page: SignupRoute.page),
    AutoRoute(
      path: AppRoutesName.forgotPassword,
      page: ForgotPasswordRoute.page,
    ),
    AutoRoute(path: AppRoutesName.verifyOtp, page: VerifyOtpRoute.page),
    AutoRoute(path: AppRoutesName.resetPassword, page: ResetPasswordRoute.page),

    // blogs
    AutoRoute(path: AppRoutesName.blogs, page: BlogsRoute.page),
    AutoRoute(path: AppRoutesName.blogDetails, page: BlogDetailsRoute.page),
    AutoRoute(path: AppRoutesName.createBlog, page: CreateBlogRoute.page),

    // profile
    AutoRoute(path: AppRoutesName.profile, page: ProfileRoute.page),
    AutoRoute(path: AppRoutesName.editProfile, page: EditProfileRoute.page),
    AutoRoute(path: AppRoutesName.followers, page: FollowersRoute.page),
    AutoRoute(path: AppRoutesName.followings, page: FollowingsRoute.page),
    AutoRoute(
      path: AppRoutesName.changePassword,
      page: ChangePasswordRoute.page,
    ),
    AutoRoute(path: AppRoutesName.deleteAccount, page: DeleteAccountRoute.page),

    // search
    AutoRoute(path: AppRoutesName.search, page: SearchRoute.page),
  ];
}
