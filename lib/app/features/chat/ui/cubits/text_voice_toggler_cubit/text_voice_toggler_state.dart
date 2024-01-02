

part of 'text_voice_toggler_cubit.dart';

abstract class TextVoiceTogglerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoiceRecorderState extends TextVoiceTogglerState {}

class TextState extends TextVoiceTogglerState {}
