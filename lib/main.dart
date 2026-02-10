import 'package:flutter/material.dart';
import 'core/di/dependency_injection.dart';
import 'waratel_app.dart';

/// نقطة البداية الرئيسية للتطبيق
/// هذا الملف يحتوي فقط على كود التشغيل الأساسي
void main() async {
  // التأكد من تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // إعداد Dependency Injection
  await setupGetIt();
  
  // تشغيل التطبيق
  runApp(const WaratelApp());
}
