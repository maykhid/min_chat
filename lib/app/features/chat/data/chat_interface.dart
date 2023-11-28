abstract class IChat {
  /// start chat with this [recipientMidOrEmail]
  Future<void> startConversation({
    required String recipientMidOrEmail,
    required String senderMid,
  });
}
