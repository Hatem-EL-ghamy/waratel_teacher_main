import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  void loadNotifications() async {
    emit(NotificationsLoading());
    await Future.delayed(const Duration(seconds: 1));
    // Mock data
    emit(NotificationsLoaded(List.generate(4, (index) => 'Notification $index')));
  }
}
