import 'package:get/get.dart';
import 'dart:developer';
import '../../../core/network/dio_client.dart';
import '../../../data/models/office_model.dart';

class FacilitiesController extends GetxController {
  final _dio = DioClient().dio;

  final isLoading = false.obs;
  final facilities = <OfficeModel>[].obs;
  final total = 0.obs;
  final page = 1.obs;
  final limit = 20;

  final searchKey = ''.obs;
  final selectedTypeID = 0.obs;
  final selectedStatusID = (-100).obs;

  @override
  void onInit() {
    super.onInit();
    fetchFacilities();
    ever(selectedTypeID, (_) => _resetAndFetch());
    ever(selectedStatusID, (_) => _resetAndFetch());
  }

  void _resetAndFetch() {
    page.value = 1;
    fetchFacilities();
  }

  Future<void> fetchFacilities({bool refresh = false}) async {
    if (refresh) page.value = 1;
    isLoading.value = true;
    try {
      final params = <String, dynamic>{
        'statusID': selectedStatusID.value,
        'page': page.value,
        'limit': limit,
      };
      if (searchKey.value.isNotEmpty) params['key'] = searchKey.value;
      if (selectedTypeID.value > 0) params['typeOfficeID'] = selectedTypeID.value;

      final res = await _dio.get('/api/office/get-list', queryParameters: params);
      final raw = res.data;
      List<dynamic> list = raw is List ? raw : [];
      final parsed = list.map((e) => OfficeModel.fromJson(e as Map<String, dynamic>)).toList();

      if (refresh || page.value == 1) {
        facilities.value = parsed;
      } else {
        facilities.addAll(parsed);
      }
      total.value = facilities.length;
    } catch (e) {
      log('FacilitiesController.fetchFacilities error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void search(String key) {
    searchKey.value = key;
    _resetAndFetch();
  }
}
