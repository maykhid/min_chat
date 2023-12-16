import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/core/di/di.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(MessagesState.empty());

  final ChatRepository _chatRepository;

  void initConversationListener({required String userId}) {
    _chatRepository
        .allUserConversations(userId: userId)
        .listen(updateConversation)
        .onError(
          (_) => updateError(
            '''Error: Payload validation failed. Check for issues with data types, missing fields, or incorrect values in your payload.''',
          ),
        );
  }

  void updateConversation(List<Conversation> conversations) {
    // print(conversations);
    // final currentState = state;
    // final updatedConversations = currentState.conversations
    //   ..addAll(conversations);
    emit(MessagesState(conversations: conversations));
  }

  void updateError(String message) =>
      emit(MessagesState.withError(message, state.conversations));

  @override
  Future<void> close() {
    // Cancel any subscriptions or resources
    return super.close();
  }
}

class MessagesState {
  MessagesState({required this.conversations, this.errorMessage});

  factory MessagesState.empty() => MessagesState(conversations: []);
  factory MessagesState.withError(
    String errorMessage,
    List<Conversation> conversations,
  ) =>
      MessagesState(conversations: conversations, errorMessage: errorMessage);

  bool get hasError => errorMessage != null;

  final List<Conversation> conversations;
  final String? errorMessage;
}
