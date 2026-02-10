import 'package:flutter/material.dart';
import '../logic/cubit/schedule_cubit.dart';
import '../logic/cubit/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/info_card.dart';
import 'package:waratel_app/core/theming/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/custom_app_header.dart';
import '../../../../core/widgets/empty_state_display.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScheduleCubit>()..loadSchedule(),
      child: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          return Column(children: [
                const CustomAppHeader(title: 'الجدول'),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // Header curve is handled by CustomPageHeader, just need bg white here potentially
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Column(
                      children: [
                        // Warning Cards
                        _buildWarningCard(
                          icon: Icons.calendar_today,
                          title: 'إلغاء الجلسة قبل الموعد',
                          subtitle:
                              'تقدر تلغي أي جلسة قبل 12 ساعة من موعد الجلسة',
                          iconBgColor: Colors.amber,
                        ),
                        SizedBox(height: 16.h),
                        _buildWarningCard(
                          icon: Icons.person,
                          title: 'عدم حضور الطالب للجلسة',
                          subtitle:
                              'سيتم إضافة 30% من الدقائق المحجوزة إلى رصيدك',
                          iconBgColor: Colors.amber,
                        ),

                        SizedBox(height: 50.h),
                        // State handling
                        if (state is ScheduleLoading)
                          const Expanded(
                              child: Center(child: CircularProgressIndicator()))
                        else if (state is ScheduleLoaded &&
                            state.appointments.isNotEmpty)
                          Expanded(
                              child: ListView.builder(
                            itemCount: state.appointments.length,
                            itemBuilder: (context, index) => ListTile(
                                title: Text(state.appointments[index])),
                          ))
                        else
                          const EmptyStateDisplay(
                            icon: Icons.calendar_month_outlined,
                            message: 'لا توجد مواعيد مجدولة حتى الآن',
                            subMessage:
                                'الطلاب المنتظمون في الدراسة معك سيتمكنون من حجز عدد أكبر من الحصص',
                          ),

                        if (state is! ScheduleLoading) ...[
                          const Spacer(),
                          // Add Button
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/addAppointment');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: ColorsManager.primaryColor,
                                side: const BorderSide(
                                    color: ColorsManager.primaryColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.r)),
                                elevation: 0,
                              ),
                              child: Text(
                                'إضافة مواعيد الآن',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ]
                      ],
                    ),
                  ),
                ),
              ]);
        },
      ),
    );
  }

  Widget _buildWarningCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color iconBgColor}) {
    return InfoCard(
      backgroundColor: const Color(0xFFFFF9E6), // Light yellow bg
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14.sp)),
                SizedBox(height: 5.h),
                Text(subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          CircleAvatar(
            backgroundColor: iconBgColor,
            radius: 20.r,
            child: Icon(icon, color: Colors.white, size: 20.sp),
          )
        ],
      ),
    );
  }
}
