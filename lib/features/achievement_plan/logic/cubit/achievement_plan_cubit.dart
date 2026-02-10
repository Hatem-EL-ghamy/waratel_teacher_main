import 'package:flutter_bloc/flutter_bloc.dart';
import 'achievement_plan_state.dart';

class AchievementPlanCubit extends Cubit<AchievementPlanState> {
  AchievementPlanCubit() : super(AchievementPlanInitial());

  // Future: Add logic for managing preferences and percentages
  // For now, it just emits initial state
}
