import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/core/di/di.dart';

part 'start_groupchat_state.dart';

class StartGroupchatCubit extends Cubit<StartGroupchatState> {
  StartGroupchatCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(StartGroupchatInitial());

  final ChatRepository _chatRepository;

  Future<void> fetchConversers({required String userId}) async {
    final response = await _chatRepository.getConversers(userId: userId);

    if (response.isFailure) {
      emit(ErrorState(errorMessage: response.errorMessage));
    } else {
      emit(GotConversersState(conversers: response.data ?? []));
    }
  }

  Future<void> startGroupChat() async {
    // final response = await _chatRepository.getConversers(userId: userId);

    // if (response.isFailure) {
    //   emit(ErrorState(errorMessage: response.errorMessage));
    // } else {
    //   emit(GotConversersState(conversers: response.data ?? []));
    // }
  }
}
