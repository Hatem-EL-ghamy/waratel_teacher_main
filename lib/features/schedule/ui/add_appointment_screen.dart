import 'package:flutter/material.dart';
import '../logic/cubit/schedule_cubit.dart';
import '../logic/cubit/schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waratel_app/core/theming/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/info_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  final Set<int> selectedTimeSlotIndices = {};

  // Time slots: 30 min intervals from 04:00 to 23:30
  final List<Map<String, String>> allTimeSlots = _generateTimeSlots();

  static List<Map<String, String>> _generateTimeSlots() {
    final slots = <Map<String, String>>[];
    for (int hour = 4; hour < 24; hour++) {
      slots.add({
        'start': '${hour.toString().padLeft(2, '0')}:00',
        'end': '${hour.toString().padLeft(2, '0')}:30',
      });
      slots.add({
        'start': '${hour.toString().padLeft(2, '0')}:30',
        'end': '${(hour + 1).toString().padLeft(2, '0')}:00',
      });
    }
    return slots;
  }

  // Group slots by period for display
  List<Map<String, dynamic>> get periodGroups => [
        {'label': '04 ص - 08 ص', 'icon': Icons.wb_sunny, 'color': Colors.amber, 'startHour': 4, 'endHour': 8},
        {'label': '08 ص - 12 م', 'icon': Icons.wb_sunny, 'color': Colors.amber, 'startHour': 8, 'endHour': 12},
        {'label': '12 م - 04 م', 'icon': Icons.wb_sunny, 'color': Colors.orange, 'startHour': 12, 'endHour': 16},
        {'label': '04 م - 08 م', 'icon': Icons.cloud, 'color': Colors.blue, 'startHour': 16, 'endHour': 20},
        {'label': '08 م - 12 ص', 'icon': Icons.nightlight_round, 'color': ColorsManager.primaryColor, 'startHour': 20, 'endHour': 24},
      ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ScheduleCubit>(),
      child: BlocConsumer<ScheduleCubit, ScheduleState>(
        listener: (context, state) {
          if (state is AddSlotsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AddSlotsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: ColorsManager.primaryColor,
              title: Text(
                'إضافة المواعيد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Warning/Info Cards
                  InfoCard(
                    backgroundColor: const Color(0xFFFFF9E6),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                                'جدول المواعيد سارٍ لمدة شهرين وقابل للتعديل لاحقاً.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp))),
                        SizedBox(width: 8.w),
                        Icon(Icons.flash_on, color: Colors.amber, size: 24.sp),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  InfoCard(
                    backgroundColor: const Color(0xFFFFF9E6),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                                'أوقات الذروة في الأغلب من 4 الي 8 مساء.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp))),
                        SizedBox(width: 8.w),
                        Icon(Icons.flash_on, color: Colors.amber, size: 24.sp),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Date Picker
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(' : اختر التاريخ',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10.h),
                  _buildDateSelector(),
                  SizedBox(height: 25.h),

                  // Time Periods
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('اختر الفترات الزمنية',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'كل فترة 30 دقيقة — اضغط على الفترة لتوسيعها واختيار المواعيد',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 15.h),

                  // Expandable period groups
                  ...periodGroups.map((group) =>
                      _buildPeriodGroup(group)),

                  SizedBox(height: 20.h),

                  // Selected count
                  if (selectedTimeSlotIndices.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle,
                              color: ColorsManager.primaryColor, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'تم اختيار ${selectedTimeSlotIndices.length} موعد',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 20.h),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: state is AddSlotsLoading ||
                              selectedTimeSlotIndices.isEmpty
                          ? null
                          : () => _submitSlots(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r)),
                        elevation: 2,
                      ),
                      child: state is AddSlotsLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text('حفظ المواعيد',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    // For the UI display, we use 'ar' locale
    final dateStr = DateFormat('EEEE، d MMMM yyyy', 'ar').format(selectedDate);
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)), // Start from last year
          lastDate: DateTime(2036),
          locale: const Locale('ar'),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
            selectedTimeSlotIndices.clear();
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsManager.primaryColor),
          borderRadius: BorderRadius.circular(12.r),
          color: ColorsManager.primaryColor.withOpacity(0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.primaryColor,
              ),
            ),
            Icon(Icons.calendar_today,
                color: ColorsManager.primaryColor, size: 20.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodGroup(Map<String, dynamic> group) {
    final int startHour = group['startHour'];
    final int endHour = group['endHour'];

    // Get indices of slots in this period
    final periodSlotIndices = <int>[];
    for (int i = 0; i < allTimeSlots.length; i++) {
      final slotHour = int.parse(allTimeSlots[i]['start']!.split(':')[0]);
      if (slotHour >= startHour && slotHour < endHour) {
        periodSlotIndices.add(i);
      }
    }

    final selectedInPeriod =
        periodSlotIndices.where((i) => selectedTimeSlotIndices.contains(i));
    final allSelected = selectedInPeriod.length == periodSlotIndices.length;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
          title: Row(
            children: [
              Icon(group['icon'], color: group['color'], size: 24.sp),
              SizedBox(width: 10.w),
              Text(
                group['label'],
                style:
                    TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (selectedInPeriod.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '${selectedInPeriod.length}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          children: [
            // Select all toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (allSelected) {
                          selectedTimeSlotIndices
                              .removeAll(periodSlotIndices);
                        } else {
                          selectedTimeSlotIndices.addAll(periodSlotIndices);
                        }
                      });
                    },
                    icon: Icon(
                      allSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: ColorsManager.primaryColor,
                      size: 20.sp,
                    ),
                    label: Text(
                      allSelected ? 'إلغاء تحديد الكل' : 'تحديد الكل',
                      style: TextStyle(
                          fontSize: 12.sp, color: ColorsManager.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            // Individual slots
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: periodSlotIndices.map((idx) {
                  final slot = allTimeSlots[idx];
                  final isSelected = selectedTimeSlotIndices.contains(idx);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedTimeSlotIndices.remove(idx);
                        } else {
                          selectedTimeSlotIndices.add(idx);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorsManager.primaryColor
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSelected
                              ? ColorsManager.primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        '${_formatTimeDisplay(slot['start']!)} - ${_formatTimeDisplay(slot['end']!)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeDisplay(String time) {
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

  void _submitSlots(BuildContext context) {
    // We MUST use 'en' locale here to send Western digits (2027-01-01) to the API
    final dateStr = DateFormat('yyyy-MM-dd', 'en').format(selectedDate);

    // Build the slots array in the correct format the API expects:
    // { "date": "2025-01-01", "slots": [{"start_time": "09:00", "end_time": "09:30"}, ...] }
    final List<Map<String, String>> slotsPayload = selectedTimeSlotIndices
        .map((idx) => {
              'start_time': allTimeSlots[idx]['start']!,
              'end_time': allTimeSlots[idx]['end']!,
            })
        .toList();

    debugPrint('Submitting Slots: date=$dateStr slots=$slotsPayload');

    context.read<ScheduleCubit>().addSlots(
          date: dateStr,
          slots: slotsPayload,
        );
  }
}
