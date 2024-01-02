import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/core/di/di.dart';
import 'package:min_chat/core/services/voice_recorder/voice_recorder.dart';

part 'voice_note_state.dart';

class VoiceNoteCubit extends Cubit<VoiceNoteState> {
  VoiceNoteCubit({
    VoiceRecorder? voiceRecorder,
  })  : _voiceRecorder = voiceRecorder ?? locator<VoiceRecorder>(),
        super(UnknownState()) {
    // listener updates
    _voiceRecorder.recordingState.listen((event) {
      if (event == RecordingStatus.playbackComplete) {
        emit(PlaybackCompleteState());
      }
      debugPrint(event.toString());
    });
  }

  //        {
  //   _voiceRecorder.recordingState.listen(_changeRecorderState);
  // }

  // void _changeRecorderState(RecordingStatus recordingStatus) {
  //   print(recordingStatus);
  //   switch (recordingStatus) {
  //     case RecordingStatus.playback:
  //       print('playing');

  //     case RecordingStatus.playbackComplete:
  //       emit(PlaybackCompleteState());
  //       emit(PlaybackStoppedState());
  //     case RecordingStatus.playbackPaused:
  //     // pausePlayback();
  //     case RecordingStatus.playbackStopped:
  //       emit(PlaybackStoppedState());
  //     case RecordingStatus.recording:
  //       print('recording');
  //     //   startRecording();

  //     case RecordingStatus.stopped:
  //       print('stopped');
  //     case RecordingStatus.uninitialized:
  //       emit(UnknownState());
  //   }
  // }

  final VoiceRecorder _voiceRecorder;

  String? get path => _voiceRecorder.recordingPath;

  Future<void> pausePlayback() async {
    final res = await _voiceRecorder.pausePlayback();

    if (res.isSuccess) {
      emit(PlaybackPausedState());
    } else {
      emit(ErrorState(errorMessage: res.errorMessage));
    }
  }

  Future<void> playback() async {
    final res = await _voiceRecorder.playback(
      path: path!,
    );

    if (res.isSuccess) {
      emit(PlaybackState());
    } else {
      emit(ErrorState(errorMessage: res.errorMessage));
    }
  }

  Future<void> startRecording() async {
    final res = await _voiceRecorder.startRecording();

    if (res.isSuccess) {
      emit(RecordingState());
    } else {
      emit(ErrorState(errorMessage: res.errorMessage));
    }
  }

  Future<void> stopRecording() async {
    final res = await _voiceRecorder.stopRecording();
    // path = res.data;

    if (res.isSuccess) {
      emit(StoppedState());
    } else {
      emit(ErrorState(errorMessage: res.errorMessage));
    }
  }

  Future<void> stopPlayback() async {
    final res = await _voiceRecorder.stopPlayback();

    if (res.isSuccess) {
      emit(PlaybackStoppedState());
    } else {
      emit(ErrorState(errorMessage: res.errorMessage));
    }
  }

  Future<void> dispose() => _voiceRecorder.disposeResources();

  @override
  Future<void> close() async {
    await dispose();
    return super.close();
  }
}
