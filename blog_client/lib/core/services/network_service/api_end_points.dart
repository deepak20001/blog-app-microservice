import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  // Microservice base URLs
  static String userServiceBaseUrl =
      '${dotenv.env['USER_SERVICE_BASE_URL']}/api/v1';
  static String blogServiceBaseUrl =
      '${dotenv.env['BLOG_SERVICE_BASE_URL']}/api/v1';
  static String mediaServiceBaseUrl =
      '${dotenv.env['MEDIA_SERVICE_BASE_URL']}/api/v1';

  /// User Service Endpoints
  static String get login => '$userServiceBaseUrl/users/login';
  static String get register => '$userServiceBaseUrl/users/register';
  static String get profile => '$userServiceBaseUrl/users/profile';
  static String get logout => '$userServiceBaseUrl/users/logout';

  // Categories
  static String get categories => '$blogServiceBaseUrl/blogs/categories';

  // Blog Service Endpoints
  static String blogsFilter({
    required int page,
    required int limit,
    required int categoryId,
    required String search,
  }) =>
      '$blogServiceBaseUrl/blogs-filter?page=$page&limit=$limit&search=$search' +
      (categoryId != 0 ? '&category_id=$categoryId' : '');
  static String blogDetails({required String id}) =>
      '$blogServiceBaseUrl/blogs/$id';
  static String get createBlog => '$blogServiceBaseUrl/blogs';
  static String get updateBlog => '$blogServiceBaseUrl/blogs';
  static String get deleteBlog => '$blogServiceBaseUrl/blogs';
  static String get saveBlog => '$blogServiceBaseUrl/blogs/save-blog';
  static String get unsaveBlog => '$blogServiceBaseUrl/blogs/unsave-blog';
  static String get upvoteBlog => '$blogServiceBaseUrl/blogs/upvote-blog';
  static String get unupvoteBlog => '$blogServiceBaseUrl/blogs/unupvote-blog';

  /// Media Service Endpoints
  static String get uploadImage => '$mediaServiceBaseUrl/upload';
  static String get deleteImage => '$mediaServiceBaseUrl/delete';
}
