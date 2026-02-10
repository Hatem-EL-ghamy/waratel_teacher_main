import 'package:get_it/get_it.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import '../../features/home/logic/cubit/home_cubit.dart';
import '../../features/achievement_plan/logic/cubit/achievement_plan_cubit.dart';
import '../../features/notifications/logic/cubit/notifications_cubit.dart';
import '../../features/call/logic/cubit/call_cubit.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../../features/ratings/logic/cubit/ratings_cubit.dart';
import '../../features/record/logic/cubit/record_cubit.dart';
import '../../features/schedule/logic/cubit/schedule_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Cubits
  getIt.registerFactory<LoginCubit>(() => LoginCubit());
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit());
  getIt.registerFactory<AchievementPlanCubit>(() => AchievementPlanCubit());
  getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit());
  
  // Call Feature
  getIt.registerFactory<CallCubit>(() => CallCubit());
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit());
  getIt.registerFactory<RatingsCubit>(() => RatingsCubit());
  getIt.registerFactory<RecordCubit>(() => RecordCubit());
  getIt.registerFactory<ScheduleCubit>(() => ScheduleCubit());
}
