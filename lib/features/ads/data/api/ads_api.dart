import 'package:dio/dio.dart';
import '../../../../core/networking/api_constants.dart';
import '../models/ads_response.dart';

class AdsApi {
  final Dio _dio;

  AdsApi(this._dio);

  Future<AdsResponse> getAds({int page = 1, int perPage = 5}) async {
    final response = await _dio.get(
      ApiConstants.teacherAds,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return AdsResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
