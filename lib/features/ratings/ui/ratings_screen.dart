import 'package:flutter/material.dart';
import '../logic/cubit/ratings_cubit.dart';
import '../logic/cubit/ratings_state.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/custom_app_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/models/session_model.dart';
import 'maqraa_room_screen.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RatingsCubit>()..checkStatus(),
      child: BlocConsumer<RatingsCubit, RatingsState>(
        listener: (context, state) {
          if (state is RatingsSessionStarted && !_isNavigating) {
            _isNavigating = true;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<RatingsCubit>(),
                  child: MaqraaRoomScreen(
                    session: state.session,
                    agoraData: state.agoraData,
                  ),
                ),
              ),
            ).then((_) {
              _isNavigating = false;
              if (context.mounted) {
                context.read<RatingsCubit>().checkStatus();
              }
            });
          }
          if (state is RatingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const CustomAppHeader(title: 'المقرأة'),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: ColorsManager.backgroundColor,
                  padding: EdgeInsets.all(16.w),
                  child: _buildBody(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, RatingsState state) {
    if (state is RatingsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is RatingsLoaded) {
      if (state.sessions.isEmpty) {
        return _buildEmptySessions();
      }
      return _buildSessionsList(context, state.sessions);
    } else if (state is RatingsError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message, textAlign: TextAlign.center),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => context.read<RatingsCubit>().checkStatus(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildEmptySessions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80.sp, color: Colors.grey),
          SizedBox(height: 20.h),
          Text(
            'لا توجد جلسات مجدولة حالياً',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList(BuildContext context, List<SessionItem> sessions) {
    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (context, index) => SizedBox(height: 15.h),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _buildSessionCard(context, session);
      },
    );
  }

  Widget _buildSessionCard(BuildContext context, SessionItem session) {
    bool isEnded = session.isEnded;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  session.title,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: ColorsManager.primaryColor),
                ),
              ),
              _statusChip(session.status),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
              SizedBox(width: 5.w),
              Text(
                '${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, "0")} - ${session.durationMinutes} دقيقة',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, size: 16.sp, color: Colors.grey),
                  SizedBox(width: 5.w),
                  Text(
                    'السعة: ${session.maxParticipants} طلاب',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (!isEnded)
                ElevatedButton(
                  onPressed: () => context.read<RatingsCubit>().startMaqraa(session),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: const Text('بدء الحصة', style: TextStyle(color: Colors.white)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'ongoing':
        color = Colors.green;
        label = 'جارية الآن';
        break;
      case 'scheduled':
        color = Colors.blue;
        label = 'مجدولة';
        break;
      case 'ended':
        color = Colors.grey;
        label = 'منتهية';
        break;
      default:
        color = Colors.orange;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}

