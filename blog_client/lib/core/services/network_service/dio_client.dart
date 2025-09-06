import 'dart:developer' as devtools show log;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/services/local_db_service/shared_preferences_storage_repository.dart';
import 'package:blog_client/core/services/network_service/network_exceptions.dart';

@lazySingleton
class DioClient {
  DioClient({
    required Dio dio,
    required SharedPreferencesStorageRepository storageRepository,
  }) : _dio = dio,
       _storageRepository = storageRepository {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 20000),
      receiveTimeout: const Duration(milliseconds: 50000),
      headers: _getDefaultHeaders(),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  final Dio _dio;
  final SharedPreferencesStorageRepository _storageRepository;

  Map<String, String> _getDefaultHeaders() {
    final token = _storageRepository.accessToken;
    return {
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<Response<T>> request<T>(
    String method,
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool isFormData = false,
  }) async {
    try {
      final requestData = _prepareData(data, isFormData);

      final response = await _dio.request<T>(
        url,
        data: requestData,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: {..._getDefaultHeaders(), ...?headers},
        ),
      );

      return response;
    } on DioException catch (e) {
      devtools.log('Request failed: $method $url - ${e.message}');
      throw _handleError(e);
    } catch (e) {
      devtools.log('Unknown error: $method $url - $e');
      throw NetworkException(AppConstants.defaultError);
    }
  }

  dynamic _prepareData(dynamic data, bool isFormData) {
    if (isFormData && data is! FormData && data != null) {
      return FormData.fromMap(data as Map<String, dynamic>);
    }
    return data;
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) => request<T>(
    'GET',
    url,
    queryParameters: queryParameters,
    headers: headers,
  );

  Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
    bool isFormData = false,
  }) => request<T>(
    'POST',
    url,
    data: data,
    headers: headers,
    isFormData: isFormData || data is FormData,
  );

  Future<Response<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
    bool isFormData = false,
  }) => request<T>(
    'PUT',
    url,
    data: data,
    headers: headers,
    isFormData: isFormData || data is FormData,
  );

  Future<Response<T>> patch<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
    bool isFormData = false,
  }) => request<T>(
    'PATCH',
    url,
    data: data,
    headers: headers,
    isFormData: isFormData || data is FormData,
  );

  Future<Response<T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, String>? headers,
  }) => request<T>('DELETE', url, data: data, headers: headers);

  NetworkException _handleError(DioException e) {
    final responseData = e.response?.data;
    String errorMessage =
        _extractErrorMessage(responseData) ??
        _getDefaultErrorMessage(e.response?.statusCode);

    return NetworkException(errorMessage);
  }

  String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Try direct message first
      if (responseData['error'] is String) {
        return responseData['error'] as String;
      }
    }

    if (responseData is String) {
      return responseData;
    }

    return null;
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Validation failed';
      case 500:
        return 'Internal server error';
      default:
        return AppConstants.defaultError;
    }
  }
}
