import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.participants,
    required this.initiatedBy,
    required this.initiatedAt,
    required this.lastUpdatedAt,
  });

  factory Conversation.fromMap(Map<String, dynamic> data) {
    // final data = doc.data()! as Map<String, dynamic>;
    final participantsData = data['participants'] as List<Map<String, dynamic>>;

    final participants = participantsData.map(MinChatUser.fromMap).toList();

    return Conversation(
      initiatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['initiatedAt'] as int),
      initiatedBy: data['initiatedBy'] as String,
      participants: participants,
      lastUpdatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedAt'] as int),
    );
  }

  final List<MinChatUser> participants;
  final String initiatedBy;
  final DateTime initiatedAt;
  final DateTime lastUpdatedAt;

  Map<String, dynamic> toMap() {
    return {
      'initiatedAt': initiatedAt,
      'initiatedBy': initiatedBy,
      'participants': participants.map((user) => user.toMap()).toList(),
      'lastUpdatedAt': lastUpdatedAt,
    };
  }

  @override
  List<Object?> get props =>
      [participants, initiatedAt, initiatedBy, lastUpdatedAt];
}
