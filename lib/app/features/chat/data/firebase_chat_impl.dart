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

      // throw exception if user is trying to start conversation with
      // themself
      if (currentUser.mID == recipientMIdOrEmail ||
          currentUser.email == recipientMIdOrEmail) {
        throw Exception('You cannot chat with yourself.');
      }

      // user is trying to start conversation with a user with their email
      if (recipientMIdOrEmail.isEmail) {
        userDocument = await _firebaseFirestore
            .collection('users')
            .where(
              'email',
              isEqualTo: recipientMIdOrEmail,
            )
            .get();
      }
      // user is trying to start conversation with a user with their mID
      else {
        userDocument = await _firebaseFirestore
            .collection('users')
            .where(
              'mID',
              isEqualTo: recipientMIdOrEmail,
            )
            .get();
      }

      // start conversation if recipient data is found
      if (userDocument.docs.isNotEmpty) {
        final recipient = userDocument.docs.first.data();

        /// A unique way of creating a docId we can always point to;
        /// concatenate both user ids and sort.
        ///
        /// Note to self: Is sorting the chars really the best way?
        final docId = '${recipient['id']}${currentUser.id}'.sortChars();

        final conversationDocument =
            _firebaseFirestore.collection('conversations').doc(docId);

        final recipientUser = MinChatUser.fromMap(recipient);

        final conversationAsMap = {
          'participantsIds': [recipientUser.id, currentUser.id],
          'participants': [recipientUser.toMap(), currentUser.toMap()],
          'initiatedAt': Timestamp.now().millisecondsSinceEpoch,
          'initiatedBy': currentUser.id,
          'lastUpdatedAt': Timestamp.now().millisecondsSinceEpoch,
          'lastMessage': null,
        };

        await conversationDocument.set(conversationAsMap);
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
      // generate unique docId for the shared conversation
      final docId = '${message.recipientId}${message.senderId}'.sortChars();

      // recipient and sender conversation document
      final conversationDocument =
          _firebaseFirestore.collection('conversations').doc(docId);

      // recipient and sender messages collection
      final messageCollection = conversationDocument.collection('messages');

      final messageAsMap = message.toMap()
        ..addAll({
          'timestamp': Timestamp.now().millisecondsSinceEpoch,
          'status': pendingStatusFlag,
        });

      // add new message
      final messageRef = await messageCollection.add(
        messageAsMap,
      );

      // update message now with status [sent]
      await messageRef.update(
        messageAsMap
          ..addAll({
            'status': sentStatusFlag,
          }),
      );

      // update conversation lastUpdatedAt and lastMessage fields
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
      // generate unique docId for the shared conversation
      final docId = '${message.recipientId}${message.senderId}'.sortChars();

      // recipient and sender conversation document
      final conversationDocument =
          _firebaseFirestore.collection('conversations').doc(docId);

      // recipient and sender messages collection
      final messageCollection = conversationDocument.collection('messages');

      // add timestamp and status of message
      final messageAsMap = message.toMap()
        ..addAll({
          'timestamp': Timestamp.now().millisecondsSinceEpoch,
          'status': pendingStatusFlag,
        });

      // add new message
      final messageRef = await messageCollection.add(messageAsMap);

      // ref to new audio message
      final audioMessageRef = _firebaseStorage
          .ref()
          .child('voice-messages/${DateTime.now().millisecondsSinceEpoch}.m4a');

      // upload new audio message
      await audioMessageRef.putFile(File(filePath));

      // get url of audio
      final url = await audioMessageRef.getDownloadURL();

      // update message now with url path and status [sent]
      await messageRef.update(
        messageAsMap
          ..addAll({
            'url': url,
            'status': sentStatusFlag,
          }),
      );

      // update conversation lastUpdatedAt and lastMessage fields
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
                .map((doc) => Conversation.fromMap(doc.data()))
                .toList(),
          );
}
