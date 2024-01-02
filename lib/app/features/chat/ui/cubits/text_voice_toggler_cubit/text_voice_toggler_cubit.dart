import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'text_voice_toggler_state.dart';

class TextVoiceTogglerCubit extends Cubit<TextVoiceTogglerState> {
  TextVoiceTogglerCubit() : super(TextState());

  void textVoiceToggle() {
    if (state is TextState) {
      emit(VoiceRecorderState());
    } else {
      emit(TextState());
    }
  }
}
