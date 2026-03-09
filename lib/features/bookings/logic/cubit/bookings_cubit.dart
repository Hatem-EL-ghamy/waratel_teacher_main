import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waratel_app/features/bookings/data/repos/bookings_repo.dart';
import 'package:waratel_app/features/bookings/data/models/booking_model.dart';
import 'package:waratel_app/features/bookings/logic/cubit/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingsRepo _repo;

  BookingsCubit(this._repo) : super(BookingsInitial()) {
    loadBookings();
  }

  List<BookingModel> _bookings = [];

  Future<void> loadBookings({int page = 1}) async {
    emit(BookingsLoading());
    try {
      final response = await _repo.getBookings(page: page);
      if (response.status) {
        _bookings = response.bookings;
        final hasMore = response.pagination?.nextPageUrl != null;
        emit(BookingsLoaded(List.from(_bookings), hasMore: hasMore));
      } else {
        emit(BookingsError('فشل تحميل الحجوزات'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(BookingsError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> cancelSlot(int slotId) async {
    emit(CancelSlotLoading());
    try {
      final response = await _repo.cancelSlot(slotId);
      if (response.status) {
        emit(CancelSlotSuccess(response.message));
        await loadBookings();
      } else {
        emit(CancelSlotError(response.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(CancelSlotError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> startCall(int slotId, int callSessionId, String studentName) async {
    emit(StartCallLoading());
    try {
      final response = await _repo.startBooking(slotId, callSessionId);
      if (response.status) {
        emit(StartCallSuccess(
          token: response.token,
          channel: response.channel,
          uid: response.uid,
          studentName: studentName,
        ));
      } else {
        emit(StartCallError('فشل بدء المكالمة'));
      }
    } catch (e) {
      if (!isClosed) {
        emit(StartCallError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }
}
