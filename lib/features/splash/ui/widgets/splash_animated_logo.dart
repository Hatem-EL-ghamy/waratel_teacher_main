import 'package:flutter/material.dart';
import '../../../../core/helpers/assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/theming/colors.dart';

/// لوجو التطبيق مع الأنيميشن في شاشة Splash
class SplashAnimatedLogo extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final Animation<double> rotationAnimation;

  const SplashAnimatedLogo({
    super.key,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: Transform.rotate(
            angle: rotationAnimation.value,
            child: Opacity(
              opacity: fadeAnimation.value,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppAssets.appLogo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
