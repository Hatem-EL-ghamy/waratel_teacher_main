import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waratel_app/features/home/data/repos/home_repo.dart';
import 'package:waratel_app/features/home/logic/cubit/home_state.dart';
import 'package:waratel_app/features/bookings/data/models/booking_model.dart';
import 'package:waratel_app/features/bookings/data/repos/bookings_repo.dart';
import 'package:waratel_app/features/ratings/data/repos/ratings_repo.dart';
import 'package:waratel_app/features/call/data/models/call_model.dart';
import 'package:waratel_app/features/call/data/repos/calls_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  final BookingsRepo _bookingsRepo;
  final RatingsRepo _ratingsRepo;
  final CallsRepo _callsRepo;

  HomeCubit(
    this._homeRepo,
    this._bookingsRepo,
    this._ratingsRepo,
    this._callsRepo,
  ) : super(HomeInitial());

  bool isOnline = false;
  double averageRating = 4.5; // Default fallback

  Future<void> getInitialOnlineStatus() async {
    isOnline = await _homeRepo.getLocalOnlineStatus();
    emit(HomeInitial());
  }

  Future<void> getAverageRating() async {
    try {
      final response = await _ratingsRepo.getRatings(type: 'call');
      if (response.status) {
        averageRating = response.data.summary.averageRating.toDouble();
        emit(HomeInitial()); // Trigger rebuild for watching widgets
      }
    } catch (e) {
      debugPrint('❌ [HOME CUBIT] Error fetching average rating: $e');
    }
  }

  Future<void> toggleOnline() async {
    emit(ToggleOnlineLoading());
    try {
      final response = await _homeRepo.toggleOnline();
      isOnline = response.data.isOnline;
      emit(ToggleOnlineSuccess(isOnline, response.message));
    } catch (e) {
      emit(ToggleOnlineError(e.toString()));
    }
  }

  BookingModel? soonBooking;

  Future<void> loadSoon({int retryCount = 0}) async {
    // Prevent infinite recursion
    if (retryCount > 2) {
      emit(HomeSoonLoaded(null));
      return;
    }

    emit(HomeSoonLoading());
    
    // Only fetch auxiliary data on the initial load, not on retries
    if (retryCount == 0) {
      getAverageRating(); 
      loadRecentCalls(); 
    }
    try {
      final response = await _homeRepo.getSoon().timeout(const Duration(seconds: 10));
      
      if (response is Map<String, dynamic> && response['status'] == true && response['data'] != null) {
        final Map<String, dynamic> data = response['data'] as Map<String, dynamic>;
        
        // Defensive check: ensure required fields for BookingModel exist to avoid early crashes
        if (data['date'] == null || data['start_time'] == null || data['student'] == null) {
          soonBooking = null;
          emit(HomeSoonLoaded(null));
          return;
        }

        final booking = BookingModel.fromJson(data);
        
        // Auto-expiry logic: if midway point is passed, cancel the slot
        bool expired = false;
        try {
          expired = booking.isExpiredMidway;
        } catch (e) {
          // silent
        }

        if (expired) {
          await _bookingsRepo.cancelSlot(booking.slotId);
          // Wait a bit before retrying to allow server state to stabilize
          await Future.delayed(const Duration(milliseconds: 500));
          return loadSoon(retryCount: retryCount + 1); 
        }
        
        soonBooking = booking;
        emit(HomeSoonLoaded(soonBooking));
      } else {
        soonBooking = null;
        emit(HomeSoonLoaded(null));
      }
    } catch (e) {
      debugPrint('❌ [HOME CUBIT] Error loading soon booking: $e');
      emit(HomeSoonError(e.toString()));
    }
  }

  // ── Recent Calls ──────────────────────────────────────────────────────────
  List<CallModel> recentCalls = [];

  Future<void> loadRecentCalls() async {
    try {
      final response = await _callsRepo.getCalls(page: 1);
      if (response.status) {
        // Take first 10 for the home screen
        recentCalls = response.data.data.take(10).toList();
        emit(HomeRecentCallsUpdated());
      }
    } catch (e) {
      debugPrint('❌ [HOME CUBIT] Error loading recent calls: $e');
    }
  }

  void addCall(CallModel call) {
    recentCalls.insert(0, call);
    if (recentCalls.length > 10) recentCalls.removeLast();
    emit(HomeRecentCallsUpdated());
  }

  // ── Navigation ────────────────────────────────────────────────────────────
  int currentIndex = 0;

  void changeBottomNav(int index) {
    if (currentIndex == index) return; // skip redundant emit
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }
}
