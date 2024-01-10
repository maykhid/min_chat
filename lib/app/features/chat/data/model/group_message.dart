import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

class GroupMessage extends Message {
  const GroupMessage({
    required super.message,
    required super.messageType,
    required super.recipientId,
    required super.senderId,
    required this.senderInfo,
    super.status,
    super.timestamp,
    super.url,
  });

  factory GroupMessage.fromMap(Map<String, dynamic> doc) => GroupMessage(
        senderId: doc['senderId'] as String,
        recipientId: doc['recipientId'] as String,
        message: doc['message'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int),
        senderInfo: doc['senderInfo'] as MinChatUser,
        status: doc['status'] as String?,
        messageType: doc['messageType'] as String?,
        url: doc['url'] as String?,
      );
   /// sender info    
  final MinChatUser senderInfo;

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap['senderInfo'] = senderInfo;
    return baseMap;
  }
}
