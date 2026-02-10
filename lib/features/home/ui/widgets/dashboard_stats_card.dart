import 'next_session_card.dart';
import 'package:flutter/material.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DashboardStatsCard extends StatefulWidget {
  const DashboardStatsCard({super.key});

  @override
  State<DashboardStatsCard> createState() => _DashboardStatsCardState();
}

class _DashboardStatsCardState extends State<DashboardStatsCard> {
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rating Bar & Toggle
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.r,
                  offset: Offset(0, 2.h),
                )
              ]),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                     children: [
                       Text(isAvailable ? 'متاح' : 'غير متاح',
                           style: TextStyle(
                            color: isAvailable ? ColorsManager.primaryColor : Colors.grey, 
                            fontSize: 12.sp, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                       SizedBox(width: 8.w),
                       Switch(
                           value: isAvailable,
                           activeColor: ColorsManager.primaryColor,
                           onChanged: (val) {
                             setState(() {
                               isAvailable = val;
                             });
                           }),
                     ],
                   ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('متوسط تقييماتك',
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
                   Row(
                    children: [
                      Icon(Icons.star, color: ColorsManager.accentColor, size: 18.sp),
                      Icon(Icons.star, color: ColorsManager.accentColor, size: 18.sp),
                      Icon(Icons.star, color: ColorsManager.accentColor, size: 18.sp),
                      Icon(Icons.star, color: ColorsManager.accentColor, size: 18.sp),
                      Icon(Icons.star_half,
                          color: ColorsManager.accentColor, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text('4.378', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        const NextSessionCard(),
      ],
    );
  }
}
