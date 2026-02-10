import 'widgets/session_card.dart';
import 'package:flutter/material.dart';
import '../logic/cubit/record_cubit.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/custom_app_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecordCubit>(),
      child: Column(
        children: [
            const CustomAppHeader(title: 'جلساتي'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'سجل الجلسات',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Subtitle
                    Text(
                      'عرض الجلسات السابقة المسجلة وتفاصيلها',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Sessions List
                    SessionCard(
                      studentName: 'بحر زكريا',
                      time: '20:48',
                      date: 'الاثنين - 1 سبتمبر',
                      status: 'تحفيظ جديد',
                      statusColor: Colors.blue,
                      reportCenter: 'مركز التقرير',
                    ),
                    SessionCard(
                      studentName: 'أنس محمود',
                      time: '17:09',
                      date: 'الأربعاء - 19 مارس',
                      status: 'تصحيح التلاوة',
                      statusColor: Colors.orange,
                      reportCenter: 'مركز التقرير',
                    ),
                    SessionCard(
                      studentName: 'محمد أحمد',
                      time: '15:30',
                      date: 'الجمعة - 25 فبراير',
                      status: 'تحفيظ جديد',
                      statusColor: Colors.blue,
                      reportCenter: 'مركز التقرير',
                    ),
                  ],
                ),
              ),
            ),
          ],
     ) 
    );
  }
}
