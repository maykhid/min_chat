import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

class GroupMessage extends BaseMessage {
  GroupMessage({
    required super.senderId,
    required super.recipientId,
    required super.message,
    required this.senderInfo,
    super.status,
    super.messageType,
    super.timestamp,
    super.url,
  });

  factory GroupMessage.fromMap(Map<String, dynamic> doc) {
    return GroupMessage(
      senderId: doc['senderId'] as String,
      recipientId: doc['recipientId'] as String,
      message: doc['message'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int),
      senderInfo:
          MinChatUser.fromMap(doc['senderInfo'] as Map<String, dynamic>),
      status: doc['status'] as String?,
      messageType: doc['messageType'] as String?,
      url: doc['url'] as String?,
    );
  }
  final MinChatUser senderInfo;

  @override
  Map<String, dynamic> toMap() {
    final baseMap = {
      'senderId': senderId,
      'recipientId': recipientId,
      'message': message,
      'timestamp': timestamp?.millisecondsSinceEpoch,
      'messageType': messageType,
      'status': status,
      'url': url,
    };

    return {...baseMap, ...additionalInfo()};
  }

  @override
  Map<String, dynamic> additionalInfo() {
    return {'senderInfo': senderInfo.toMap()};
  }
}
