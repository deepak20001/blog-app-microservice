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
  static String profile({required String id}) =>
      '$userServiceBaseUrl/users/$id';
  static String profileStats({required String id}) =>
      '$userServiceBaseUrl/users/profile-stats/$id';
  static String get logout => '$userServiceBaseUrl/users/logout';
  static String get updateProfile => '$userServiceBaseUrl/users';
  static String get updateAvatar => '$userServiceBaseUrl/users/avatar';

  // Categories
  static String get categories => '$blogServiceBaseUrl/blogs/categories';

  // Blog Service Endpoints
  static String blogsFilter({
    required int page,
    required int limit,
    required int categoryId,
    required String search,
  }) =>
      '$blogServiceBaseUrl/blogs/filter?page=$page&limit=$limit&search=$search' +
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
  static String get getMyBlogs => '$blogServiceBaseUrl/blogs/my-blogs';
  static String get getSavedBlogs => '$blogServiceBaseUrl/blogs/saved-blogs';

  /// Media Service Endpoints
  static String get uploadBlogImage => '$mediaServiceBaseUrl/media/blog-image';
  static String get uploadAvatar => '$mediaServiceBaseUrl/media/avatar-upload';

  /// Comment Service Endpoints
  static String fetchComments({required int blogId}) =>
      '$blogServiceBaseUrl/comments/$blogId';
  static String get createComment => '$blogServiceBaseUrl/comments';
  static String get upvoteComment => '$blogServiceBaseUrl/comments/upvote';
  static String get unupvoteComment => '$blogServiceBaseUrl/comments/unupvote';

  /// Followers Followings Service Endpoints
  static String getFollowers({required String id}) =>
      '$userServiceBaseUrl/relationships/followers/$id';
  static String getFollowings({required String id}) =>
      '$userServiceBaseUrl/relationships/followings/$id';
  static String get followProfile => '$userServiceBaseUrl/relationships/follow';
  static String get unfollowProfile =>
      '$userServiceBaseUrl/relationships/unfollow';

  // AI Service Endpoints
  static String get generateAiTitle => '$blogServiceBaseUrl/blogs/ai-title';
  static String get generateAiShortDescription =>
      '$blogServiceBaseUrl/blogs/ai-short-desc';
  static String get generateAiDescription =>
      '$blogServiceBaseUrl/blogs/ai-desc';

  // Search Service Endpoints
  static String searchUsers({
    required String search,
    required int page,
    required int limit,
  }) => '$userServiceBaseUrl/users?search=$search&page=$page&limit=$limit';
}
