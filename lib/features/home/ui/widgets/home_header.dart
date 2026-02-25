import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/notification_icon_button.dart';
import '../../../profile/logic/cubit/profile_cubit.dart';
import '../../../profile/logic/cubit/profile_state.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        String name = 'المعلم';
        String? photoPath;
        if (state is ProfileLoaded) {
          name = state.profileResponse.user?.name ?? 'المعلم';
          photoPath = state.profileResponse.profile?.profilePhotoPath;
        }
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
                  // Profile avatar — صورة حقيقية من الـ API
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: ColorsManager.secondaryColor,
                      backgroundImage: photoPath != null
                          ? NetworkImage(
                              'https://wartil.com/storage/$photoPath')
                          : null,
                      child: photoPath == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Greeting + Name from API
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '! أهلا بك',
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white70),
                        ),
                        Text(
                          name,
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
                  // Notification icon
                  NotificationIconButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                    notificationCount: 5,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
