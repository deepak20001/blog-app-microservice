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

  /// Blog Service Endpoints
  static String get blogs => '$blogServiceBaseUrl/blogs';
  static String get createBlog => '$blogServiceBaseUrl/blogs';
  static String get updateBlog => '$blogServiceBaseUrl/blogs';
  static String get deleteBlog => '$blogServiceBaseUrl/blogs';

  /// Media Service Endpoints
  static String get uploadImage => '$mediaServiceBaseUrl/upload';
  static String get deleteImage => '$mediaServiceBaseUrl/delete';
}
