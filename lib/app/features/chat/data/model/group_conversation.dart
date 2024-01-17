import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';

class GroupConversation extends BaseConversation with EquatableMixin {
  GroupConversation({
    required super.initiatedBy,
    required super.initiatedAt,
    required super.lastUpdatedAt,
    required this.groupName,
    required super.participantsIds,
    super.participants = const <MinChatUser>[],
    super.documentId,
    super.lastMessage,
  });

  factory GroupConversation.fromMap(Map<String, dynamic> data) {
    final message = data['lastMessage'] != null
        ? GroupMessage.fromMap(data['lastMessage'] as Map<String, dynamic>)
        : null;

    return GroupConversation(
      initiatedBy: data['initiatedBy'] as String,
      initiatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['initiatedAt'] as int),
      lastUpdatedAt:
          DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedAt'] as int),
      participantsIds:
          List<String>.from(data['participantsIds'] as List<dynamic>),
      groupName: data['groupName'] as String,
      documentId: data['documentId'] as String,
      lastMessage: message,
    );
  }

  final String groupName;

  @override
  Map<String, dynamic> toMap() {
    final baseMap = {
      'initiatedBy': initiatedBy,
      'initiatedAt': initiatedAt.millisecondsSinceEpoch,
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'participantsIds': participantsIds,
      'groupName': groupName,
      'documentId': documentId,
      'lastMessage': lastMessage?.toMap(),
    };
    return baseMap;
  }

  @override
  List<Object?> get props => [
        participantsIds,
        initiatedAt,
        initiatedBy,
        lastUpdatedAt,
        lastMessage,
        groupName,
        documentId,
      ];
}
