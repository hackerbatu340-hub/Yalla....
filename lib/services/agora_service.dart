import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config.dart';

class AgoraService {
  RtcEngine? _engine;
  bool _initialized = false;

  /// Uzaktaki kullanıcının odoya katıldığını bildiren callback
  void Function(int remoteUid)? onUserJoined;
  void Function(int remoteUid)? onUserLeft;

  Future<void> init() async {
    if (_initialized) return;
    await [Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: Config.agoraAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    await _engine!.muteLocalAudioStream(false);

    _engine!.registerEventHandler(RtcEngineEventHandler(
      onUserJoined: (connection, remoteUid, elapsed) {
        onUserJoined?.call(remoteUid);
      },
      onUserOffline: (connection, remoteUid, reason) {
        onUserLeft?.call(remoteUid);
      },
    ));

    _initialized = true;
  }

  Future<void> join(String channelName, String uid) async {
    if (!_initialized) await init();
    await _engine!.joinChannel(
      token: Config.agoraToken,
      channelId: channelName,
      uid: int.tryParse(uid) ?? DateTime.now().millisecondsSinceEpoch % 100000,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        autoSubscribeAudio: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  Future<void> toggleMic(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  Future<void> leave() async {
    await _engine?.leaveChannel();
  }

  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
    _initialized = false;
  }
}
