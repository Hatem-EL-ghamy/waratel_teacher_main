import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/core/theming/colors.dart';
import '../../../../core/widgets/info_card.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  int selectedDayIndex = 0; // Starts at index 0 (Sunday/الأحد)
  List<String> days = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
  List<String> dayNumbers = ['1', '2', '3', '4', '5', '6', '7'];

  // Mock data for time slots
  final List<Map<String, dynamic>> timeSlots = [
    {'time': '04 ص - 08 ص', 'icon': Icons.wb_sunny, 'color': Colors.amber},
    {'time': '08 ص - 12 م', 'icon': Icons.wb_sunny, 'color': Colors.amber},
    {'time': '12 م - 04 م', 'icon': Icons.wb_sunny, 'color': Colors.amber},
    {'time': '04 م - 08 م', 'icon': Icons.cloud, 'color': Colors.blue},
    {'time': '08 م - 12 ص', 'icon': Icons.nightlight_round, 'color': ColorsManager.primaryColor}, // Moon-ish
    {'time': '12 ص - 04 ص', 'icon': Icons.nightlight_round, 'color': ColorsManager.primaryColor},
  ];

  @override
  Widget build(BuildContext context) {
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
                      child: Text('جدول المواعيد سارٍ لمدة شهرين وقابل للتعديل لاحقاً.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp))),
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
                      child: Text('أوقات الذروة في الأغلب من 4 الي 8 مساء.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp))),
                   SizedBox(width: 8.w),
                  Icon(Icons.flash_on, color: Colors.amber, size: 24.sp),
                ],
              ),
            ),
            SizedBox(height: 25.h),

            // Days Selection
            Align(
              alignment: Alignment.centerRight,
              child: Text(' : إختر الأيام التي تريد تقديم الدروس بها',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SizedBox(
                height: 80.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  reverse: true, // Arabic RTL order usually implies right-to-left list
                  itemCount: days.length,
                  separatorBuilder: (c, i) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    bool isSelected = selectedDayIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(days[index], style: TextStyle(fontSize: 12.sp, color: ColorsManager.textPrimaryColor)),
                          SizedBox(height: 8.h),
                          Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? ColorsManager.primaryColor : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                dayNumbers[index],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 25.h),
             Align(
              alignment: Alignment.centerRight,
              child: Text('اختر الفترة الزمنية التي تريدها للجلسات',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 15.h),

            // Time Slots Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(timeSlots[index]['icon'], color: timeSlots[index]['color'], size: 28.sp),
                       SizedBox(height: 10.h),
                       Text(
                         timeSlots[index]['time'],
                         textAlign: TextAlign.center,
                         style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                       )
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: 40.h),
            
            // Next Button
            SizedBox(
              width: 160.w,
              height: 45.h,
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text('اليوم التالي', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
             SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
