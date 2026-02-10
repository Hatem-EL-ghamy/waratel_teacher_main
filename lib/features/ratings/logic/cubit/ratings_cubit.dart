import 'package:flutter_bloc/flutter_bloc.dart';
import 'ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  RatingsCubit() : super(RatingsInitial());

  // Future: Fetch ratings logic
}
