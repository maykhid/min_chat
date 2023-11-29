import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/data/model/result.dart';

@singleton
class ChatRepository {
  ChatRepository({
    required IChat chatInterface,
  }) : _chatInterface = chatInterface;

  final IChat _chatInterface;

  Future<Result<AuthenticatedUser>> startConversation({
    required String recipientMIdOrEmail,
    required String senderMId,
  }) async {
    try {
      final response = await _chatInterface.startConversation(
        recipientMIdOrEmail: recipientMIdOrEmail,
        senderMId: senderMId,
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
}
