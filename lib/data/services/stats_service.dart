import 'dart:developer';
import '../../core/network/dio_client.dart';
import '../models/dashboard_model.dart';

class StatsService {
  final _dio = DioClient().dio;

  Future<DashboardModel> getDashboard({
    required String fromDate,
    required String toDate,
    required int typeSearch,
  }) async {
    try {
      final res = await _dio.get(
        '/api/report/get-data-dashboard',
        queryParameters: {
          'fromDate':   fromDate,
          'toDate':     toDate,
          'typeSearch': typeSearch,
        },
      );
      final raw = res.data;
      if (raw is Map<String, dynamic>) {
        return DashboardModel.fromJson(raw);
      }
      return DashboardModel.empty;
    } catch (e) {
      log('StatsService.getDashboard error: $e');
      rethrow;
    }
  }
}
