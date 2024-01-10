import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.participants,
    required this.initiatedBy,
    required this.initiatedAt,
    required this.lastUpdatedAt,
     this.participantsIds,
    this.lastMessage,
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
    );
  }

  final List<MinChatUser> participants;
  final String initiatedBy;
  final DateTime initiatedAt;
  final DateTime lastUpdatedAt;
  final List<String>? participantsIds;
  final Message? lastMessage;

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
