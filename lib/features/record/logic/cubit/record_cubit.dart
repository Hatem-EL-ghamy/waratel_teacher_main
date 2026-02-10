import 'package:flutter_bloc/flutter_bloc.dart';
import 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());

  bool showCompletedCalls = true;

  void changeFilter(bool completed) {
    showCompletedCalls = completed;
    emit(RecordFilterChangedState(showCompletedCalls));
  }
}
