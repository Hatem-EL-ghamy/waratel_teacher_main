import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsManager.primaryColor, // Use Theme
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
              color: Colors.white,
              child: Row(
                children: [
                   CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.person, size: 40.sp, color: Colors.grey),
                    // backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder
                  ),
                   SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'حاتم ناصر اسماعيل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: ColorsManager.textPrimaryColor,
                          ),
                        ),
                        Text(
                          '0.00 دولار امريكي',
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
            ),
            
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                children: [
                   _buildDrawerItem(
                     icon: Icons.emoji_events,
                     text: 'خطة الإنجاز',
                     onTap: () {
                       Navigator.pop(context); // Close drawer
                       Navigator.pushNamed(context, '/achievementPlan'); // Using string literal or Routes.achievementPlan if imported
                     },
                   ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    text: 'عن مدكر',
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
                  _buildDrawerItem(
                    icon: Icons.logout,
                    text: 'تسجيل الخروج',
                    onTap: () {},
                  ),
                ],
              ),
            )
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
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
    );
  }
}
