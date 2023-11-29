import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

abstract class IChat {
  /// start chat with this [recipientMIdOrEmail]
  Future<AuthenticatedUser> startConversation({
    required String recipientMIdOrEmail,
    required String senderMId,
  });

  Future<void> sendMessage({required Message message});
}
