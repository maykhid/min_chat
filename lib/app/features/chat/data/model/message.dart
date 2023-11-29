class Message {
  const Message({
    required this.senderMId,
    required this.recipientMId,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> doc) {
    return Message(
      senderMId: doc['senderMId'] as String,
      recipientMId: doc['recipientMId'] as String,
      message: doc['message'] as String,
      timestamp: doc['timestamp'] as int,
    );
  }
  final String senderMId;
  final String recipientMId;
  final String message;
  final int timestamp;

  Map<String, dynamic> toMap() {
    return {
      'senderMId': senderMId,
      'recipientMId': recipientMId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
