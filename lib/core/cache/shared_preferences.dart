import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

/// خدمة إدارة التخزين المحلي
class SharedPreferencesService {
  static SharedPreferences? _preferences;

  /// تهيئة SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// الحصول على instance من SharedPreferences
  static SharedPreferences get instance {
    if (_preferences == null) {
      throw Exception('SharedPreferences not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // ========== حفظ البيانات ==========

  /// حفظ التوكن
  static Future<bool> saveToken(String token) async {
    return await instance.setString(AppConstants.tokenKey, token);
  }

  /// حفظ بيانات المستخدم
  static Future<bool> saveUserData(String userData) async {
    return await instance.setString(AppConstants.userDataKey, userData);
  }

  /// حفظ حالة تسجيل الدخول
  static Future<bool> setLoggedIn(bool isLoggedIn) async {
    return await instance.setBool(AppConstants.isLoggedInKey, isLoggedIn);
  }

  /// حفظ حالة عرض الـ Onboarding
  static Future<bool> setHasSeenOnboarding(bool hasSeen) async {
    return await instance.setBool(AppConstants.hasSeenOnboardingKey, hasSeen);
  }

  /// حفظ اللغة
  static Future<bool> saveLanguage(String languageCode) async {
    return await instance.setString(AppConstants.languageKey, languageCode);
  }

  // ========== استرجاع البيانات ==========

  /// الحصول على التوكن
  static String? getToken() {
    return instance.getString(AppConstants.tokenKey);
  }

  /// الحصول على بيانات المستخدم
  static String? getUserData() {
    return instance.getString(AppConstants.userDataKey);
  }

  /// التحقق من حالة تسجيل الدخول
  static bool isLoggedIn() {
    return instance.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  /// التحقق من عرض الـ Onboarding
  static bool hasSeenOnboarding() {
    return instance.getBool(AppConstants.hasSeenOnboardingKey) ?? false;
  }

  /// الحصول على اللغة المحفوظة
  static String getLanguage() {
    return instance.getString(AppConstants.languageKey) ?? 
           AppConstants.defaultLanguage;
  }

  // ========== حذف البيانات ==========

  /// حذف التوكن
  static Future<bool> removeToken() async {
    return await instance.remove(AppConstants.tokenKey);
  }

  /// حذف بيانات المستخدم
  static Future<bool> removeUserData() async {
    return await instance.remove(AppConstants.userDataKey);
  }

  /// تسجيل الخروج (حذف جميع البيانات)
  static Future<bool> logout() async {
    await removeToken();
    await removeUserData();
    return await setLoggedIn(false);
  }

  /// مسح جميع البيانات
  static Future<bool> clearAll() async {
    return await instance.clear();
  }
}
