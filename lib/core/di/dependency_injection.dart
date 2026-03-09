import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:waratel_app/features/home/logic/cubit/home_cubit.dart';
import 'package:waratel_app/features/call/logic/cubit/call_cubit.dart';
import 'package:waratel_app/features/login/data/api/login_api.dart';
import 'package:waratel_app/features/login/data/repos/repos.dart';
import 'package:waratel_app/features/home/data/api/home_api.dart';
import 'package:waratel_app/features/home/data/repos/home_repo.dart';
import 'package:waratel_app/features/login/logic/cubit/login_cubit.dart';
import 'package:waratel_app/features/profile/data/api/profile_api.dart';
import 'package:waratel_app/features/profile/data/repos/profile_repo.dart';
import 'package:waratel_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:waratel_app/features/schedule/logic/cubit/schedule_cubit.dart';
import 'package:waratel_app/features/ratings/logic/cubit/ratings_cubit.dart';
import 'package:waratel_app/features/notifications/logic/cubit/notifications_cubit.dart';
import 'package:waratel_app/features/achievement_plan/logic/cubit/achievement_plan_cubit.dart';
import 'package:waratel_app/features/record/logic/cubit/record_cubit.dart';
import 'package:waratel_app/features/ratings/data/api/sessions_api.dart';
import 'package:waratel_app/features/ratings/data/repos/sessions_repo.dart';
import 'package:waratel_app/core/agora/agora_service.dart';
import 'package:waratel_app/features/ads/data/api/ads_api.dart';
import 'package:waratel_app/features/ads/data/repos/ads_repo.dart';
import 'package:waratel_app/features/ads/logic/cubit/ads_cubit.dart';
import 'package:waratel_app/features/schedule/data/api/schedule_api.dart';
import 'package:waratel_app/features/schedule/data/repos/schedule_repo.dart';
import 'package:waratel_app/features/localization/logic/cubit/locale_cubit.dart';
import 'package:waratel_app/core/networking/api_client.dart';
import 'package:waratel_app/features/wallet/data/api/wallet_api.dart';
import 'package:waratel_app/features/wallet/data/repos/wallet_repo.dart';
import 'package:waratel_app/core/call/call_api_service.dart';
import 'package:waratel_app/core/call/call_service.dart';
import 'package:waratel_app/features/call/data/api/calls_api.dart';
import 'package:waratel_app/features/call/data/repos/calls_repo.dart';
import 'package:waratel_app/features/wallet/logic/cubit/wallet_cubit.dart';
import 'package:waratel_app/features/bookings/data/api/bookings_api.dart';
import 'package:waratel_app/features/bookings/data/repos/bookings_repo.dart';
import 'package:waratel_app/features/bookings/logic/cubit/bookings_cubit.dart';
import 'package:waratel_app/features/ratings/data/api/ratings_api.dart';
import 'package:waratel_app/features/ratings/data/repos/ratings_repo.dart';
import 'package:waratel_app/features/statistics/logic/cubit/statistics_cubit.dart';
import 'package:waratel_app/features/contact_us/data/api/contact_api.dart';
import 'package:waratel_app/features/contact_us/data/repos/contact_repo.dart';
import 'package:waratel_app/features/contact_us/logic/cubit/contact_cubit.dart';


final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── 1. CORE SERVICES ─────────────────────────────────────────
  getIt.registerLazySingleton<Dio>(() => ApiClient.createDio());
  getIt.registerLazySingleton<AgoraService>(() => AgoraService());
  getIt.registerLazySingleton<CallService>(() => CallService());
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  getIt.registerLazySingleton<RecordCubit>(() => RecordCubit());

  // ── 2. APIs ──────────────────────────────────────────────────
  getIt.registerLazySingleton<LoginApi>(() => LoginApi(getIt<Dio>()));
  getIt.registerLazySingleton<AdsApi>(() => AdsApi(getIt<Dio>()));
  getIt.registerLazySingleton<ScheduleApi>(() => ScheduleApi(getIt<Dio>()));
  getIt.registerLazySingleton<SessionsApi>(() => SessionsApi(getIt<Dio>()));
  getIt.registerLazySingleton<ProfileApi>(() => ProfileApi(getIt<Dio>()));
  getIt.registerLazySingleton<BookingsApi>(() => BookingsApi(getIt<Dio>()));
  getIt.registerLazySingleton<HomeApi>(() => HomeApi(getIt<Dio>()));
  getIt.registerLazySingleton<WalletApi>(() => WalletApi(getIt<Dio>()));
  getIt.registerLazySingleton<CallApiService>(() => CallApiService(getIt<Dio>()));
  getIt.registerLazySingleton<CallsApi>(() => CallsApi(getIt<Dio>()));
  getIt.registerLazySingleton<RatingsApi>(() => RatingsApi(getIt<Dio>()));
  getIt.registerLazySingleton<ContactApi>(() => ContactApi(getIt<Dio>()));

  // ── 3. REPOSITORIES ──────────────────────────────────────────
  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt<LoginApi>()));
  getIt.registerLazySingleton<AdsRepo>(() => AdsRepo(getIt<AdsApi>()));
  getIt.registerLazySingleton<ScheduleRepo>(() => ScheduleRepo(getIt<ScheduleApi>()));
  getIt.registerLazySingleton<SessionsRepo>(() => SessionsRepo(getIt<SessionsApi>()));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt<ProfileApi>()));
  getIt.registerLazySingleton<BookingsRepo>(() => BookingsRepo(getIt<BookingsApi>()));
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt<HomeApi>()));
  getIt.registerLazySingleton<WalletRepo>(() => WalletRepo(getIt<WalletApi>()));
  getIt.registerLazySingleton<CallsRepo>(() => CallsRepo(getIt<CallsApi>()));
  getIt.registerLazySingleton<RatingsRepo>(() => RatingsRepo(getIt<RatingsApi>()));
  getIt.registerLazySingleton<ContactRepo>(() => ContactRepo(getIt<ContactApi>()));

  // ── 4. LOGIC (CUBITS) ────────────────────────────────────────
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));
  getIt.registerFactory<AdsCubit>(() => AdsCubit(getIt<AdsRepo>()));
  getIt.registerFactory<ScheduleCubit>(() => ScheduleCubit(getIt<ScheduleRepo>()));
  getIt.registerFactory<AchievementPlanCubit>(() => AchievementPlanCubit());
  getIt.registerFactory<NotificationsCubit>(() => NotificationsCubit());
  getIt.registerFactory<CallCubit>(() => CallCubit(getIt<AgoraService>()));
  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt<ProfileRepo>()));
  getIt.registerFactory<RatingsCubit>(() => RatingsCubit(
      getIt<SessionsRepo>(), getIt<AgoraService>(), getIt<RecordCubit>()));
  getIt.registerFactory<BookingsCubit>(() => BookingsCubit(getIt<BookingsRepo>()));
  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit(
        getIt<HomeRepo>(),
        getIt<BookingsRepo>(),
        getIt<RatingsRepo>(),
        getIt<CallsRepo>(),
      ));
  getIt.registerFactory<WalletCubit>(() => WalletCubit(getIt<WalletRepo>()));
  getIt.registerFactory<StatisticsCubit>(() => StatisticsCubit(
        getIt<RatingsRepo>(),
        getIt<CallsRepo>(),
        getIt<SessionsRepo>(),
      ));
  getIt.registerFactory<ContactCubit>(() => ContactCubit(getIt<ContactRepo>()));
}
