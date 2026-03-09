import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/core/di/dependency_injection.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/features/localization/data/app_localizations.dart';
import 'package:waratel_app/features/notifications/data/models/notification_model.dart';
import 'package:waratel_app/features/notifications/logic/cubit/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Static sample list — avoids recreating objects on every build call
  static List<NotificationModel> _sampleNotifications(BuildContext context) => [
    NotificationModel(
      id: '1',
      title: 'new_session_notif'.tr(context),
      message: 'session_msg_notif'
          .tr(context)
          .replaceFirst('%s', 'أحمد محمد')
          .replaceFirst('%s', '3:00 مساءً'),
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      type: NotificationType.session,
    ),
    NotificationModel(
      id: '2',
      title: 'achievement_notif'.tr(context),
      message: 'achievement_msg_notif'.tr(context),
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      type: NotificationType.achievement,
    ),
    NotificationModel(
      id: '3',
      title: 'reminder_notif'.tr(context),
      message: 'reminder_msg_notif'.tr(context),
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.reminder,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>(),
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundColor,
        appBar: AppBar(
          title: Text('notifications'.tr(context)),
          // Inherits backgroundColor, foregroundColor, centerTitle from theme
          actions: [
            TextButton(
              onPressed: () {/* mark all as read */},
              child: Text(
                'mark_all_read'.tr(context),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ],
        ),
        body: _NotificationsList(
          notifications: _sampleNotifications(context),
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  const _NotificationsList({required this.notifications});
  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) return const _EmptyState();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: notifications.length,
      itemBuilder: (context, index) =>
          _NotificationItem(notification: notifications[index]),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final typeColor = _colorForType(notification.type);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: notification.isRead
            ? ColorsManager.surfaceColor
            : ColorsManager.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: notification.isRead
              ? ColorsManager.borderColor
              : ColorsManager.primaryColor.withValues(alpha: 0.18),
        ),
      ),
      child: ListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_iconForType(notification.type),
              color: typeColor, size: 22.sp),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead
                      ? FontWeight.w500
                      : FontWeight.bold,
                  fontSize: 14.sp,
                  color: ColorsManager.textPrimaryColor,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: ColorsManager.errorColor,
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
              style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorsManager.textSecondaryColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorsManager.textHintColor),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.session:     return Icons.video_call;
      case NotificationType.payment:     return Icons.payment;
      case NotificationType.achievement: return Icons.emoji_events;
      case NotificationType.reminder:    return Icons.alarm;
      default:                           return Icons.notifications;
    }
  }

  Color _colorForType(NotificationType type) {
    switch (type) {
      case NotificationType.session:     return ColorsManager.primaryColor;
      case NotificationType.payment:     return ColorsManager.successColor;
      case NotificationType.achievement: return ColorsManager.accentColor;
      case NotificationType.reminder:    return ColorsManager.warningColor;
      default:                           return ColorsManager.textSecondaryColor;
    }
  }

  String _formatTimestamp(DateTime ts) {
    final diff = DateTime.now().difference(ts);
    if (diff.inMinutes < 60)  return 'قبل ${diff.inMinutes} دقيقة';
    if (diff.inHours   < 24)  return 'قبل ${diff.inHours} ساعة';
    if (diff.inDays    < 7)   return 'قبل ${diff.inDays} يوم';
    return '${ts.day}/${ts.month}/${ts.year}';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none,
              size: 80.sp, color: ColorsManager.borderColor),
          SizedBox(height: 16.h),
          Text(
            'no_notifications'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'new_notifications_here'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorsManager.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
