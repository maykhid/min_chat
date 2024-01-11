import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

abstract class IChat {
  /// Start chat with this [recipientMIdOrEmail]
  Future<MinChatUser> startConversation({
    required String recipientMIdOrEmail,
    required MinChatUser currentUser,
  });

  /// Send a text message
  Future<void> sendMessage({required Message message});

  /// Send a voice message
  Future<void> sendVoiceMessage({
    required Message message,
    required String filePath,
  });

  /// A Stream of messages for a particular [Conversation]
  Stream<List<Message>> messageStream({
    required String recipientId,
    required String senderId,
  });

  /// A Stream of this user [Conversation]s
  Stream<List<Conversation>> conversationStream({required String userId});

   /// A Stream of this user [GroupConversation]s
  Stream<List<GroupConversation>> groupConversationStream({
    required String userId,
  });

  /// Get the list of all users that the current [MinChatUser] converses with
  Future<List<MinChatUser>> getConversers({required String userId});

  /// Start a group conversation
  Future<void> startAGroupConversation({
    required GroupConversation conversation,
  });
}
