import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/routing/routers.dart';
import '../../../../core/helpers/assets.dart';
import '../../logic/cubit/login_cubit.dart';
import '../../logic/cubit/login_state.dart';
import '../../../../core/di/dependency_injection.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, Routes.home);
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  style: TextStyle(fontSize: 14.sp),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 40.h),

                      // Logo
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            AppAssets.appLogo,
                            height: 100.h,
                            width: 100.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Subtitle
                      Text(
                        'قم بتسجيل الدخول',
                        textAlign: TextAlign.center,
                        style: TextStyles.font16RegularTextPrimary.copyWith(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),

                      SizedBox(height: 60.h),

                      // Email Field
                      _buildTextField(
                        label: 'البريد الإلكتروني',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        controller: cubit.emailController,
                      ),

                      SizedBox(height: 24.h),

                      // Password Field
                      _buildTextField(
                        label: 'كلمة المرور',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isObscure: cubit.isPasswordObscure,
                        controller: cubit.passwordController,
                        suffixIcon: cubit.suffixIcon,
                        onVisibilityToggle: () {
                          cubit.changePasswordVisibility();
                        },
                      ),

                      SizedBox(height: 40.h),

                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          if (state is! LoginLoading) {
                            cubit.login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                        child: state is LoginLoading 
                          ? SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'تسجيل الدخول',
                              style: TextStyles.font16SemiBoldWhite.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool? isObscure,
    VoidCallback? onVisibilityToggle,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    IconData? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure ?? false,
        keyboardType: keyboardType,
        style: TextStyles.font16RegularTextPrimary,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyles.font14RegularTextSecondary,
          prefixIcon: Icon(
            icon,
            color: AppColors.secondaryColor,
            size: 22.sp,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    suffixIcon ?? Icons.visibility_off,
                    color: AppColors.secondaryColor,
                    size: 22.sp,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
