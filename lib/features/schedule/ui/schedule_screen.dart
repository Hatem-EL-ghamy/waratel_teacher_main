import 'package:flutter/material.dart';
import '../logic/cubit/schedule_cubit.dart';
import '../logic/cubit/schedule_state.dart';
import '../../schedule/data/models/schedule_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/info_card.dart';
import 'package:waratel_app/core/theming/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/custom_app_header.dart';
import '../../../../core/widgets/empty_state_display.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScheduleCubit>()..loadSchedule(),
      child: BlocConsumer<ScheduleCubit, ScheduleState>(
        listener: (context, state) {
          if (state is DeleteSlotSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is DeleteSlotError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is ScheduleLoading ||
            current is ScheduleLoaded ||
            current is ScheduleError ||
            current is DeleteSlotLoading,
        builder: (context, state) {
          return Column(children: [
            const CustomAppHeader(title: 'الجدول'),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
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

                    SizedBox(height: 20.h),

                    // State handling
                    if (state is ScheduleLoading || state is DeleteSlotLoading)
                      const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                    else if (state is ScheduleLoaded &&
                        state.calendar.isNotEmpty)
                      Expanded(
                        child: _buildCalendarList(context, state),
                      )
                    else if (state is ScheduleError)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline,
                                  size: 48.sp, color: Colors.red),
                              SizedBox(height: 10.h),
                              Text(state.error,
                                  style: TextStyle(fontSize: 14.sp)),
                              SizedBox(height: 10.h),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<ScheduleCubit>()
                                    .loadSchedule(),
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const EmptyStateDisplay(
                        icon: Icons.calendar_month_outlined,
                        message: 'لا توجد مواعيد مجدولة حتى الآن',
                        subMessage:
                            'الطلاب المنتظمون في الدراسة معك سيتمكنون من حجز عدد أكبر من الحصص',
                      ),

                    if (state is! ScheduleLoading &&
                        state is! DeleteSlotLoading) ...[
                      SizedBox(height: 10.h),
                      // Add Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.pushNamed(
                                context, '/addAppointment');
                            if (result == true && context.mounted) {
                              context.read<ScheduleCubit>().loadSchedule();
                            }
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
                      SizedBox(height: 10.h),
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

  Widget _buildCalendarList(BuildContext context, ScheduleLoaded state) {
    final sortedDates = state.calendar.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final slots = state.calendar[date]!;
        return _buildDayCard(context, date, slots);
      },
    );
  }

  Widget _buildDayCard(
      BuildContext context, String date, List<SlotModel> slots) {
    // Format date
    String formattedDate;
    try {
      final parsedDate = DateTime.parse(date);
      formattedDate = DateFormat('EEEE، d MMMM yyyy', 'ar').format(parsedDate);
    } catch (_) {
      formattedDate = date;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Date Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                // Delete all slots for this day
                GestureDetector(
                  onTap: () => _confirmDeleteAll(context, date),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_sweep,
                            size: 16.sp, color: Colors.red),
                        SizedBox(width: 4.w),
                        Text(
                          'حذف الكل',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Slots
          ...slots.map((slot) => _buildSlotTile(context, slot)),
        ],
      ),
    );
  }

  Widget _buildSlotTile(BuildContext context, SlotModel slot) {
    final startTime = _formatTime(slot.startTime);
    final endTime = _formatTime(slot.endTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // Time
          Icon(Icons.access_time,
              size: 18.sp, color: ColorsManager.primaryColor),
          SizedBox(width: 8.w),
          Text(
            '$startTime - $endTime',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Booked status
          if (slot.isBooked)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'محجوز',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => _confirmDeleteSlot(context, slot),
              child: Icon(
                Icons.delete_outline,
                size: 20.sp,
                color: Colors.red.shade300,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'م' : 'ص';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (_) {
      return time;
    }
  }

  void _confirmDeleteSlot(BuildContext context, SlotModel slot) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الموعد'),
        content: Text(
            'هل أنت متأكد من حذف الموعد ${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ScheduleCubit>().deleteSlot(slot.id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context, String date) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف جميع المواعيد'),
        content: const Text('هل أنت متأكد من حذف جميع مواعيد هذا اليوم؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ScheduleCubit>().deleteSlotsByDay(date);
            },
            child: const Text('حذف الكل',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required Color iconBgColor}) {
    return InfoCard(
      backgroundColor: const Color(0xFFFFF9E6),
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
