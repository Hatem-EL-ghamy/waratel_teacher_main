class AdsResponse {
  final bool status;
  final String message;
  final AdsData data;

  const AdsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdsResponse.fromJson(Map<String, dynamic> json) {
    return AdsResponse(
      status: json['status'] as bool,
      message: json['message'].toString(),
      data: AdsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class AdsData {
  final int currentPage;
  final List<Advertisement> data;
  final int lastPage;
  final int perPage;
  final int total;

  const AdsData({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory AdsData.fromJson(Map<String, dynamic> json) {
    return AdsData(
      currentPage: json['current_page'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => Advertisement.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }
}

class Advertisement {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  const Advertisement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url'] as String?,
    );
  }
}
