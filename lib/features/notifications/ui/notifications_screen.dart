import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../logic/cubit/notifications_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../data/models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>(),
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundColor,
        appBar: AppBar(
          title: const Text('الإشعارات'),
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // Mark all as read
              },
              child: Text(
                'تحديد الكل كمقروء',
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        body: _buildNotificationsList(),
      ),
    );
  }

  Widget _buildNotificationsList() {
    // Sample notifications for demonstration
    final List<NotificationModel> notifications = [
      NotificationModel(
        id: '1',
        title: 'جلسة جديدة',
        message: 'لديك جلسة جديدة مع الطالب أحمد محمد في تمام الساعة 3:00 مساءً',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        type: NotificationType.session,
      ),
      NotificationModel(
        id: '2',
        title: 'تحديث خطة الإنجاز',
        message: 'تم تحديث خطة الإنجاز الخاصة بك بنجاح',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
        type: NotificationType.achievement,
      ),
      NotificationModel(
        id: '3',
        title: 'تذكير',
        message: 'لا تنسى مراجعة الجلسات المقررة لهذا الأسبوع',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        type: NotificationType.reminder,
      ),
    ];

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index]);
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : ColorsManager.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: notification.isRead ? Colors.grey.shade200 : ColorsManager.primaryColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
            size: 24.sp,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification.message,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400),
            ),
          ],
        ),
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'سيتم عرض الإشعارات الجديدة هنا',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.session:
        return Icons.video_call;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.session:
        return ColorsManager.primaryColor;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.achievement:
        return ColorsManager.accentColor;
      case NotificationType.reminder:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
