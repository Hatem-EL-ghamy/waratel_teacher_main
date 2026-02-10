import 'package:flutter_bloc/flutter_bloc.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleInitial());

  void loadSchedule() {
    emit(ScheduleLoading());
    // Mock loading
    Future.delayed(const Duration(seconds: 1), () {
      emit(ScheduleLoaded([])); // Empty list for now
    });
  }
}
