import 'package:waratel_app/features/bookings/data/api/bookings_api.dart';
import 'package:waratel_app/features/bookings/data/models/booking_model.dart';

class BookingsRepo {
  final BookingsApi _api;

  BookingsRepo(this._api);

  Future<BookingsResponse> getBookings({int page = 1}) async {
    try {
      return await _api.getBookings(page: page);
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<StartCallResponse> startBooking(int slotId, int callSessionId) async {
    try {
      return await _api.startBooking(slotId, callSessionId);
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<CancelSlotResponse> cancelSlot(int slotId) async {
    try {
      return await _api.cancelSlot(slotId);
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<SoonResponse> getSoon() async {
    try {
      return await _api.getSoon();
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
