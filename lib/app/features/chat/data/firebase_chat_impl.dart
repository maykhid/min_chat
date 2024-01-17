import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_interface.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/utils/participants_x.dart';
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
  Future<Conversation> startConversation({
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

        final conversationDocument =
            _firebaseFirestore.collection('conversations').doc();

        final docId = conversationDocument.id;

        final recipientUser = MinChatUser.fromMap(recipient);


        final conversation = Conversation(
          participants: [recipientUser, currentUser],
          initiatedBy: currentUser.id,
          initiatedAt: DateTime.now(),
          lastUpdatedAt: DateTime.now(),
          documentId: docId,
          participantsIds: [recipientUser.id, currentUser.id],
        );

        await conversationDocument.set(conversation.toMap());
        return conversation;
      } else {
        throw Exception('User not found!');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> sendMessage({
    required Message message,
    required String id,
  }) async {
    try {
      // generate unique docId for the shared conversation
      final docId = id;

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
    required String id,
  }) async {
    try {
      // generate unique docId for the shared conversation
      final docId = id;

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
  Future<void> sendGroupMessage({
    required GroupMessage message,
    required String id,
  }) async {
    try {
      // unique docId for the group conversation
      final docId = id;

      // recipient and sender conversation document
      final conversationDocument =
          _firebaseFirestore.collection('group-conversations').doc(docId);

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
  Future<void> sendGroupVoiceMessage({
    required GroupMessage message,
    required String filePath,
    required String id,
  }) async {
    try {
      //  unique docId for the group conversation
      final docId = id;

      // group conversation document
      final conversationDocument =
          _firebaseFirestore.collection('group-conversations').doc(docId);

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
    required String id,
  }) =>
      _firebaseFirestore
          .collection('conversations')
          .doc(id)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => Message.fromMap(doc.data()))
                .toList(),
          );

  @override
  Stream<List<GroupMessage>> groupMessageStream({
    required String id,
  }) =>
      _firebaseFirestore
          .collection('group-conversations')
          .doc(id)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => GroupMessage.fromMap(doc.data()))
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

  @override
  Stream<List<GroupConversation>> groupConversationStream({
    required String userId,
  }) =>
      _firebaseFirestore
          .collection('group-conversations')
          .where(
            'participantsIds',
            arrayContains: userId,
          )
          .orderBy('lastUpdatedAt', descending: true)
          .snapshots()
          .map(
            (querySnapshot) => querySnapshot.docs
                .map((doc) => GroupConversation.fromMap(doc.data()))
                .toList(),
          );

  @override
  Future<List<MinChatUser>> getConversers({required String userId}) async {
    try {
      // get all conversations where current user is part of
      final conversationsRef = await _firebaseFirestore
          .collection('conversations')
          .where(
            'participantsIds',
            arrayContains: userId,
          )
          .get();

      final conversationDocs = conversationsRef.docs;

      // all of this user conversations
      final conversations = conversationDocs
          .map(
            (conversationSnapshot) =>
                Conversation.fromMap(conversationSnapshot.data()),
          )
          .toList();

      // users who partook in the conversations i.e conversers
      final users = conversations
          .map(
            (conversation) => conversation.participants
                .extrapolateParticipantByCurrentUserId(userId),
          )
          .toList();

      return users;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<GroupConversation> startAGroupConversation({
    required GroupConversation conversation,
  }) async {
    try {
      // create a conversation document
      final groupConversationDoc =
          _firebaseFirestore.collection('group-conversations').doc();

      final conversationMap = conversation.toMap()
        ..addAll({'documentId': groupConversationDoc.id});

      // add a conversation
      await groupConversationDoc.set(
        conversationMap,
      );

      // print(conversationMap.toString());
      return GroupConversation.fromMap(conversationMap);
    } catch (e) {
      throw Exception(e);
    }
  }
}
