import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/colors.dart';
import 'notification_icon_button.dart';

class CustomAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CustomAppHeader({
    super.key,
    this.title = 'ورتّل',
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorsManager.primaryColor,
            ColorsManager.primaryColor.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Menu/Drawer
          InkWell(
            onTap: () {
              if (showBackButton) {
                Navigator.pop(context);
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                showBackButton ? Icons.arrow_back : Icons.menu,
                color: Colors.white,
                size: 26.sp,
              ),
            ),
          ),

          // Center: Title
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Right: Notification Bell
          NotificationIconButton(
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
            notificationCount: 5, // Example count due to mocked data
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
