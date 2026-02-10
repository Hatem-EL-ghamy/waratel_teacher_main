import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../../data/models/advertisement.dart';
import '../../ui/home_screen.dart';
import '../../../record/ui/record_screen.dart';
import '../../../schedule/ui/schedule_screen.dart';
import '../../../ratings/ui/ratings_screen.dart';
import '../../../notifications/ui/notifications_screen.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Advertisement> ads = [];

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
    const NotificationsScreen(), // 4: المحفظة
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }

  void getAds() {
    emit(HomeAdsLoading());
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      ads = [
        Advertisement(
          id: 1,
          title: 'كرماً نأمل منك الاطلاع على',
          description: 'شرح خاصية (الجدول)\nوإضافة المواعيد المناسبة لك',
          imageUrl: 'assets/images/ad1.png',
        ),
         Advertisement(
          id: 2,
          title: 'تحديث جديد',
          description: 'تم إضافة ميزات جديدة\nلتحسين تجربتك',
          imageUrl: 'assets/images/ad2.png',
        ),
         Advertisement(
          id: 3,
          title: 'شاركنا رأيك',
          description: 'رأيك يهمنا\nلتحسين التطبيق',
          imageUrl: 'assets/images/ad3.png',
        ),
      ];
      emit(HomeAdsLoaded(ads));
    });
  }
}
