import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/group_conversation.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

/// classes that
abstract class BaseConversation {
  BaseConversation({
    required this.participants,
    required this.initiatedBy,
    required this.initiatedAt,
    required this.lastUpdatedAt,
    this.participantsIds,
    this.lastMessage,
    this.documentId,
  });

  factory BaseConversation.fromMap(Map<String, dynamic> map) {
    if (map['groupName'] != null) {
      return GroupConversation.fromMap(map);
    }
    return Conversation.fromMap(map);
  }

  final List<MinChatUser> participants;
  final String initiatedBy;
  final DateTime initiatedAt;
  final DateTime lastUpdatedAt;
  final List<String>? participantsIds;
  final BaseMessage? lastMessage;
  final String? documentId;

  // Abstract method to be implemented by subclasses
  Map<String, dynamic> toMap();

  // Method to be overridden by subclasses to include extra information
  Map<String, dynamic> additionalInfo() {
    return {};
  }
}

class Conversation extends BaseConversation with EquatableMixin {
  Conversation({
    required super.participants,
    required super.initiatedBy,
    required super.initiatedAt,
    required super.lastUpdatedAt,
    super.participantsIds,
    super.lastMessage,
    super.documentId,
  });

  factory Conversation.fromMap(Map<String, dynamic> data) {
    // final data = doc.data()! as Map<String, dynamic>;
    final participantsData = data['participants'] as List<dynamic>;
    // final participantsIds = data['participantsIds'] as List<String>;

    final participants = participantsData
        .map((e) => MinChatUser.fromMap(e as Map<String, dynamic>))
        .toList();

    final message = data['lastMessage'] != null
        ? Message.fromMap(data['lastMessage'] as Map<String, dynamic>)
        : null;

    return Conversation(
      initiatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['initiatedAt'] as int),
      initiatedBy: data['initiatedBy'] as String,
      participants: participants,
      lastUpdatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedAt'] as int),
      lastMessage: message,
      documentId: data['documentId'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final baseMap = {
      'initiatedAt': initiatedAt.millisecondsSinceEpoch,
      'initiatedBy': initiatedBy,
      'participants': participants.map((user) => user.toMap()).toList(),
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'participantsIds': participantsIds,
      'documentId': documentId,
      'lastMessage': lastMessage?.toMap(),
    };
    return {...baseMap, ...additionalInfo()};
  }

  @override
  List<Object?> get props =>
      [participants, initiatedAt, initiatedBy, lastUpdatedAt, lastMessage];
}
