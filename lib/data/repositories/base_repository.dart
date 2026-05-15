import '../models/api_response.dart';

/// Base Repository — Tất cả repository đều kế thừa class này.
/// Repository là cầu nối giữa Service (data source) và Controller (ViewModel).
abstract class BaseRepository {
  /// Xử lý lỗi chung từ ApiResponse và ném exception nếu cần.
  T handleResult<T>(ApiResponse<T> response) {
    if (response.isSuccess) {
      return response.data as T;
    }
    throw Exception(response.message ?? 'Có lỗi xảy ra');
  }
}
