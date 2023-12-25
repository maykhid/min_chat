import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/utils/string_x.dart';

@Singleton(as: IChat)
class FirebaseChat implements IChat {
  FirebaseChat({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  @override
  Future<MinChatUser> startConversation({
    required String recipientMIdOrEmail,
    required MinChatUser currentUser,
  }) async {
    try {
      late final QuerySnapshot<Map<String, dynamic>> userDocument;

      if (currentUser.mID == recipientMIdOrEmail ||
          currentUser.email == recipientMIdOrEmail) {
        throw Exception('You cannot chat with yourself.');
      }

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

        final docId = '${recipient['id']}${currentUser.id}'.sortChars();

        final conversationDocument =
            _firebaseFirestore.collection('conversations').doc(docId);

        final recipientUser = MinChatUser.fromMap(recipient);

        // might add other necessary info later
        await conversationDocument.set({
          'participantsIds': [recipientUser.id, currentUser.id],
          'participants': [recipientUser.toMap(), currentUser.toMap()],
          'initiatedAt': Timestamp.now().millisecondsSinceEpoch,
          'initiatedBy': currentUser.id,
          'lastUpdatedAt': Timestamp.now().millisecondsSinceEpoch,
          'lastMessage': null,
        });
        return MinChatUser.fromMap(recipient);
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
      final docId = '${message.recipientId}${message.senderId}'.sortChars();
      final conversationDocument =
          _firebaseFirestore.collection('conversations').doc(docId);

      final messageCollection = conversationDocument.collection('messages');

      final messageAsMap = message.toMap()
        ..addAll({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageType': textMessageFlag,
          'status': pendingStatusFlag,
        });

      final messageRef = await messageCollection.add(
        messageAsMap,
      );

      // update message status
      await messageRef.update(
        messageAsMap
          ..addAll({
            'status': sentStatusFlag,
          }),
      );

      // update lastUpdatedAt field
      await conversationDocument.update({
        'lastUpdatedAt': Timestamp.now().millisecondsSinceEpoch,
        'lastMessage': messageAsMap,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> sendVoiceMessage({
    required Message message,
    required String filePath,
  }) async {
    try {
      final docId = '${message.recipientId}${message.senderId}'.sortChars();
      final conversationDocument =
          _firebaseFirestore.collection('conversations').doc(docId);

      final messageCollection = conversationDocument.collection('messages');

      final messageAsMap = message.toMap()
        ..addAll({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageType': audioMessageFlag,
          'status': pendingStatusFlag,
        });

      final messageRef = await messageCollection.add(messageAsMap);
      final audioMessageRef = _firebaseStorage
          .ref()
          .child('voice-messages/${DateTime.now().millisecondsSinceEpoch}.m4a');

      await audioMessageRef.putFile(File(filePath));
      final url = await audioMessageRef.getDownloadURL();

      await messageRef.update(
        messageAsMap
          ..addAll({
            'url': url,
            'status': sentStatusFlag,
          }),
      );

      await conversationDocument.update({
        'lastUpdatedAt': Timestamp.now().millisecondsSinceEpoch,
        'lastMessage': messageAsMap,
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Stream<List<Message>> messageStream({
    required String recipientId,
    required String senderId,
  }) =>
      _firebaseFirestore
          .collection('conversations')
          .doc('$recipientId$senderId'.sortChars())
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => Message.fromMap(doc.data()))
                .toList(),
          );

  @override
  Stream<List<Conversation>> conversationStream({required String userId}) =>
      _firebaseFirestore
          .collection('conversations')
          .where(
            'participantsIds',
            arrayContains: userId,
          )
          .orderBy('lastUpdatedAt', descending: true)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => Conversation.fromMap(doc.data()),
                )
                .toList(),
          );
}
