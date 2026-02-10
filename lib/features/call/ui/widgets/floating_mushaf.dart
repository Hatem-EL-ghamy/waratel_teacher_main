import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';

class FloatingMushaf extends StatefulWidget {
  final VoidCallback onClose;
  const FloatingMushaf({super.key, required this.onClose});

  @override
  State<FloatingMushaf> createState() => _FloatingMushafState();
}

class _FloatingMushafState extends State<FloatingMushaf> {
  // Mock Mushaf Image or Content
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100.h,
      left: 20.w,
      right: 20.w,
      bottom: 100.h,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorsManager.primaryColor, width: 2.w),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ColorsManager.primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المصحف الشريف',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp
                      ),
                    ),
                    InkWell(
                      onTap: widget.onClose,
                      child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                    )
                  ],
                ),
              ),
              // Content (Mock Image for now)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 50.sp, color: ColorsManager.greenLight),
                      SizedBox(height: 10.h),
                      Text(
                        'صفحة المصحف تظهر هنا',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
