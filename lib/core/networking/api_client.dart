import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../cache/shared_preferences.dart';
import 'api_constants.dart';

class ApiClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // ── تجاوز فحص شهادة SSL للأجهزة الحقيقية ──────────────────
    // استخدام adapter مستقر لمنع التعليق في عمليات الـ Handshake
    if (dio.httpClientAdapter is IOHttpClientAdapter) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        // مهلة اتصال قصيرة لمنع الانتظار اللانهائي في حالة فشل الـ Handshake
        client.connectionTimeout = const Duration(seconds: 10);
        client.badCertificateCallback = 
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    // Auth interceptor — injects Bearer token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = SharedPreferencesService.getToken()?.trim();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    // Pretty logger for debugging — only in debug mode to save resources in APK
    // Added AFTER auth interceptor so we can see the Authorization header in logs
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }
}
