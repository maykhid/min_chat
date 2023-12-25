class Message {
  const Message({
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.messageType,
    this.status,
    this.timestamp,
    this.url,
  });

  factory Message.fromMap(Map<String, dynamic> doc) => Message(
        senderId: doc['senderId'] as String,
        recipientId: doc['recipientId'] as String,
        message: doc['message'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int),
        status: doc['status'] as String?,
        messageType: doc['messageType'] as String?,
        url: doc['url'] as String?,
      );

  final String senderId;
  final String recipientId;
  final String message;
  final String? status;
  final String? messageType;
  final DateTime? timestamp;

  /// only available if message is media e.g audio
  final String? url;

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'recipientId': recipientId,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'messageType': messageType,
        'status': pendingStatusFlag,
        'url': null,
      };
}

const textMessageFlag = 'Text';
const audioMessageFlag = 'Audio';
const sentStatusFlag = 'Sent';
const pendingStatusFlag = 'Pending';

extension MessageX on Message {
  bool isFromCurrentUser(String currentUserId) => senderId == currentUserId;
}
