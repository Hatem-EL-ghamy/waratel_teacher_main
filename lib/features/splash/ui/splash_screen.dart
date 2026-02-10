import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theming/colors.dart';
import 'widgets/splash_animated_logo.dart';
import 'widgets/splash_animated_text.dart';
import '../../../core/routing/routers.dart';
import 'widgets/splash_loading_indicator.dart';
import 'widgets/splash_decorative_circles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// شاشة البداية مع أنيميشن احترافي
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotationAnimation;

  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo Animation Controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Text Animation Controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Shimmer Animation Controller
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Logo Animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Text Animations
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Start logo animation
    await _logoController.forward();

    // Start text animation after a short delay
    await Future.delayed(const Duration(milliseconds: 300));
    await _textController.forward();

    // Wait before navigating (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // Navigate to login screen
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundColor,
        child: Stack(
          children: [
            // Decorative circles
            const SplashDecorativeCircles(),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: SplashAnimatedLogo(
                      scaleAnimation: _logoScaleAnimation,
                      fadeAnimation: _logoFadeAnimation,
                      rotationAnimation: _logoRotationAnimation,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // App name with animations
                  SplashAnimatedText(
                    fadeAnimation: _textFadeAnimation,
                    slideAnimation: _textSlideAnimation,
                  ),

                  SizedBox(height: 40.h),

                  // Loading indicator
                  SplashLoadingIndicator(
                    fadeAnimation: _textFadeAnimation,
                  ),

                  // Spacer to push content up
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
