import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static const String baseUrl = 'https://apitinnguong.gvbsoft.vn';
  static final DioClient _instance = DioClient._internal();
  
  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'tinnguong.tokenId';

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Tự động gán token (không kèm prefix Bearer)
        final token = await _storage.read(key: _tokenKey);
        if (token != null && options.path != '/api/user/login') {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Tự động unwrap cấu trúc response
        final data = response.data;
        if (data is Map<String, dynamic>) {
          // Check success flag nếu có
          if (data.containsKey('Success') && data['Success'] == false) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                error: data['Message'] ?? 'Unknown Error',
              ),
            );
          }
          
          // Trả về data / Data nếu được wrap
          if (data.containsKey('Data')) {
            response.data = data['Data'];
          } else if (data.containsKey('data')) {
            response.data = data['data'];
          }
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('API Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;

  // Utilities
  static const String _userKey = 'tinnguong.user';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveUserJson(String json) async {
    await _storage.write(key: _userKey, value: json);
  }

  Future<String?> getUserJson() async {
    return await _storage.read(key: _userKey);
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}