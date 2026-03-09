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
  final String subtitle;
  final String? bgColor;
  final String? imageUrl;
  final Coupon? coupon;

  const Advertisement({
    required this.id,
    required this.title,
    required this.subtitle,
    this.bgColor,
    this.imageUrl,
    this.coupon,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      bgColor: json['bg_color'] as String?,
      imageUrl: json['image_url'] as String?,
      coupon: json['coupon'] != null
          ? Coupon.fromJson(json['coupon'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Coupon {
  final int id;
  final String code;
  final int percent;

  const Coupon({
    required this.id,
    required this.code,
    required this.percent,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as int,
      code: json['code'] as String,
      percent: json['percent'] as int,
    );
  }
}
