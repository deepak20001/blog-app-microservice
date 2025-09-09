import 'package:auto_route/auto_route.dart';
import 'package:blog_client/core/routes/app_routes.gr.dart';
import 'package:blog_client/core/routes/app_routes_name.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    // auth
    AutoRoute(path: AppRoutesName.login, page: LoginRoute.page, initial: true),
    AutoRoute(path: AppRoutesName.signup, page: SignupRoute.page),

    // blogs
    AutoRoute(path: AppRoutesName.blogs, page: BlogsRoute.page),
    AutoRoute(path: AppRoutesName.blogDetails, page: BlogDetailsRoute.page),
  ];
}
