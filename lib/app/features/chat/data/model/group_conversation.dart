import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';

class GroupConversation extends Conversation {
  const GroupConversation({
    required super.initiatedBy,
    required super.initiatedAt,
    required super.lastUpdatedAt,
    required super.participantsIds,
    required this.groupName,
    super.lastMessage,
  }) : super(
          participants: const [],
        );

  factory GroupConversation.fromMap(Map<String, dynamic> data) =>
      GroupConversation(
        initiatedBy: data['initiatedBy'] as String,
        initiatedAt:
            DateTime.fromMillisecondsSinceEpoch(data['initiatedAt'] as int),
        lastUpdatedAt:
            DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedAt'] as int),
        participantsIds: data['participantsIds'] as List<String>,
        groupName: data['groupName'] as String,
        lastMessage: data['lastMessage'] != null
            ? GroupMessage.fromMap(data['lastMessage'] as Map<String, dynamic>)
            : null,
      );

  final String groupName;

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap['groupName'] = groupName;
    return baseMap;
  }
}
