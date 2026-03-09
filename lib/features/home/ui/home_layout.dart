import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/core/di/dependency_injection.dart';
import 'package:waratel_app/core/routing/routers.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/core/call/call_service.dart';
import 'package:waratel_app/core/call/call_api_service.dart';
import 'package:waratel_app/core/widgets/custom_drawer.dart';
import 'package:waratel_app/core/widgets/draggable_floating_button.dart';
import 'package:waratel_app/features/ads/logic/cubit/ads_cubit.dart';
import 'package:waratel_app/features/home/logic/cubit/home_cubit.dart';
import 'package:waratel_app/features/home/logic/cubit/home_state.dart';
import 'package:waratel_app/features/home/ui/home_screen.dart';
import 'package:waratel_app/features/localization/data/app_localizations.dart';
import 'package:waratel_app/features/profile/logic/cubit/profile_cubit.dart';
import 'package:waratel_app/features/profile/logic/cubit/profile_state.dart';
import 'package:waratel_app/features/ratings/ui/ratings_screen.dart';
import 'package:waratel_app/features/bookings/ui/bookings_screen.dart';
import 'package:waratel_app/features/schedule/ui/schedule_screen.dart';
import 'package:waratel_app/features/wallet/ui/wallet_screen.dart';
import 'package:waratel_app/features/bot_chat/ui/gemini_chat_screen.dart';
import 'package:waratel_app/features/bookings/logic/cubit/bookings_cubit.dart';

// ── Screens are kept here (UI layer), NOT inside HomeCubit ──────────────────
// This is a fixed list; it never changes — all five widgets are created once
// and kept alive by IndexedStack, so switching tabs has zero rebuild cost.
const List<Widget> _kScreens = [
  HomeScreen(),     // 0 — الرئيسية
  ScheduleScreen(), // 1 — جدولي
  BookingsScreen(), // 2 — جلساتي
  RatingsScreen(),  // 3 — المقرأة
  WalletScreen(),   // 4 — المحفظة
];

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    super.initState();
    // 📞 Start listening to calls only after the layout is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🏠 [HOME LAYOUT] Deferring CallService listeners and data load...');
      // 1. Listen for calls using the DI instance
      CallService.listenToCallEvents(getIt<CallApiService>());
      
      // 2. Load initial data with staggered delays to prevent SSL/Network contention
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (!mounted) return;
        debugPrint('🏠 [HOME LAYOUT] Starting staggered data load...');
        
        // 2.1 Load Profile
        getIt<ProfileCubit>().getProfile();
        await Future.delayed(const Duration(milliseconds: 200));
        
        // 2.2 Load Ads (Already handled by BlocProvider create)
        // if (mounted) context.read<AdsCubit>().getAds();
        // await Future.delayed(const Duration(milliseconds: 200));

        // 2.3 Load Soon Booking
        if (mounted) getIt<HomeCubit>().loadSoon();
        await Future.delayed(const Duration(milliseconds: 200));

        // 2.4 Load Online Status
        if (mounted) getIt<HomeCubit>().getInitialOnlineStatus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<HomeCubit>()),
        BlocProvider.value(value: getIt<ProfileCubit>()),
        BlocProvider(create: (_) => getIt<AdsCubit>()..getAds()),
        BlocProvider(create: (_) => getIt<BookingsCubit>()),
      ],
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          } else if (state is LogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: ColorsManager.errorColor,
              ),
            );
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (_, curr) => curr is HomeChangeBottomNavState,
          builder: (context, _) {
            final cubit = context.read<HomeCubit>();
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: ColorsManager.backgroundColor,
                  drawer: const CustomDrawer(),
                  body: IndexedStack(
                    index: cubit.currentIndex,
                    children: _kScreens,
                  ),
                  bottomNavigationBar: _BottomNav(cubit: cubit),
                ),
                DraggableFloatingButton(
                  key: const ValueKey('draggable_fab'),
                  initialOffset: const Offset(30, 80),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeminiChatScreen(),
                      ),
                    );
                  },
                  child: const _FabContent(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Sub-widgets extracted so they never participate in unrelated rebuilds ───

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.cubit});
  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: cubit.currentIndex,
        onTap: cubit.changeBottomNav,
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorsManager.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        unselectedLabelStyle: TextStyle(fontSize: 12.sp),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'home'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today_outlined),
            activeIcon: const Icon(Icons.calendar_today),
            label: 'schedule'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_turned_in_outlined),
            activeIcon: const Icon(Icons.assignment_turned_in),
            label: 'sessions'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book_outlined),
            activeIcon: const Icon(Icons.menu_book),
            label: 'maqraa'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: 'wallet'.tr(context),
          ),
        ],
      ),
    );
  }
}

class _FabContent extends StatelessWidget {
  const _FabContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: const BoxDecoration(
        gradient: ColorsManager.accentGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Icon(Icons.auto_awesome, color: Colors.white, size: 24.sp),
    );
  }
}
