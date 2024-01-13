import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/core/di/di.dart';

part 'start_groupchat_state.dart';

class StartGroupchatCubit extends Cubit<StartGroupchatState> {
  StartGroupchatCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(const StartGroupchatInitial([]));

  final ChatRepository _chatRepository;

  // List<MinChatUser> _selectedParticipants = [];

  List<MinChatUser> selectedParticipants = [];

  // set selectedParticipants(List<MinChatUser> participants) {
  //   selectedParticipants = participants;
  //   print(selectedParticipants);
  // }

  Future<void> fetchConversers({required String userId}) async {
    final response = await _chatRepository.getConversers(userId: userId);

    if (response.isFailure) {
      emit(ErrorState(const [], errorMessage: response.errorMessage));
    } else {
      emit(GotConversersState(response.data ?? []));
    }
  }

  Future<void> startGroupChat({
    required GroupConversation groupConversation,
  }) async {
    emit(CreatingGroupChatState(state.conversers));

    final response = await _chatRepository.startAGroupConversation(
      conversation: groupConversation,
    );

    if (response.isFailure) {
      emit(ErrorState(state.conversers, errorMessage: response.errorMessage));
    } else {
     
      emit(
        GroupChatCreatedState(
          state.conversers,
          groupConversation: response.data!,
        ),
      );
    }
  }
}
