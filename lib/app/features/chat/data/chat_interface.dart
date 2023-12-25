import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

abstract class IChat {
  /// start chat with this [recipientMIdOrEmail]
  Future<MinChatUser> startConversation({
    required String recipientMIdOrEmail,
    required MinChatUser currentUser,
  });

  Future<void> sendMessage({required Message message});

  Future<void> sendVoiceMessage({
    required Message message,
    required String filePath,
  });

  Stream<List<Message>> messageStream({
    required String recipientId,
    required String senderId,
  });

  Stream<List<Conversation>> conversationStream({required String userId});
}
