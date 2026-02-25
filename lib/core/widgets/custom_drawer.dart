import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../../features/profile/logic/cubit/profile_state.dart';
import '../../features/profile/data/models/profile_models.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // نقرأ من ProfileCubit المُزوَّد في HomeLayout — لا نُنشئ instance جديدة
    return Drawer(
      backgroundColor: ColorsManager.primaryColor,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header — اسم المعلم وصورته من الـ API ──────────────────
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                ProfileUser? user;
                String? photoPath;
                String salary = '0.00';
                if (state is ProfileLoaded) {
                  user = state.profileResponse.user;
                  photoPath = state.profileResponse.profile?.profilePhotoPath;
                  salary = state.profileResponse.profile?.salary ?? '0.00';
                }
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20.h, horizontal: 16.w),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: photoPath != null
                            ? NetworkImage(
                                'https://wartil.com/storage/$photoPath')
                            : null,
                        child: photoPath == null
                            ? Icon(Icons.person,
                                size: 38.sp, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'المعلم',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: ColorsManager.textPrimaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '$salary دولار امريكي',
                              style: TextStyle(
                                color: ColorsManager.secondaryColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── Menu Items ──────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                children: [
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    text: 'الملف الشخصي',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.emoji_events,
                    text: 'خطة الإنجاز',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/achievementPlan');
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    text: 'عن ورتل',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.headset_mic,
                    text: 'تواصل معنا',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.description,
                    text: 'الشروط و الاحكام',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    text: 'تغيير اللغة',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.menu_book,
                    text: 'القرآن الكريم',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart,
                    text: 'الإحصائيات',
                    onTap: () {},
                  ),

                  // ── تسجيل الخروج ──────────────────────────────────────
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      final isLoading = state is LogoutLoading;
                      return ListTile(
                        leading: isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.logout,
                                color: Colors.white, size: 28.sp),
                        title: Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: isLoading
                            ? null
                            : () =>
                                context.read<ProfileCubit>().logout(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 4.h),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28.sp),
      title: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
    );
  }
}
