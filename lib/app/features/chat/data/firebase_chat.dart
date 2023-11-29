import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/utils/string_x.dart';

@Singleton(as: IChat)
class FirebaseChat implements IChat {
  FirebaseChat({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<AuthenticatedUser> startConversation({
    required String recipientMIdOrEmail,
    required String senderMId,
  }) async {
    try {
      late final QuerySnapshot<Map<String, dynamic>> userDocument;

      if (recipientMIdOrEmail.isEmail) {
        userDocument = await _firebaseFirestore
            .collection('users')
            .where(
              'email',
              isEqualTo: recipientMIdOrEmail,
            )
            .get();
      } else {
        userDocument = await _firebaseFirestore
            .collection('users')
            .where(
              'mID',
              isEqualTo: recipientMIdOrEmail,
            )
            .get();
      }

      if (userDocument.docs.isNotEmpty) {
        final recipient = userDocument.docs.first.data();

        final docId = '${recipient['mID']}$senderMId';

        final conversationDocument =
            _firebaseFirestore.collection('conversations').doc(docId);

        await conversationDocument.set({
          'participants': [recipient['mID'], senderMId],
        });
        return AuthenticatedUser.fromMap(recipient);
      } else {
        throw Exception('User not found!');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> sendMessage({required Message message}) async {
    try {
      final docId = '${message.recipientMId}${message.senderMId}';
      final conversationDocument =
          _firebaseFirestore.collection('conversations').doc(docId);

      final messageDocument = conversationDocument.collection('messages').doc();

      await messageDocument.set(message.toMap());
    } catch (e) {
      throw Exception(e);
    }
  }
}
