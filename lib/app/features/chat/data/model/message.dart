import 'package:min_chat/app/features/chat/data/model/group_message.dart';

abstract class BaseMessage {
  BaseMessage({
    required this.senderId,
    required this.recipientId,
    required this.message,
    this.status,
    this.messageType,
    this.timestamp,
    this.url,
  });

  factory BaseMessage.fromMap(Map<String, dynamic> doc) {
    // Create an instance of the subclass if 'senderInfo' is present
    if (doc['senderInfo'] != null) {
      return GroupMessage.fromMap(doc);
    }

    return Message.fromMap(doc);
  }

  final String senderId;
  final String recipientId;
  final String message;
  final String? status;
  final String? messageType;
  final DateTime? timestamp;
  final String? url;

  // Abstract method to be implemented by subclasses
  Map<String, dynamic> toMap();

  // Method to be overridden by subclasses to include extra information
  Map<String, dynamic> additionalInfo() {
    return {};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Message extends BaseMessage {
  Message({
    required super.senderId,
    required super.recipientId,
    required super.message,
    super.status,
    super.messageType,
    super.timestamp,
    super.url,
  });

  factory Message.fromMap(Map<String, dynamic> doc) {
    return Message(
      senderId: doc['senderId'] as String,
      recipientId: doc['recipientId'] as String,
      message: doc['message'] as String,
      timestamp: doc['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int)
          : null,
      status: doc['status'] as String?,
      messageType: doc['messageType'] as String?,
      url: doc['url'] as String?,
    );
  }

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
}

const textMessageFlag = 'Text';
const audioMessageFlag = 'Audio';
const sentStatusFlag = 'Sent';
const pendingStatusFlag = 'Pending';

extension MessageX on BaseMessage {
  bool isMessageFromCurrentUser(String currentUserId) =>
      senderId == currentUserId;
}
