import 'package:dio/dio.dart';
import '../../../../core/cache/shared_preferences.dart';
import '../api/home_api.dart';
import '../models/home_models.dart';

class HomeRepo {
  final HomeApi _homeApi;

  HomeRepo(this._homeApi);

  Future<ToggleOnlineResponse> toggleOnline() async {
    try {
      final response = await _homeApi.toggleOnline();
      // Persist the status locally using SharedPreferencesService
      await SharedPreferencesService.instance.setBool('is_online', response.data.isOnline);
      return response;
    } on DioException catch (e) {
      final serverMessage = e.response?.data?['message'];
      throw Exception(serverMessage ?? 'فشل تحديث حالة الاتصال');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  Future<bool> getLocalOnlineStatus() async {
    return SharedPreferencesService.instance.getBool('is_online') ?? false;
  }

  Future<dynamic> getSoon() async {
    try {
      return await _homeApi.getSoon();
    } catch (e) {
      throw Exception('فشل جلب الحجز القادم');
    }
  }
}
