import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'text_voice_toggler_state.dart';

class TextVoiceTogglerCubit extends Cubit<TextVoiceTogglerState> {
  TextVoiceTogglerCubit() : super(TextState());

  void textVoiceToggle() {
    if (state is TextState) {
      emit(VoiceRecorderState());
    } else {

      // delay changing state to text state,
      // so short recorder control sounds
      // can play before disposing
      // (this is a temp solution)
      Future.delayed(
        const Duration(milliseconds: 700),
        () => emit(TextState()),
      );
    }
  }
}
