import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/notification_icon_button.dart'; 

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      color: ColorsManager.primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               // Menu (Right in RTL)
               IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
               SizedBox(width: 8.w),
               // Avatar (Next to Menu)
               InkWell(
                 onTap: (){
                   Navigator.pushNamed(context, '/profile');
                 },
                 child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: ColorsManager.secondaryColor,
                  child: const Icon(Icons.person, color: Colors.white),
              ),
               ),
              SizedBox(width: 10.w),
               // Greeting (Text)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to right in RTL
                  children: [
                    Text(
                      '! أهلا بك',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    ),
                     Text(
                      'حاتم ناصر اسماعيل',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
                // Notification (Left in RTL)
                NotificationIconButton(
                  onTap: () {
                    // Navigate to notifications
                  },
                  notificationCount: 5,
                ),

            ],
          ),
        ],
      ),
    );
  }
}
