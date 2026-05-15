import 'package:get/get.dart';
import '../models/api_response.dart';
import '../../core/network/api_client.dart';

/// Base Service — Tất cả service đều kế thừa class này.
/// Cung cấp các hàm tiện ích: get, post, put, delete.
abstract class BaseService extends ApiClient {
  /// GET request
  Future<ApiResponse<T>> getRequest<T>(
    String endpoint, {
    Map<String, dynamic>? query,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await get(endpoint, query: query);
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Lỗi kết nối: $e');
    }
  }

  /// POST request
  Future<ApiResponse<T>> postRequest<T>(
    String endpoint, {
    dynamic body,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await post(endpoint, body);
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Lỗi kết nối: $e');
    }
  }

  /// PUT request
  Future<ApiResponse<T>> putRequest<T>(
    String endpoint, {
    dynamic body,
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await put(endpoint, body);
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Lỗi kết nối: $e');
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> deleteRequest<T>(
    String endpoint, {
    required T Function(dynamic) fromJson,
  }) async {
    try {
      final response = await delete(endpoint);
      return _handleResponse(response, fromJson);
    } catch (e) {
      return ApiResponse.error('Lỗi kết nối: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Internal
  // ---------------------------------------------------------------------------
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic) fromJson,
  ) {
    if (response.isOk && response.body != null) {
      try {
        return ApiResponse.fromJson(
          response.body as Map<String, dynamic>,
          fromJson,
        );
      } catch (e) {
        return ApiResponse.error('Lỗi parse dữ liệu: $e');
      }
    }
    return ApiResponse.error(
      response.statusText ?? 'Lỗi không xác định',
      statusCode: response.statusCode,
    );
  }
}
