class CallModel {
  final int id;
  final String studentName;
  final String status;
  final int durationMinutes;
  final String date;
  final String time;
  final dynamic rating;

  CallModel({
    required this.id,
    required this.studentName,
    required this.status,
    required this.durationMinutes,
    required this.date,
    required this.time,
    this.rating,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      id: json['id'] ?? 0,
      studentName: json['student_name'] ?? '',
      status: json['status'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      rating: json['rating'],
    );
  }
}

class CallListResponse {
  final bool status;
  final CallPagination data;

  CallListResponse({required this.status, required this.data});

  factory CallListResponse.fromJson(Map<String, dynamic> json) {
    return CallListResponse(
      status: json['status'] ?? false,
      data: CallPagination.fromJson(json['data'] ?? {}),
    );
  }
}

class CallPagination {
  final int currentPage;
  final List<CallModel> data;
  final int lastPage;
  final int total;

  CallPagination({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.total,
  });

  factory CallPagination.fromJson(Map<String, dynamic> json) {
    return CallPagination(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List? ?? [])
          .map((item) => CallModel.fromJson(item))
          .toList(),
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}
