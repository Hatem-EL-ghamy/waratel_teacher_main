import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../logic/cubit/profile_cubit.dart';
import '../../../../core/di/dependency_injection.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: ColorsManager.backgroundColor,
          body: Column(
            children: [
              // Header Section
              _buildHeader(),
              
              // Tab Bar Section
              Container(
                color: Colors.white,
                child: TabBar(
                  labelColor: ColorsManager.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: ColorsManager.primaryColor,
                  indicatorWeight: 3.h,
                  labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'التقييمات'),
                    Tab(text: 'المعلومات'),
                    Tab(text: 'الخبرة'),
                  ],
                ),
              ),
              
              Expanded(
                child: TabBarView(
                  children: [
                    _buildRatingsTab(),
                    _buildInfoTab(),
                    _buildExperienceTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 50.h, bottom: 25.h),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3.w)),
            child: CircleAvatar(
              radius: 45.r,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(Icons.person, size: 55.sp, color: Colors.white),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'حاتم ناصر اسماعيل',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => 
              Icon(Icons.star, color: ColorsManager.accentColor, size: 20.sp)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRatingsTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionTitle('ملخص التقييمات'),
        SizedBox(height: 15.h),
        _buildRatingRow('تقييم الطلاب', 4.4),
        SizedBox(height: 12.h),
        _buildRatingRow('تقييم المقيمين', 4.4),
        SizedBox(height: 12.h),
        _buildRatingRow('التقييم الآلي', 0.0),
        SizedBox(height: 30.h),
        _buildSectionTitle('التعليقات والملاحظات'),
        SizedBox(height: 15.h),
        _buildCommentCard(
          name: 'بحر زكريا',
          comment: 'مميز جداً والله، بارك الله في علمه ووقت الشيخ حاتم. أسلوب متميز في التحفيظ والتلقين.',
          date: '15/05/2024 07:06 م',
        ),
      ],
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionTitle('البيانات الشخصية'),
        _buildInfoCard([
          _buildInfoRow(Icons.person_outline, 'الاسم الثلاثي', 'حاتم ناصر اسماعيل'),
          _buildInfoRow(Icons.wc, 'الجنس', 'ذكر'),
          _buildInfoRow(Icons.email_outlined, 'البريد الإلكتروني', 'hatem@example.com'),
          _buildInfoRow(Icons.phone_android, 'رقم الواتساب', '+20 1234567890'),
        ]),
        SizedBox(height: 20.h),
        _buildSectionTitle('الموقع والسكن'),
        _buildInfoCard([
          _buildInfoRow(Icons.public, 'بلد الأصل', 'مصر'),
          _buildInfoRow(Icons.location_on_outlined, 'مكان الإقامة', 'السعودية - الرياض'),
        ]),
        SizedBox(height: 20.h),
        _buildSectionTitle('الخلفية العلمية'),
        _buildInfoCard([
          _buildInfoRow(Icons.school_outlined, 'المؤهل العلمي', 'بكالوريوس أصول دين - جامعة الأزهر'),
        ]),
      ],
    );
  }

  Widget _buildExperienceTab() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSectionTitle('المسارات التدريسية'),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildChip('حفظ وتلقين'),
            _buildChip('تصحيح تلاوة'),
            _buildChip('إقراء وإجازة'),
            _buildChip('تأسيس قراءة وكتابة'),
          ],
        ),
        SizedBox(height: 25.h),
        _buildSectionTitle('اللغات التي أجيدها'),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildChip('اللغة العربية', isAccent: true),
            _buildChip('اللغة الإنجليزية'),
          ],
        ),
        SizedBox(height: 25.h),
        _buildSectionTitle('الخبرة والقدرات'),
        _buildInfoCard([
          _buildInfoRow(Icons.history, 'سنوات الخبرة', '8 سنوات'),
          _buildInfoRow(Icons.access_time, 'ساعات العمل المتوقعة', '6 ساعات يومياً'),
          _buildInfoRow(Icons.laptop_chromebook, 'التعليم عن بعد', 'متقدم'),
          _buildInfoRow(Icons.speed, 'جودة الإنترنت', 'ممتازة'),
          _buildInfoRow(Icons.settings_suggest, 'المهارات التقنية', 'احترافي'),
        ]),
        SizedBox(height: 25.h),
        _buildSectionTitle('المرفقات والشهادات'),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorsManager.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf, color: Colors.red, size: 30.sp),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('السيرة الذاتية وشهادات الإجازة', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp)),
                      Text('ملف PDF واحد (حد أقصى 10MB)', 
                        style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                    ],
                  ),
                ),
                Icon(Icons.download, color: ColorsManager.primaryColor),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: ColorsManager.primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(icon, color: ColorsManager.primaryColor, size: 22.sp),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isAccent = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isAccent ? ColorsManager.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: ColorsManager.primaryColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isAccent ? Colors.white : ColorsManager.primaryColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRatingRow(String label, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        Row(
          children: [
            Text(rating.toString(), style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            SizedBox(width: 10.w),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < rating.floor()
                      ? ColorsManager.accentColor
                      : Colors.grey.shade300,
                  size: 20.sp,
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentCard({required String name, required String comment, required String date}) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: ColorsManager.primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, color: ColorsManager.primaryColor),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  Text(date, style: TextStyle(color: Colors.grey, fontSize: 11.sp)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(comment, style: TextStyle(fontSize: 13.sp, height: 1.5)),
        ],
      ),
    );
  }
}
