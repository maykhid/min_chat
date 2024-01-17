import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class GetConversationsUseCase {
  GetConversationsUseCase({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  final ChatRepository _chatRepository;

  Stream<List<BaseConversation>> conversationStreams({
    required String userId,
  }) {
    final conversationStream =
        _chatRepository.conversationStream(userId: userId);
    final groupConversationStream =
        _chatRepository.groupConversationStream(userId: userId);

    return Rx.combineLatest2<List<Conversation>, List<GroupConversation>,
        List<BaseConversation>>(
      conversationStream,
      groupConversationStream,
      (conversations, groupConversations) {
        final combinedList = <BaseConversation>[
          ...conversations,
          ...groupConversations,
        ]..sort((a, b) => b.lastUpdatedAt.compareTo(a.lastUpdatedAt));
        return combinedList;
      },
    );
  }
}
