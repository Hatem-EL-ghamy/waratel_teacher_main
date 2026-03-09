import '../api/calls_api.dart';
import '../models/call_model.dart';

class CallsRepo {
  final CallsApi _api;

  CallsRepo(this._api);

  Future<CallListResponse> getCalls({int page = 1}) async {
    return await _api.getCalls(page: page);
  }

  Future<Map<String, dynamic>> getCallDetail(int callId) async {
    return await _api.getCallDetail(callId);
  }

}
