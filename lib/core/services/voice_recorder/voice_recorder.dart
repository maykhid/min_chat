import 'package:min_chat/core/data/model/result.dart';

abstract class VoiceRecorder {
  Future<Result<void>> startRecording();
  Future<Result<void>> stopRecording();
  Future<Result<void>> playback({
    required String path,
    bool isUrl = false,
  });
  Future<Result<void>> pausePlayback();
  Future<Result<void>> stopPlayback();
  Stream<RecordingStatus> get recordingState;
  String? get recordingPath;
  void disposeResources();
}

enum RecordingStatus {
  uninitialized,
  recording,
  playback,
  playbackPaused,
  playbackComplete,
  playbackStopped,
  stopped;
  // pause (for future versions that will feature pausing recordings)
}
