import 'package:flutter/material.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<dynamic> notifications; // Replace dynamic with actual model later
  NotificationsLoaded(this.notifications);
}

class NotificationsError extends NotificationsState {
  final String error;
  NotificationsError(this.error);
}
