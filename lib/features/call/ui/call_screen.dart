import 'package:camera/camera.dart';
import 'widgets/floating_mushaf.dart';
import 'widgets/session_report_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/features/call/logic/cubit/call_state.dart';
import 'package:waratel_app/features/call/logic/cubit/call_cubit.dart';




class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CallCubit>()..startCall(),
      child: BlocBuilder<CallCubit, CallState>(
        builder: (context, state) {
          final cubit = context.read<CallCubit>();
          
          bool isMicOn = cubit.isMicOn;
          bool isCamOn = cubit.isCamOn;
          bool isMushafOpen = cubit.isMushafOpen;
          String timerText = "00:00";

          if (state is CallTogglesUpdated) {
            isMicOn = state.isMicOn;
            isCamOn = state.isCamOn;
            isMushafOpen = state.isMushafOpen;
          } else if (state is CallTimerUpdated) {
             timerText = state.duration;
          }

          // To ensure timer updates don't reset toggles locally if logic isn't perfect,
          // we rely on cubit state variables which are updated.
          // Better approach: State should hold all values.
          // Refactoring to access Cubit variables directly for simplicity in this BlocBuilder pattern
          // or ideally the state should carry all data.
          // For now, let's use the cubit properties which are updated.
          
          return Scaffold(
            body: Stack(
              children: [
                // 1. Video Background (Camera Preview or Icon)
                Positioned.fill(
                  child: Container(
                    color: Colors.black,
                    child: (isCamOn && cubit.cameraController != null && cubit.cameraController!.value.isInitialized)
                      ? CameraPreview(cubit.cameraController!)
                      : const SizedBox.shrink(),
                  ),
                ),

                // 2. Call Controls (Top)
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  right: 20.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Minimize/Back
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ),
                      ),
                      // Timer
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: BlocBuilder<CallCubit, CallState>(
                          buildWhen: (previous, current) => current is CallTimerUpdated,
                          builder: (context, state) {
                            if (state is CallTimerUpdated) {
                               return Text(state.duration, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                            }
                            return Text("00:00", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                          },
                        ),
                      ),
                      // Settings
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: Icon(Icons.settings, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // 2. Student Info (Center of screen - like normal calls)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            color: ColorsManager.secondaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3.w),
                          ),
                          child: Icon(Icons.person, color: Colors.white, size: 50.sp),
                        ),
                        SizedBox(height: 16.h),
                        // Name
                        Text(
                          'أحمد علي حسن',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.sp,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4)
                            ]
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Track
                        Text(
                          'مسار التحفيظ المكثف',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 4)
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. Call Controls (Top)
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30.r)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mic
                        _buildControlBtn(
                          icon: isMicOn ? Icons.mic : Icons.mic_off,
                          isActive: isMicOn,
                          onTap: () => cubit.toggleMic(),
                        ),
                        // Cam
                        _buildControlBtn(
                          icon: isCamOn ? Icons.videocam : Icons.videocam_off,
                          isActive: isCamOn,
                          onTap: () => cubit.toggleCam(),
                        ),
                        // Mushaf
                        _buildControlBtn(
                          icon: Icons.menu_book,
                          isActive: isMushafOpen,
                          activeColor: ColorsManager.primaryColor,
                          onTap: () => cubit.toggleMushaf(),
                        ),
                        // End Call
                        InkWell(
                          onTap: () {
                             showDialog(
                               context: context,
                               builder: (context) => const SessionReportDialog(
                                 studentName: 'أحمد علي حسن', // In real app, pass from cubit/args
                                 trackName: 'مسار التحفيظ المكثف',
                               ),
                             );
                          },
                          child: CircleAvatar(
                            radius: 28.r,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.call_end, color: Colors.white, size: 28.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. Floating Mushaf Overlay
                if (isMushafOpen)
                   FloatingMushaf(onClose: () => cubit.toggleMushaf()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlBtn({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color activeColor = Colors.white,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: isActive ? Colors.white : Colors.white24,
            child: Icon(icon, color: isActive ? (activeColor == Colors.white ? Colors.black : activeColor) : Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }
}
