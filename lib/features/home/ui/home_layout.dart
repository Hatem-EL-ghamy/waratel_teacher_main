import 'package:flutter/material.dart';
import '../logic/cubit/home_cubit.dart';
import '../logic/cubit/home_state.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/routing/routers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../core/di/dependency_injection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/draggable_floating_button.dart';
import '../../../../features/profile/logic/cubit/profile_cubit.dart';
import '../../../../features/profile/logic/cubit/profile_state.dart';
import '../../../../features/ads/logic/cubit/ads_cubit.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<HomeCubit>(),
        ),
        // BlocProvider.value لأن ProfileCubit هو LazySingleton —
        // BlocProvider.value لا يُغلق الـ Cubit عند مغادرة الشاشة
        BlocProvider.value(
          value: getIt<ProfileCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<AdsCubit>()..getAds(),
        ),
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
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Stack(
            children: [
              Scaffold(
                backgroundColor: ColorsManager.backgroundColor,
                drawer: const CustomDrawer(),
                body: cubit.screens[cubit.currentIndex],
                // standard FAB removed
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    currentIndex: cubit.currentIndex,
                    onTap: (index) {
                      cubit.changeBottomNav(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: ColorsManager.primaryColor,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.white70,
                    selectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
                    unselectedLabelStyle: TextStyle(fontSize: 12.sp),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        activeIcon: Icon(Icons.home),
                        label: 'الرئيسية',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today_outlined),
                        activeIcon: Icon(Icons.calendar_today),
                        label: 'جدولي',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.mic_outlined),
                        activeIcon: Icon(Icons.mic),
                        label: 'جلساتي',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu_book_outlined),
                        activeIcon: Icon(Icons.menu_book),
                        label: 'المقرأة',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_balance_wallet_outlined),
                        activeIcon: Icon(Icons.account_balance_wallet),
                        label: 'المحفظة',
                      ),
                    ],
                  ),
                ),
              ),
              // Draggable FAB
              DraggableFloatingButton(
                key: const ValueKey('draggable_fab'),
                initialOffset: const Offset(30, 80),
                onPressed: () {
                   // Open Chat Logic
                },
                child: Container(
                  width: 48.w, // Slightly smaller than default 56
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: ColorsManager.accentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                    ]
                  ),
                  child: Icon(Icons.message, color: Colors.white, size: 24.sp),
                ),
              ),
            ],
          );
        },
      ),
     ) );
  }
}
