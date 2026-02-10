import 'package:flutter/material.dart';

@immutable
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<String> appointments; // Mock list
  ScheduleLoaded(this.appointments);
}

class ScheduleError extends ScheduleState {
  final String error;
  ScheduleError(this.error);
}
