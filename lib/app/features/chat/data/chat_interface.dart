import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

abstract class IChat {
  /// Start chat with this [recipientMIdOrEmail]
  Future<Conversation> startConversation({
    required String recipientMIdOrEmail,
    required MinChatUser currentUser,
  });

  /// Send a text message
  Future<void> sendMessage({required Message message, required String id});

  /// Send a group text message
  Future<void> sendGroupMessage({
    required GroupMessage message,
    required String id,
  });
  
  /// Send a group voice message
  Future<void> sendGroupVoiceMessage({
    required GroupMessage message,
    required String filePath,
    required String id,
  });

  /// Send a voice message
  Future<void> sendVoiceMessage({
    required Message message,
    required String filePath,
     required String id,
  });

  /// A Stream of messages for a particular [Conversation]
  Stream<List<Message>> messageStream({
    required String id,
  });

  /// A Stream of messages for a particular [Conversation]
  Stream<List<GroupMessage>> groupMessageStream({
    required String id,
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
  Future<GroupConversation> startAGroupConversation({
    required GroupConversation conversation,
  });
}
