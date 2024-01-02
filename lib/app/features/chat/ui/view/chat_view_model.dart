import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/di/di.dart';

class ChatViewModel {
  ChatViewModel({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>();

  final ChatRepository _chatRepository;

  Stream<List<Message>> messageStream({
    required String recipientId,
    required String senderId,
  }) =>
      _chatRepository.messageStream(
        recipientId: recipientId,
        senderId: senderId,
      );
}
