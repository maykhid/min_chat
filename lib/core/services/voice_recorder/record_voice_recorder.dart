import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/core/data/model/result.dart';
import 'package:min_chat/core/services/voice_recorder/voice_recorder.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

// ignore: comment_references
/// A voice recorder impl using the [record] package.
///
///
@Injectable(as: VoiceRecorder)
class RecordVoiceRecorder implements VoiceRecorder {
  RecordVoiceRecorder({
    required AudioRecorder audioRecorder,
    required AudioPlayer audioPlayers,
  })  : _audioRecorder = audioRecorder,
        _audioPlayers = audioPlayers {
    _initListeners();
  }

  final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayers;

  RecordingStatus _recordingState = RecordingStatus.uninitialized;
  String? _recordingPath;

  final StreamController<RecordingStatus> _recordingStateController =
      StreamController<RecordingStatus>.broadcast();

  void _initListeners() {
    _audioPlayers.onPlayerStateChanged.listen(_changeAudioPlayState);
    _audioRecorder.onStateChanged().listen(_changeRecoderStatus);
  }

  void _changeAudioPlayState(PlayerState playerState) {
    switch (playerState) {
      case PlayerState.completed:
        _recordingState = RecordingStatus.playbackComplete;
        _recordingStateController.add(_recordingState);

      case PlayerState.playing:
        _recordingState = RecordingStatus.playback;
        _recordingStateController.add(_recordingState);

      case PlayerState.paused:
        _recordingState = RecordingStatus.playbackPaused;
        _recordingStateController.add(_recordingState);

      case PlayerState.stopped:
        _recordingState = RecordingStatus.playbackStopped;
        _recordingStateController.add(_recordingState);

      // ignore: no_default_cases
      default:
      // Handle other cases if needed
    }
  }

  void _changeRecoderStatus(RecordState recordState) {
    switch (recordState) {
      case RecordState.stop:
        _recordingState = RecordingStatus.stopped;
        _recordingStateController.add(_recordingState);
        return;
      case RecordState.pause:
        _audioRecorder.stop();
        _recordingState = RecordingStatus.stopped;
        _recordingStateController.add(_recordingState);
        return;
      case RecordState.record:
        _recordingState = RecordingStatus.recording;
        _recordingStateController.add(_recordingState);
        return;
    }
  }

  @override
  Future<Result<void>> pausePlayback() async {
    try {
      final response = await _audioPlayers.pause();
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Result<void>> playback({
    required String path,
    bool isUrl = false,
  }) async {
    try {
      final response = await _audioPlayers
          .play(isUrl ? UrlSource(path) : DeviceFileSource(path));
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Result<void>> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // const encoder = AudioEncoder.aacLc;

        const config = RecordConfig(numChannels: 1);

        final dir = await getApplicationDocumentsDirectory();
        final filePath = p.join(
          dir.path,
          'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );

        final response = await _audioRecorder.start(config, path: filePath);
        return Result.success(response);
      } else {
        return Result.failure(
          errorMessage: 'Grant app access to your Microphone.',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Result.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<Result<void>> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _recordingPath = path;

      // ignore: void_checks
      return Result.success(() {});
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  @override
  Future<void> disposeResources() async {
    await _audioPlayers.dispose();
    await _audioRecorder.dispose();
    _recordingState = RecordingStatus.uninitialized;
    _recordingStateController.add(_recordingState);
  }

  @override
  Stream<RecordingStatus> get recordingState =>
      _recordingStateController.stream;

  @override
  Future<Result<void>> stopPlayback() async {
    try {
      final response = await _audioPlayers.stop();
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  @override
  String? get recordingPath => _recordingPath;
}
