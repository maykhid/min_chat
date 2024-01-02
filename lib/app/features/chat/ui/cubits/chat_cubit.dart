import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/di/di.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(ChatState.empty());

  final ChatRepository _chatRepository;

  void initMessageListener({
    required String recipientId,
    required String senderId,
  }) {
    _chatRepository
        .messageStream(recipientId: recipientId, senderId: senderId)
        .listen(updateChats)
        .onError(
          (_) => updateError(
            '''Error: Payload validation failed. Check for issues with data types, missing fields, or incorrect values in your payload.''',
          ),
        );
  }

  void updateChats(List<Message> chats) {
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
    List<Message> chats,
  ) =>
      ChatState(chats: chats, errorMessage: errorMessage);

  bool get hasError => errorMessage != null;

  final List<Message> chats;
  final String? errorMessage;
}
