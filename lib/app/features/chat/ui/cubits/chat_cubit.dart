import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/di/di.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(ChatState.empty());

  final ChatRepository _chatRepository;

  void initMessageListener({
    required String id,
  }) {
    _chatRepository
        .messageStream(id: id)
        .listen(updateChats)
        .onError(
          (_) => updateError(
            '''Error: An error occured on message stream''',
          ),
        );
  }

  void initGroupMessageListener({
    required String id,
  }) {
    _chatRepository.groupMessageStream(id: id).listen(updateGroupChats).onError(
          (_) => updateError(
            '''Error: An error occured on message stream''',
          ),
        );
  }

  void updateChats(List<Message> chats) {
    if (!isClosed) {
      emit(ChatState(chats: chats));
    }
  }

  void updateGroupChats(List<GroupMessage> chats) {
    if (!isClosed) {
      emit(ChatState(chats: chats));
    }
  }

  void updateError(String message) =>
      emit(ChatState.withError(message, state.chats));

  @override
  Future<void> close() {
    // Cancel any subscriptions or resources
    return super.close();
  }
}

class ChatState {
  ChatState({required this.chats, this.errorMessage});

  factory ChatState.empty() => ChatState(chats: []);
  factory ChatState.withError(
    String errorMessage,
    List<BaseMessage> chats,
  ) =>
      ChatState(chats: chats, errorMessage: errorMessage);

  bool get hasError => errorMessage != null;

  final List<BaseMessage> chats;
  final String? errorMessage;
}
