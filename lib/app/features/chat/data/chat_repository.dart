import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/data/user_dao.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/data/model/result.dart';

@singleton
class ChatRepository {
  ChatRepository({
    required IChat chatInterface,
    required UserDao userDao,
  })  : _chatInterface = chatInterface,
        _userDao = userDao;

  final IChat _chatInterface;
  final UserDao _userDao;

  Future<Result<MinChatUser>> startConversation({
    required String recipientMIdOrEmail,
    required String senderMId,
  }) async {
    try {
      final response = await _chatInterface.startConversation(
        recipientMIdOrEmail: recipientMIdOrEmail,
        currentUser: _userDao.readUser(),
      );
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  Future<Result<void>> sendMessage({
    required Message message,
  }) async {
    try {
      final response = await _chatInterface.sendMessage(
        message: message,
      );
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  Stream<List<Message>> messageStream({
    required String recipientId,
    required String senderId,
  }) =>
      _chatInterface.messageStream(
        senderId: senderId,
        recipientId: recipientId,
      );

  Stream<List<Conversation>> allUserConversations({required String userId}) =>
      _chatInterface.conversationStream(userId: userId);
}
