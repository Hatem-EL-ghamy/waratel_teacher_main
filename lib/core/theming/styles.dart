import 'colors.dart';
import 'font_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  // العناوين الكبيرة
  static TextStyle font32BoldTextPrimary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 32.sp,
    fontWeight: AppFontWeight.bold,
    color: ColorsManager.textPrimaryColor,
  );

  static TextStyle font28BoldTextPrimary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 28.sp,
    fontWeight: AppFontWeight.bold,
    color: ColorsManager.textPrimaryColor,
  );

  static TextStyle font24SemiBoldTextPrimary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24.sp,
    fontWeight: AppFontWeight.semiBold,
    color: ColorsManager.textPrimaryColor,
  );

  // العناوين المتوسطة
  static TextStyle font20MediumTextPrimary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20.sp,
    fontWeight: AppFontWeight.medium,
    color: ColorsManager.textPrimaryColor,
  );

  static TextStyle font18MediumTextPrimary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18.sp,
    fontWeight: AppFontWeight.medium,
    color: ColorsManager.textPrimaryColor,
  );

  // النصوص العادية
  static TextStyle font16RegularTextPrimary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16.sp,
    fontWeight: AppFontWeight.regular,
    color: ColorsManager.textPrimaryColor,
  );

  static TextStyle font14RegularTextSecondary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14.sp,
    fontWeight: AppFontWeight.regular,
    color: ColorsManager.textSecondaryColor,
  );

  // النصوص الصغيرة
  static TextStyle font12RegularTextSecondary = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12.sp,
    fontWeight: AppFontWeight.regular,
    color: ColorsManager.textSecondaryColor,
  );

  static TextStyle font16SemiBoldWhite = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16.sp,
    fontWeight: AppFontWeight.semiBold,
    color: Colors.white,
  );
}

// Backwards-compatible wrapper and app-level styles
class AppStyles {
  // Map older names to the new `TextStyles` definitions
  static TextStyle get headline1 => TextStyles.font32BoldTextPrimary;
  static TextStyle get subtitle2 => TextStyles.font16SemiBoldWhite;

  // Minimal light theme used by the app (keeps mapping simple)
  static final ThemeData lightTheme = () {
    final base = ThemeData.light();
    return base.copyWith(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        background: AppColors.backgroundColor,
      ),
      // تطبيق خط Cairo المحلي على مستوى التطبيق
      textTheme: base.textTheme.apply(fontFamily: 'Cairo'),
    );
  }();
}
