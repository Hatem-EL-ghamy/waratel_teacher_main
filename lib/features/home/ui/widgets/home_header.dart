import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:waratel_app/features/profile/logic/cubit/profile_state.dart';
import 'package:waratel_app/core/widgets/notification_icon_button.dart';
import 'package:waratel_app/features/localization/data/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // PERF: buildWhen ensures this header only rebuilds when profile data
    // actually changes — not on logout/error/other unrelated ProfileStates.
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) =>
          curr is ProfileLoaded || curr is ProfileLoading,
      builder: (context, state) {
        final name = state is ProfileLoaded
            ? (state.profileResponse.user?.name ?? 'teacher'.tr(context))
            : 'teacher'.tr(context);
        final photoPath = state is ProfileLoaded
            ? state.profileResponse.profile?.profilePhotoPath
            : null;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: const BoxDecoration(
            gradient: ColorsManager.headerGradient,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu icon (opens drawer)
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              SizedBox(width: 8.w),

              // Profile avatar
              InkWell(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                borderRadius: BorderRadius.circular(30.r),
                child: CircleAvatar(
                  radius: 21.r,
                  backgroundColor:
                      Colors.white.withValues(alpha: 0.25),
                  backgroundImage: photoPath != null
                      ? NetworkImage('https://wartil.com/storage/$photoPath')
                      : null,
                  child: photoPath == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
              ),
              SizedBox(width: 10.w),

              // Welcome text + name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'welcome'.tr(context),
                      style:
                          TextStyle(fontSize: 13.sp, color: Colors.white70),
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
                onTap: () =>
                    Navigator.pushNamed(context, '/notifications'),
                notificationCount: 5,
              ),
            ],
          ),
        );
      },
    );
  }
}
