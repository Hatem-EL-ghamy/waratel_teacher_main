import 'package:dio/dio.dart';
import 'package:waratel_app/core/networking/api_constants.dart';
import '../models/call_model.dart';

class CallsApi {
  final Dio _dio;

  CallsApi(this._dio);

  /// GET /teacher/calls
  Future<CallListResponse> getCalls({int page = 1}) async {
    final response = await _dio.get(
      ApiConstants.teacherCalls,
      queryParameters: {'page': page},
    );
    return CallListResponse.fromJson(response.data);
  }

  /// GET /teacher/calls/{id}
  Future<Map<String, dynamic>> getCallDetail(int callId) async {
    final response = await _dio.get(ApiConstants.teacherCallDetail(callId));
    return response.data;
  }

}
