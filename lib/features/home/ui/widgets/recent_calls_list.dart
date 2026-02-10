import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/home_cubit.dart';
import '../../logic/cubit/home_state.dart';
class RecentCallsList extends StatelessWidget {
  const RecentCallsList({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => current is HomeRecentCallsUpdated,
      builder: (context, state) {
        final users = context.read<HomeCubit>().recentCalls;

        return SizedBox(
          height: 120.h, // Height for avatar + text
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            separatorBuilder: (ctx, i) => SizedBox(width: 15.w),
            itemBuilder: (context, index) {
              final user = users[index];
              return Column(
                children: [
                  Container(
                    width: 65.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorsManager.secondaryColor, width: 2.w),
                      color: Colors.grey.shade200
                    ),
                    child: Center(
                      child: (user['initial'] != null && user['initial']!.isNotEmpty)
                          ? Text(user['initial']!, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.grey))
                          : Icon(Icons.person, size: 40.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 70.w,
                    child: Text(
                      user['name']!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: ColorsManager.textPrimaryColor),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
