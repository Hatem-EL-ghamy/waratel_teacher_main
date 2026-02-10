import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../logic/cubit/achievement_plan_cubit.dart';
import '../logic/cubit/achievement_plan_state.dart';
import '../../../../core/di/dependency_injection.dart';

class AchievementPlanScreen extends StatelessWidget {
  const AchievementPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AchievementPlanCubit>(),
      child: BlocBuilder<AchievementPlanCubit, AchievementPlanState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorsManager.backgroundColor,
            appBar: AppBar(
              title: const Text('خطة الإنجاز'),
              backgroundColor: ColorsManager.primaryColor,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'تفضيلات المسار التعليمي',
                    percentage: '0%',
                    children: [
                      _buildPreferenceItem('تلقين', '10%'),
                      _buildPreferenceItem('تلاوة', '20%'),
                      _buildPreferenceItem('تسميع', '40%'),
                      _buildPreferenceItem('إقراء وإجازة', '30%', isWide: true),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildSection(
                    title: 'تفضيلات الفئة العمرية',
                    percentage: '0%',
                    children: [
                      _buildPreferenceItem('5-12', '20%'),
                      _buildPreferenceItem('13-59', '60%'),
                      _buildPreferenceItem('+60', '20%'),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildSection(
                    title: 'تفضيلات مستويات الطالب',
                    percentage: '0%',
                    children: [
                      _buildPreferenceItem('مبتدئ', '30%'),
                      _buildPreferenceItem('متوسط', '50%'),
                      _buildPreferenceItem('متقدم', '20%'),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'ساعات الانجاز المتوقعة للاسبوع القادم',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    decoration: InputDecoration(
                        hintText: '20',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.grey),
                        )
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.grey,
                        elevation: 0,
                      ),
                      child: Text('حفظ تفضيلاتي', style: TextStyle(fontSize: 16.sp)),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  const Center(
                    child: Text(
                      'تعديل تفضيلاتك بعد 3 ايام',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required String percentage, required List<Widget> children}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Icon(Icons.info_outline, color: ColorsManager.secondaryColor, size: 24.sp), onPressed: (){}),
            Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            Text(percentage, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          alignment: WrapAlignment.end,
          children: children.reversed.toList(), // RTL layout visually
        )
      ],
    );
  }

  Widget _buildPreferenceItem(String label, String value, {bool isWide = false}) {
    // This replicates the teal box with +/- buttons and checkbox
    return Container(
      width: isWide ? double.infinity : 100.w, // Approximate width
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor, // Use Theme
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 16.sp),
              Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)),
              SizedBox(width: 4.w), // Spacer
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.remove_circle_outline, size: 16.sp, color: ColorsManager.secondaryColor),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.add_circle_outline, size: 16.sp, color: ColorsManager.secondaryColor),
              ],
            ),
          )
        ],
      ),
    );
  }
}
