import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_app_header.dart';
import '../../../../core/di/dependency_injection.dart';
import '../logic/cubit/ratings_cubit.dart';
import 'widgets/quran_circle_card.dart';

class RatingsScreen extends StatelessWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RatingsCubit>(),
      child: Column(
          children: [
            const CustomAppHeader(title: 'المقرأة'),
            Expanded(
              child: Container(
                width: double.infinity,
                color: ColorsManager.backgroundColor,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Header with title and add button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المقرأة الجماعية',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.textPrimaryColor,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add, size: 18.sp),
                          label: Text('إضافة مقرأة', style: TextStyle(fontSize: 14.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Quran circles list
                    Expanded(
                      child: ListView(
                        children: [
                          QuranCircleCard(
                            title: 'مقرأة الفجر - حفظ البقرة',
                            status: 'تحفيظ جديد',
                            studentCount: 12,
                            locationCount: 45,
                            isActive: true,
                            progress: 0.65,
                            studentAvatars: ['1', '2', '3'],
                          ),
                          QuranCircleCard(
                            title: 'مقرأة العصر - مراجعة الأحزاب',
                            status: 'مراجعة',
                            studentCount: 8,
                            locationCount: 30,
                            isActive: true,
                            progress: 0.45,
                            studentAvatars: ['1', '2'],
                          ),
                          QuranCircleCard(
                            title: 'مقرأة المغرب - تلاوة',
                            status: 'تلاوة',
                            studentCount: 15,
                            locationCount: 60,
                            isActive: false,
                            progress: 0.80,
                            studentAvatars: ['1', '2', '3', '4'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        );
  }
}
