import 'package:dio/dio.dart';
import '../../../../core/networking/api_constants.dart';
import '../models/schedule_models.dart';

class ScheduleApi {
  final Dio _dio;

  ScheduleApi(this._dio);

  /// GET /teacher/my-slots
  Future<MySlotsResponse> getMySlots({int page = 1, int perPage = 5}) async {
    final response = await _dio.get(
      ApiConstants.teacherMySlots,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    return MySlotsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// POST /teacher/slots (Batch Addition using FormData)
  Future<AddSlotsResponse> addBatchSlots({
    required String date,
    required List<String> startTimes,
    required List<String> endTimes,
  }) async {
    final response = await _dio.post(
      ApiConstants.teacherSlots,
      data: FormData.fromMap({
        'date': date,
        'start_time': startTimes,
        'end_time': endTimes,
      }),
    );
    return AddSlotsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /teacher/slots/{id}
  Future<DeleteSlotResponse> deleteSlot(int slotId) async {
    final response = await _dio.delete(
      '${ApiConstants.teacherSlots}/$slotId',
    );
    return DeleteSlotResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// DELETE /teacher/slots-by-day
  Future<DeleteSlotsByDayResponse> deleteSlotsByDay(String date) async {
    final response = await _dio.post(
      ApiConstants.teacherSlotsByDay,
      data: {
        'date': date,
      },
    );
    return DeleteSlotsByDayResponse.fromJson(
        response.data as Map<String, dynamic>);
  }
}
