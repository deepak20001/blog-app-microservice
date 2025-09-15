// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:blog_client/features/auth/view/pages/login_page.dart' as _i4;
import 'package:blog_client/features/auth/view/pages/signup_page.dart' as _i5;
import 'package:blog_client/features/blog_details/view/pages/blog_details_page.dart'
    as _i1;
import 'package:blog_client/features/blogs/view/pages/blogs_page.dart' as _i2;
import 'package:blog_client/features/create_blog/view/pages/create_blog_page.dart'
    as _i3;
import 'package:flutter/material.dart' as _i7;

/// generated route for
/// [_i1.BlogDetailsPage]
class BlogDetailsRoute extends _i6.PageRouteInfo<BlogDetailsRouteArgs> {
  BlogDetailsRoute({
    _i7.Key? key,
    required int blogId,
    List<_i6.PageRouteInfo>? children,
  }) : super(
         BlogDetailsRoute.name,
         args: BlogDetailsRouteArgs(key: key, blogId: blogId),
         initialChildren: children,
       );

  static const String name = 'BlogDetailsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BlogDetailsRouteArgs>();
      return _i1.BlogDetailsPage(key: args.key, blogId: args.blogId);
    },
  );
}

class BlogDetailsRouteArgs {
  const BlogDetailsRouteArgs({this.key, required this.blogId});

  final _i7.Key? key;

  final int blogId;

  @override
  String toString() {
    return 'BlogDetailsRouteArgs{key: $key, blogId: $blogId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BlogDetailsRouteArgs) return false;
    return key == other.key && blogId == other.blogId;
  }

  @override
  int get hashCode => key.hashCode ^ blogId.hashCode;
}

/// generated route for
/// [_i2.BlogsPage]
class BlogsRoute extends _i6.PageRouteInfo<void> {
  const BlogsRoute({List<_i6.PageRouteInfo>? children})
    : super(BlogsRoute.name, initialChildren: children);

  static const String name = 'BlogsRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.BlogsPage();
    },
  );
}

/// generated route for
/// [_i3.CreateBlogPage]
class CreateBlogRoute extends _i6.PageRouteInfo<void> {
  const CreateBlogRoute({List<_i6.PageRouteInfo>? children})
    : super(CreateBlogRoute.name, initialChildren: children);

  static const String name = 'CreateBlogRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.CreateBlogPage();
    },
  );
}

/// generated route for
/// [_i4.LoginPage]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.LoginPage();
    },
  );
}

/// generated route for
/// [_i5.SignupPage]
class SignupRoute extends _i6.PageRouteInfo<void> {
  const SignupRoute({List<_i6.PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignupPage();
    },
  );
}
