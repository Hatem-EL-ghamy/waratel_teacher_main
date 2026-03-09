import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';
import 'font_weight.dart';

class TextStyles {
  TextStyles._();

  // ── Headlines ───────────────────────────────────────────────────────────
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

  // ── Body ─────────────────────────────────────────────────────────────────
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

  // ── Small ─────────────────────────────────────────────────────────────────
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

class AppStyles {
  AppStyles._();

  // ── Backwards-compatible getters ─────────────────────────────────────────
  static TextStyle get headline1 => TextStyles.font32BoldTextPrimary;
  static TextStyle get subtitle2 => TextStyles.font16SemiBoldWhite;

  // ── Centralized Theme ──────────────────────────────────────────────────
  static final ThemeData lightTheme = () {
    final base = ThemeData.light(useMaterial3: false);
    return base.copyWith(
      primaryColor: ColorsManager.primaryColor,
      scaffoldBackgroundColor: ColorsManager.backgroundColor,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorsManager.primaryColor,
        primary: ColorsManager.primaryColor,
        secondary: ColorsManager.accentColor,
        surface: ColorsManager.backgroundColor,
        error: ColorsManager.errorColor,
      ),

      // AppBar — all screens inherit this, no need to repeat inline
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Cards
      cardTheme: CardTheme(
        color: ColorsManager.surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorsManager.backgroundColor,
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14.sp,
          color: ColorsManager.textHintColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorsManager.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorsManager.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColorsManager.primaryColor, width: 1.5),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: ColorsManager.dividerColor,
        thickness: 1,
        space: 1,
      ),

      // Font family app-wide
      textTheme: base.textTheme.apply(fontFamily: 'Cairo'),
    );
  }();
}
