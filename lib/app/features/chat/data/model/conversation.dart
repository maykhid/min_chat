import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

/// classes that 
abstract class SortableConversation {
  DateTime get lastUpdatedAt;
}

class Conversation extends SortableConversation with EquatableMixin {
  Conversation({
    required this.participants,
    required this.initiatedBy,
    required this.initiatedAt,
    required this.lastUpdatedAt,
    this.participantsIds,
    this.lastMessage,
    this.documentId,
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

  final List<MinChatUser> participants;
  final String initiatedBy;
  final DateTime initiatedAt;
  @override
  final DateTime lastUpdatedAt;
  final List<String>? participantsIds;
  final Message? lastMessage;
  final String? documentId;

  Map<String, dynamic> toMap() {
    return {
      'initiatedAt': initiatedAt.millisecondsSinceEpoch,
      'initiatedBy': initiatedBy,
      'participants': participants.map((user) => user.toMap()).toList(),
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'participantsIds': participantsIds,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  @override
  List<Object?> get props =>
      [participants, initiatedAt, initiatedBy, lastUpdatedAt, lastMessage];
}
