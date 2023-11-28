import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/core/utils/string_x.dart';

class FirebaseChat implements IChat {
  FirebaseChat({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<void> startConversation({
    required String recipientMidOrEmail,
    required String senderMid,
  }) async {
    try {
      late final QuerySnapshot<Map<String, dynamic>> userDocument;

      if (recipientMidOrEmail.isEmail) {
        userDocument = await _firebaseFirestore
            .collection('users')
            .where(
              'email',
              isEqualTo: recipientMidOrEmail,
            )
            .get();
      } else {
        userDocument = await _firebaseFirestore
            .collection('users')
            .where(
              'mID',
              isEqualTo: recipientMidOrEmail,
            )
            .get();
      }

      if (userDocument.docs.isNotEmpty) {
        final conversationDocument =
            _firebaseFirestore.collection('conversations').doc();

        final recipient = userDocument.docs.first.data();

        await _firebaseFirestore
            .collection('chats')
            .doc(conversationDocument.id)
            .set({
          'participants': [recipient['mID'], senderMid],
        });
      } else {
        throw Exception('User not found!');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
