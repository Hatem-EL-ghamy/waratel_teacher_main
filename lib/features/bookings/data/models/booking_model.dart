class BookingStudent {
  final int id;
  final String name;
  final String? photo;

  const BookingStudent({
    required this.id,
    required this.name,
    this.photo,
  });

  factory BookingStudent.fromJson(Map<String, dynamic> json) {
    return BookingStudent(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: (json['name'] ?? '').toString(),
      photo: json['photo']?.toString(),
    );
  }
}

class BookingCallSession {
  final int id;
  final String status;
  final String channelName;
  final bool canStartNow;
  final int duration;

  const BookingCallSession({
    required this.id,
    required this.status,
    required this.channelName,
    required this.canStartNow,
    required this.duration,
  });

  factory BookingCallSession.fromJson(Map<String, dynamic> json) {
    return BookingCallSession(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      status: (json['status'] ?? '').toString(),
      channelName: (json['channel_name'] ?? '').toString(),
      canStartNow: json['can_start_now'] == true,
      duration: (json['duration'] is int) ? json['duration'] : int.tryParse(json['duration'].toString()) ?? 0,
    );
  }
}

class BookingModel {
  final int slotId;
  final String date;
  final String startTime;
  final String endTime;
  final String bookingStatus;
  final BookingStudent student;
  final BookingCallSession? callSession;
  final dynamic rating;

  const BookingModel({
    required this.slotId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.bookingStatus,
    required this.student,
    this.callSession,
    this.rating,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      slotId: (json['slot_id'] is int) ? json['slot_id'] : int.tryParse(json['slot_id'].toString()) ?? 0,
      date: (json['date'] ?? '').toString(),
      startTime: (json['start_time'] ?? '').toString(),
      endTime: (json['end_time'] ?? '').toString(),
      bookingStatus: (json['booking_status'] ?? '').toString(),
      student: BookingStudent.fromJson(json['student'] as Map<String, dynamic>),
      callSession: json['call_session'] != null
          ? BookingCallSession.fromJson(json['call_session'] as Map<String, dynamic>)
          : null,
      rating: json['rating'],
    );
  }

  bool get canStart => callSession?.canStartNow == true || isWithinJoinWindow;

  DateTime get startDateTime => DateTime.parse('$date $startTime');
  DateTime get endDateTime => DateTime.parse('$date $endTime');

  bool get isExpiredMidway {
    if (bookingStatus != 'scheduled') return false;
    
    final now = DateTime.now();
    final midwayPoint = startDateTime.add(
      Duration(minutes: endDateTime.difference(startDateTime).inMinutes ~/ 2),
    );
    
    return now.isAfter(midwayPoint);
  }

  bool get isWithinJoinWindow {
    if (bookingStatus == 'ongoing') return true;
    if (bookingStatus != 'scheduled') return false;
    
    final now = DateTime.now();
    final difference = startDateTime.difference(now).inMinutes;
    // Show button if it's 10 minutes before start or anytime after start (if status is still scheduled)
    // But we should also check if it's NOT expired midway
    return difference <= 10 && !isExpiredMidway;
  }
}

class BookingsPagination {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  final String? nextPageUrl;

  const BookingsPagination({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
    this.nextPageUrl,
  });

  factory BookingsPagination.fromJson(Map<String, dynamic> json) {
    return BookingsPagination(
      currentPage: int.tryParse(json['current_page'].toString()) ?? 1,
      lastPage: int.tryParse(json['last_page'].toString()) ?? 1,
      total: int.tryParse(json['total'].toString()) ?? 0,
      perPage: int.tryParse(json['per_page'].toString()) ?? 15,
      nextPageUrl: json['next_page_url']?.toString(),
    );
  }
}

class BookingsResponse {
  final bool status;
  final String message;
  final List<BookingModel> bookings;
  final BookingsPagination? pagination;

  const BookingsResponse({
    required this.status,
    required this.message,
    required this.bookings,
    this.pagination,
  });

  factory BookingsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    List<BookingModel> bookings = [];
    BookingsPagination? pagination;

    if (data != null) {
      if (data is Map<String, dynamic>) {
        final dataList = data['data'];
        if (dataList is List) {
          bookings = dataList
              .whereType<Map<String, dynamic>>()
              .map((e) => BookingModel.fromJson(e))
              .toList();
        }
        pagination = BookingsPagination.fromJson(data);
      } else if (data is List) {
        // Handle case where 'data' is a direct list of bookings
        bookings = data
            .whereType<Map<String, dynamic>>()
            .map((e) => BookingModel.fromJson(e))
            .toList();
      }
    }

    return BookingsResponse(
      status: json['status'] == true,
      message: (json['message'] ?? '').toString(),
      bookings: bookings,
      pagination: pagination,
    );
  }
}

class SoonResponse {
  final bool status;
  final BookingModel? booking;

  const SoonResponse({required this.status, this.booking});

  factory SoonResponse.fromJson(Map<String, dynamic> json) {
    return SoonResponse(
      status: json['status'] == true,
      booking: json['data'] != null && json['data'] is Map<String, dynamic>
          ? BookingModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StartCallResponse {
  final bool status;
  final String token;
  final String channel;
  final int uid;

  const StartCallResponse({
    required this.status,
    required this.token,
    required this.channel,
    required this.uid,
  });

  factory StartCallResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return StartCallResponse(
      status: json['status'] == true,
      token: (data['token'] ?? '').toString(),
      channel: (data['channel'] ?? '').toString(),
      uid: (data['uid'] is int) ? data['uid'] : int.tryParse(data['uid'].toString()) ?? 0,
    );
  }
}

class CancelSlotResponse {
  final bool status;
  final String message;

  const CancelSlotResponse({required this.status, required this.message});

  factory CancelSlotResponse.fromJson(Map<String, dynamic> json) {
    return CancelSlotResponse(
      status: json['status'] == true,
      message: (json['message'] ?? '').toString(),
    );
  }
}
