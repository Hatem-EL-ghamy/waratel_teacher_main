import '../api/ratings_api.dart';
import '../models/rating_model.dart';

class RatingsRepo {
  final RatingsApi _api;

  RatingsRepo(this._api);

  Future<RatingResponse> getRatings({String type = 'call', int page = 1}) async {
    try {
      return await _api.getRatings(type: type, page: page);
    } catch (e) {
      throw Exception('فشل جلب التقييمات والإحصائيات');
    }
  }
}
