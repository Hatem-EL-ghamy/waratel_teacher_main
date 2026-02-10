import 'core/theming/styles.dart';
import 'core/routing/routers.dart';
import 'core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// التطبيق الرئيسي - ورتّل للمعلم
/// يحتوي على جميع الإعدادات والروتات والثيم
class WaratelApp extends StatelessWidget {
  const WaratelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // تصميم التطبيق بناءً على حجم الشاشة
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // ========== إعدادات التطبيق ==========
          title: 'ورتّل للمعلم',
          debugShowCheckedModeBanner: false,

          // ========== الثيم ==========
          theme: AppStyles.lightTheme,

          // ========== اللغة والاتجاه ==========
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [
            Locale('ar', 'SA'), // العربية
            Locale('en', 'US'), // الإنجليزية
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ========== التوجيه ==========
          initialRoute: Routes.splash,
          onGenerateRoute: AppRouter.generateRoute,

          // ========== Builder ==========
          builder: (context, widget) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: widget!,
            );
          },
        );
      },
    );
  }
}
