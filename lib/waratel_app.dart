import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:waratel_app/core/call/call_service.dart';
import 'package:waratel_app/core/di/dependency_injection.dart';
import 'package:waratel_app/core/routing/app_router.dart';
import 'package:waratel_app/core/routing/routers.dart';
import 'package:waratel_app/core/theming/styles.dart';
import 'package:waratel_app/features/localization/data/app_localizations.dart';
import 'package:waratel_app/features/localization/logic/cubit/locale_cubit.dart';
import 'package:waratel_app/features/localization/logic/cubit/locale_state.dart';

/// التطبيق الرئيسي - ورتّل للمعلم
/// يحتوي على جميع الإعدادات والروتات والثيم
class WaratelApp extends StatelessWidget {
  const WaratelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LocaleCubit>()..getSavedLanguage(),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (prev, curr) => curr is ChangeLocaleState,
        builder: (context, state) {
          Locale locale = const Locale('ar');
          if (state is ChangeLocaleState) {
            locale = state.locale;
          }
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

                // ========== مفتاح التنقل (مطلوب لـ CallService) ==========
                navigatorKey: navigatorKey,

                // ========== الثيم ==========
                theme: AppStyles.lightTheme,

                // ========== اللغة والاتجاه ==========
                locale: locale,
                supportedLocales: const [
                  Locale('ar'), // العربية
                  Locale('en'), // الإنجليزية
                ],
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                // ========== التوجيه ==========
                initialRoute: Routes.splash,
                onGenerateRoute: AppRouter.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
