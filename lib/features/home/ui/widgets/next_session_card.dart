import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';

class NextSessionCard extends StatefulWidget {
  const NextSessionCard({super.key});

  @override
  State<NextSessionCard> createState() => _NextSessionCardState();
}

class _NextSessionCardState extends State<NextSessionCard> {
  // Mock data - In real app this would come from props/cubit
  final String teacherName = 'أحمد علي حسن';
  final String trackName = 'مسار التحفيظ المكثف';
  final String sessionTime = '12:30 م'; // Mock time
  final DateTime sessionDateTime = DateTime.now().add(const Duration(minutes: 12, seconds: 4)); // Mock time remaining

  late Timer _timer;
  Duration _timeLeft = const Duration(minutes: 12, seconds: 4);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds > 0) {
        setState(() {
          _timeLeft = _timeLeft - const Duration(seconds: 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row: Time and Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                sessionTime,
                style: TextStyle(
                  color: ColorsManager.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorsManager.greenLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Text(
                      '-${_formatDuration(_timeLeft)} دقيقة متبقية',
                      style: TextStyle(
                        color: ColorsManager.textPrimaryColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'الحلقة القادمة',
                      style: TextStyle(
                        color: ColorsManager.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Content Row: Button, Teacher Info, Avatar
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (Right in RTL)
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: ColorsManager.secondaryColor.withOpacity(0.1), // Safe background
                  borderRadius: BorderRadius.circular(12.r),
                ),
                 // Safe Icon Placeholder instead of missing image
                 child: Icon(Icons.person, color: ColorsManager.secondaryColor, size: 30.sp), 
              ),
              
              SizedBox(width: 12.w),

              // Teacher Info (Right next to Avatar)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to start (Right in RTL)
                  children: [
                    Text(
                      teacherName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: ColorsManager.textPrimaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4.h),
                     Text(
                      trackName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // Enter Button (Left in RTL)
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/call',
                      arguments: {
                        'token': 'mock_token',
                        'channelName': 'mock_channel',
                        'uid': 123,
                        'studentName': teacherName,
                      },
                    );
                  },
                child: Container(
                   width: 50.w,
                   height: 50.w,
                   decoration: BoxDecoration(
                     color: ColorsManager.primaryColor,
                     shape: BoxShape.circle,
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        // Using Icons.login which depicts entering
                        Transform.scale(
                          scaleX: -1, // Flip to match RTL entry (arrow pointing left)
                          child: Icon(Icons.login, color: Colors.white, size: 20.sp)
                        ),
                        Text('ادخل', style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w900))
                     ],
                   ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
