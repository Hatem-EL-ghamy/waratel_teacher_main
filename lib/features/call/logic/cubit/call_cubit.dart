import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/agora/agora_service.dart';
import 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  final AgoraService _agoraService;
  
  CallCubit(this._agoraService) : super(CallInitial());

  bool isMicOn = true;
  bool isCamOn = true;
  bool isMushafOpen = false;
  Timer? _timer;
  int _secondsElapsed = 0;
  
  int? remoteUid;

  Future<void> startCall({
    required String token,
    required String channelName,
    required int uid,
  }) async {
    // Request permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted || 
        statuses[Permission.microphone] != PermissionStatus.granted) {
      emit(CallError('يرجى منح صلاحيات الكاميرا والميكروفون للمتابعة'));
      return;
    }

    emit(CallLoading());
    
    try {
      _setupAgoraHandlers();
      
      await _agoraService.joinChannel(
        token: token,
        channelName: channelName,
        uid: uid,
      );
      
      _startTimer();
      emit(CallLoaded());
      emitToggles();
    } catch (e) {
      emit(CallError(e.toString()));
    }
  }

  void _setupAgoraHandlers() {
    _agoraService.onUserJoined = (uid) {
      remoteUid = uid;
      emit(CallLoaded()); // Refresh to show remote video
      emit(CallRemoteUserJoined(uid));
    };

    _agoraService.onUserLeft = (uid) {
      if (remoteUid == uid) {
        remoteUid = null;
        emit(CallLoaded());
        emit(CallRemoteUserLeft(uid));
      }
    };
  }

  void toggleMic() {
    isMicOn = !isMicOn;
    _agoraService.muteLocalMic(!isMicOn);
    emitToggles();
  }

  Future<void> toggleCam() async {
    isCamOn = !isCamOn;
    _agoraService.enableLocalVideo(isCamOn);
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

  Future<void> endCall() async {
    _timer?.cancel();
    await _agoraService.leaveChannel();
    _resetAgoraHandlers();
  }

  void _resetAgoraHandlers() {
    _agoraService.onUserJoined = null;
    _agoraService.onUserLeft = null;
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _agoraService.leaveChannel();
    _resetAgoraHandlers();
    return super.close();
  }
}
