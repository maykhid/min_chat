part of 'voice_note_cubit.dart';

abstract class VoiceNoteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnknownState extends VoiceNoteState {}

class RecordingState extends VoiceNoteState {}

class StoppedState extends VoiceNoteState {}

class PlaybackState extends VoiceNoteState {}

class PlaybackCompleteState extends VoiceNoteState {}

class PlaybackPausedState extends VoiceNoteState {}

class PlaybackStoppedState extends VoiceNoteState {}

class ErrorState extends VoiceNoteState {
  ErrorState({this.errorMessage});

  final String? errorMessage;
}
