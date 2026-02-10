import 'package:flutter/material.dart';

@immutable
abstract class AchievementPlanState {}

class AchievementPlanInitial extends AchievementPlanState {}

class AchievementPlanLoading extends AchievementPlanState {}

class AchievementPlanSuccess extends AchievementPlanState {}

class AchievementPlanError extends AchievementPlanState {
  final String error;
  AchievementPlanError(this.error);
}
