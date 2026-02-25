import 'home_state.dart';
import '../../ui/home_screen.dart';
import 'package:flutter/material.dart';
import '../../../record/ui/record_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ratings/ui/ratings_screen.dart';
import '../../../schedule/ui/schedule_screen.dart';
import '../../../notifications/ui/notifications_screen.dart';
import 'package:waratel_app/features/wallet/ui/wallet_screen.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Recent Calls Data (moved from UI to Logic)
  List<Map<String, String>> recentCalls = [
      {'name': 'مشعل محمد', 'initial': 'م'},
      {'name': 'مشعل محمد', 'initial': 'م'},
      {'name': 'Abdulka reem', 'initial': ''}, 
      {'name': 'Alili ahmmad', 'initial': ''},
      {'name': 'Sultan Alo thaimeen', 'initial': ''},
      {'name': 'عبد المجيد', 'initial': ''},
  ];

  void addCall(Map<String, String> callData) {
    // Add to beginning of list
    recentCalls.insert(0, callData);
    // Emit state to refresh UI
    emit(HomeRecentCallsUpdated()); 
  }

  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(), // 0: الرئيسية
    const ScheduleScreen(), // 1: جدولي
    const RecordScreen(), // 2: جلساتي
    const RatingsScreen(), // 3: المقرأة
    const WalletScreen(), // 4: المحفظة
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }
}
