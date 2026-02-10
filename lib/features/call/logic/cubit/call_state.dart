abstract class CallState {}

class CallInitial extends CallState {}

class CallLoading extends CallState {}

class CallLoaded extends CallState {}

class CallError extends CallState {
  final String message;
  CallError(this.message);
}

class CallTogglesUpdated extends CallState {
  final bool isMicOn;
  final bool isCamOn;
  final bool isMushafOpen;

  CallTogglesUpdated({
    required this.isMicOn,
    required this.isCamOn,
    required this.isMushafOpen,
  });
}

class CallTimerUpdated extends CallState {
  final String duration;
  CallTimerUpdated(this.duration);
}
