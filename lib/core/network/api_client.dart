import 'package:get/get.dart';

/// Base API Client dùng GetConnect.
/// Mọi Service đều kế thừa class này.
class ApiClient extends GetConnect {
  // TODO: Thay bằng base URL thực tế của dự án
  static const String _baseUrl = 'https://apitinnguong.gvbsoft.vn/api';

  @override
  void onInit() {
    httpClient.baseUrl = _baseUrl;
    httpClient.timeout = const Duration(seconds: 30);

    // Gắn token tự động vào mọi request
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = _getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      return request;
    });

    // Log response lỗi (chỉ debug)
    httpClient.addResponseModifier((request, response) async {
      if (!response.isOk) {
        // ignore: avoid_print
        print('[API ERROR] ${request.method} ${request.url} → ${response.statusCode}');
      }
      return response;
    });

    super.onInit();
  }

  String? _getToken() {
    // Lấy token từ GetStorage hoặc SharedPreferences
    // Ví dụ: return GetStorage().read('access_token');
    return null;
  }
}
