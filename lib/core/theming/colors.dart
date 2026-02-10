import 'package:flutter/material.dart';

class ColorsManager {
  // الألوان الأساسية (Primary Colors)
  static const Color primaryColor = Color(0xFF1B9C85); // أخضر زمردي
  static const Color secondaryColor = Color(0xFF4C4C6D); // لون ثانوي - أزرق/رمادي داكن
  static const Color accentColor = Color(0xFFFFB74D); // لون التمييز - برتقالي/ذهبي دافئ

  // ألوان التصميم المحددة
  static const Color darkGreen = Color(0xFF064E3B); // للكروت الداكنة
  static const Color lightMint = Color(0xFFE0F2F1); // للخلفيات الفاتحة
  static const Color lightYellow = Color(0xFFFFF9C4); // للكروت المباشرة
  static const Color lightBlue = Color(0xFFE3F2FD); // للكروت التتبعية
  static const Color lightPink = Color(0xFFFFEBEE); // للكروت التتبعية

  // ألوان النصوص
  static const Color textPrimaryColor = Color(0xFF1F222B); // نص أساسي
  static const Color textSecondaryColor = Color(0xFF9CA3AF); // نص ثانوي
  static const Color textHintColor = Color(0xFFD1D5DB); // نص تلميحي
  static const Color textOnPrimary = Colors.white; // نص على الألوان الأساسية

  // ألوان الحالات (Status Colors)
  static const Color successColor = Color(0xFF10B981); // نجاح
  static const Color errorColor = Color(0xFFEF4444); // خطأ
  static const Color warningColor = Color(0xFFF59E0B); // تحذير
  static const Color infoColor = Color(0xFF3B82F6); // معلومات

  // التدرجات (Gradients)
  static const Color greenLight = Color(0xFF4DB6AC);
  static const Color greenMedium = Color(0xFF1B9C85); // Primary
  static const Color greenDark = Color(0xFF137A68);
  static const Color greenExtraLight = Color(0xFFE0F7FA);

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, greenLight],
  );

  // الخلفيات
  static const Color ivory = Color(0xFFFFFFF0); // عاجي
  static const Color backgroundColor = ivory; // خلفية رئيسية - عاجي
  static const Color surfaceColor = Colors.white; // سطح - أبيض
  static const Color borderColor = Color(0xFFE5E7EB); // لون الحدود - رمادي فاتح جداً

  // ألوان الأيقونات
  static const Color iconPrimary = primaryColor;
  static const Color iconSecondary = textSecondaryColor;
  static const Color iconOnPrimary = Colors.white;

  // ألوان إضافية
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color shadowColor = Colors.transparent;

  static var veryLightGrey; // تم إزالة الظلال
}

// Backwards-compatible alias used across the app
class AppColors {
  static const Color primaryColor = ColorsManager.primaryColor;
  static const Color secondaryColor = ColorsManager.secondaryColor;
  static const Color accentColor = ColorsManager.accentColor;

  static const Color darkGreen = ColorsManager.darkGreen;
  static const Color lightMint = ColorsManager.lightMint;
  static const Color lightYellow = ColorsManager.lightYellow;
  static const Color lightBlue = ColorsManager.lightBlue;
  static const Color lightPink = ColorsManager.lightPink;

  static const Color textPrimaryColor = ColorsManager.textPrimaryColor;
  static const Color textSecondaryColor = ColorsManager.textSecondaryColor;
  static const Color textHintColor = ColorsManager.textHintColor;
  static const Color textOnPrimary = ColorsManager.textOnPrimary;

  static const Color successColor = ColorsManager.successColor;
  static const Color errorColor = ColorsManager.errorColor;
  static const Color warningColor = ColorsManager.warningColor;
  static const Color infoColor = ColorsManager.infoColor;

  static const Color greenLight = ColorsManager.greenLight;
  static const Color greenMedium = ColorsManager.greenMedium;
  static const Color greenDark = ColorsManager.greenDark;
  static const Color greenExtraLight = ColorsManager.greenExtraLight;
  
  static const Gradient primaryGradient = ColorsManager.primaryGradient;

  static const Color backgroundColor = ColorsManager.backgroundColor;
  static const Color surfaceColor = ColorsManager.surfaceColor;
  static const Color borderColor = ColorsManager.borderColor;

  static const Color iconPrimary = ColorsManager.iconPrimary;
  static const Color iconSecondary = ColorsManager.iconSecondary;
  static const Color iconOnPrimary = ColorsManager.iconOnPrimary;

  static const Color dividerColor = ColorsManager.dividerColor;
  static const Color shadowColor = ColorsManager.shadowColor;
}
