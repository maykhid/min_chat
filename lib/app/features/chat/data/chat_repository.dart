import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/core/data/model/result.dart';

class ChatRepository {
  ChatRepository({
    required IChat chatInterface,
    required AuthenticatedUser user,
  })  : _chatInterface = chatInterface,
        _user = user;

  final IChat _chatInterface;
  final AuthenticatedUser _user;

  Future<Result<void>> startConversation({
    required String recipientMidOrEmail,
  }) async {
    try {
      final response = await _chatInterface.startConversation(
        recipientMidOrEmail: recipientMidOrEmail,
        senderMid: _user.mID!,
      );
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }
}
