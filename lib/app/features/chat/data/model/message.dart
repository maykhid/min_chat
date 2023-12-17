class Message {
  const Message({
    required this.senderId,
    required this.recipientId,
    required this.message,
    this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> doc) => Message(
        senderId: doc['senderId'] as String,
        recipientId: doc['recipientId'] as String,
        message: doc['message'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int),
      );

  final String senderId;
  final String recipientId;
  final String message;
  final DateTime? timestamp;

  Map<String, dynamic> toMap() => {
        'senderId': senderId,
        'recipientId': recipientId,
        'message': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
}

extension MessageX on Message {
  bool isFromCurrentUser(String currentUserId) => senderId == currentUserId;
}
