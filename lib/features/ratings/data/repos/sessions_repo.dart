import '../api/sessions_api.dart';
import '../models/session_model.dart';

class SessionsRepo {
  final SessionsApi _api;

  SessionsRepo(this._api);

  Future<List<SessionItem>> getMySessions() async {
    final response = await _api.getMySessions();
    return response.data.sessions;
  }

  Future<StartSessionData> startSession(int sessionId) async {
    final response = await _api.startSession(sessionId);
    return response.data;
  }

  Future<bool> endSession(int sessionId) async {
    final response = await _api.endSession(sessionId);
    return response.status;
  }

  Future<AttendanceResponse> getAttendance(int sessionId) async {
    return await _api.getAttendance(sessionId);
  }
}
