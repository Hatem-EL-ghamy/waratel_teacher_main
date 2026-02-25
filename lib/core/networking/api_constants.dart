class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://wartil.com/api';

  // Auth Endpoints
  static const String teacherLogin = '/teacher/login';
  static const String teacherLogout = '/teacher/logout';

  // Profile Endpoints
  static const String teacherProfile = '/teacher/profile';

  // Ads Endpoints
  static const String teacherAds = '/teacher/ads';

  // Schedule Endpoints
  static const String teacherSlots = '/teacher/slots';
  static const String teacherMySlots = '/teacher/my-slots';
  static const String teacherSlotsByDay = '/teacher/slots-by-day';

  // Sessions (Maqraa) Endpoints
  static const String teacherMySessions = '/teacher/sessions/my-sessions';
  static String teacherStartSession(int sessionId) => '/teacher/sessions/$sessionId/start';
  static String teacherEndSession(int sessionId) => '/teacher/sessions/$sessionId/end';
  static String teacherSessionAttendance(int sessionId) => '/teacher/sessions/$sessionId/attendance';

  // Agora
  static const String agoraAppId = '6682980a1c8948ad945fcf00ee47a4c1';
}
