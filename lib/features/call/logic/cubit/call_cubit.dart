import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallInitial());

  bool isMicOn = true;
  bool isCamOn = true;
  bool isMushafOpen = false;
  Timer? _timer;
  int _secondsElapsed = 0;
  
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  Future<void> startCall() async {
    emit(CallLoading());
    
    // Initialize camera
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        cameraController = CameraController(
          cameras![1], // Front camera (index 1), use 0 for back
          ResolutionPreset.medium,
        );
        await cameraController!.initialize();
      }
    } catch (e) {
      // Camera initialization failed, continue without camera
      print('Camera initialization error: $e');
    }
    
    _startTimer();
    emit(CallLoaded());
    emitToggles();
  }

  void toggleMic() {
    isMicOn = !isMicOn;
    emitToggles();
  }

  Future<void> toggleCam() async {
    isCamOn = !isCamOn;
    emitToggles();
  }

  void toggleMushaf() {
    isMushafOpen = !isMushafOpen;
    emitToggles();
  }

  void emitToggles() {
    emit(CallTogglesUpdated(
      isMicOn: isMicOn,
      isCamOn: isCamOn,
      isMushafOpen: isMushafOpen,
    ));
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      emit(CallTimerUpdated(_formatDuration(_secondsElapsed)));
    });
  }

  String _formatDuration(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void endCall() {
    _timer?.cancel();
    cameraController?.dispose();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    cameraController?.dispose();
    return super.close();
  }
}
