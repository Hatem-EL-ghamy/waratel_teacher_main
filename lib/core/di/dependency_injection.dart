import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/home/logic/cubit/home_cubit.dart';
import '../../features/call/logic/cubit/call_cubit.dart';
import '../../features/login/data/api/login_api.dart';
import '../../features/login/data/repos/repos.dart';
import '../../features/login/logic/cubit/login_cubit.dart';
import '../../features/profile/data/api/profile_api.dart';
import '../../features/profile/data/repos/profile_repo.dart';
import '../../features/profile/logic/cubit/profile_cubit.dart';
import '../../features/schedule/logic/cubit/schedule_cubit.dart';
import '../../../features/ratings/logic/cubit/ratings_cubit.dart';
import '../../features/notifications/logic/cubit/notifications_cubit.dart';
import '../../features/achievement_plan/logic/cubit/achievement_plan_cubit.dart';
import '../../features/record/logic/cubit/record_cubit.dart';
import '../../features/ratings/data/api/sessions_api.dart';
import '../../features/ratings/data/repos/sessions_repo.dart';
import '../agora/agora_service.dart';
import '../../features/ads/data/api/ads_api.dart';
import '../../features/ads/data/repos/ads_repo.dart';
import '../../features/ads/logic/cubit/ads_cubit.dart';
import '../../features/schedule/data/api/schedule_api.dart';
import '../../features/schedule/data/repos/schedule_repo.dart';
import '../networking/api_client.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── Networking ──────────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(() => ApiClient.createDio());

  // ── Login ────────────────────────────────────────────────────
  getIt.registerLazySingleton<LoginApi>(() => LoginApi(getIt<Dio>()));
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt<LoginApi>()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));

  // ── Home ─────────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit());

  // ── Ads ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<AdsApi>(() => AdsApi(getIt<Dio>()));
  getIt.registerLazySingleton<AdsRepo>(() => AdsRepo(getIt<AdsApi>()));
  getIt.registerFactory<AdsCubit>(() => AdsCubit(getIt<AdsRepo>()));

  // ── Schedule ─────────────────────────────────────────────────
  getIt.registerLazySingleton<ScheduleApi>(() => ScheduleApi(getIt<Dio>()));
  getIt.registerLazySingleton<ScheduleRepo>(
      () => ScheduleRepo(getIt<ScheduleApi>()));
  getIt.registerFactory<ScheduleCubit>(
      () => ScheduleCubit(getIt<ScheduleRepo>()));

  // ── Other Features ───────────────────────────────────────────
  getIt.registerFactory<AchievementPlanCubit>(() => AchievementPlanCubit());
  getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit());
  getIt.registerFactory<CallCubit>(() => CallCubit(getIt<AgoraService>()));

  // ── Agora & RTC ──────────────────────────────────────────────
  getIt.registerLazySingleton<AgoraService>(() => AgoraService());

  // ── Maqraa (Sessions) ─────────────────────────────────────────
  getIt.registerLazySingleton<SessionsApi>(() => SessionsApi(getIt<Dio>()));
  getIt.registerLazySingleton<SessionsRepo>(() => SessionsRepo(getIt<SessionsApi>()));

  // ── Profile ───────────────────────────────────────────────────
  getIt.registerLazySingleton<ProfileApi>(() => ProfileApi(getIt<Dio>()));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt<ProfileApi>()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt<ProfileRepo>()));

  // Record must be registered before Ratings (Ratings depends on it)
  getIt.registerLazySingleton<RecordCubit>(() => RecordCubit());
  getIt.registerFactory<RatingsCubit>(
      () => RatingsCubit(getIt<SessionsRepo>(), getIt<AgoraService>(), getIt<RecordCubit>()));
}
