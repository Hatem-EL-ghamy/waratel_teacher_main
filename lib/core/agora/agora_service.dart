import 'package:waratel_app/core/networking/api_constants.dart';
 import 'package:agora_rtc_engine/agora_rtc_engine.dart';

/// خدمة Agora المشتركة للمكالمات وغرف المقرأة
class AgoraService {
  RtcEngine? _engine;

  RtcEngine get engine {
    assert(_engine != null, 'AgoraService: call initialize() first');
    return _engine!;
  }

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Callbacks
  void Function(int uid)? onUserJoined;
  void Function(int uid)? onUserLeft;
  void Function(String error)? onError;

  /// تهيئة المحرك مرة واحدة فقط
  Future<void> initialize() async {
    if (_isInitialized) return;

    _engine = createAgoraRtcEngine();

    await _engine!.initialize(const RtcEngineContext(
      appId: ApiConstants.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      audioScenario: AudioScenarioType.audioScenarioGameStreaming,
    ));

    // ضبط الدور كمذيع لليتمكن من الإرسال
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    // تفعيل الفيديو
    await _engine!.enableVideo();
    await _engine!.enableAudio();

    // ضبط إعدادات الفيديو
    await _engine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 600,
      ),
    );

    // تسجيل الأحداث
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          // تم الانضمام بنجاح
        },
        onUserJoined: (connection, uid, elapsed) {
          onUserJoined?.call(uid);
        },
        onUserOffline: (connection, uid, reason) {
          onUserLeft?.call(uid);
        },
        onError: (err, msg) {
          onError?.call(msg);
        },
      ),
    );

    _isInitialized = true;
  }

  /// الانضمام لقناة
  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
  }) async {
    await initialize();
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  /// الانضمام لقناة صوت فقط (للمقرأة الصوتية)
  Future<void> joinAudioChannel({
    required String token,
    required String channelName,
    required int uid,
  }) async {
    await initialize();
    await _engine!.disableVideo();
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: false,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: false,
      ),
    );
  }

  /// مغادرة القناة
  Future<void> leaveChannel() async {
    if (_isInitialized) {
      await _engine!.leaveChannel();
    }
  }

  /// كتم/فتح الميكروفون المحلي
  Future<void> muteLocalMic(bool mute) async {
    await _engine!.muteLocalAudioStream(mute);
  }

  /// تفعيل/إيقاف الكاميرا المحلية
  Future<void> enableLocalVideo(bool enable) async {
    if (enable) {
      await _engine!.enableLocalVideo(true);
    } else {
      await _engine!.enableLocalVideo(false);
    }
  }

  /// تدمير المحرك بالكامل عند الخروج
  Future<void> dispose() async {
    if (_isInitialized) {
      onUserJoined = null;
      onUserLeft = null;
      onError = null;
      await _engine!.leaveChannel();
      await _engine!.release();
      _isInitialized = false;
      _engine = null;
    }
  }
}
