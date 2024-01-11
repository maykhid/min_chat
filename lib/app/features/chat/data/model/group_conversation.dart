import 'package:equatable/equatable.dart';
import 'package:min_chat/app/features/chat/data/model/conversation.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';

class GroupConversation extends SortableConversation with EquatableMixin{
  GroupConversation({
    required this.initiatedBy,
    required this.initiatedAt,
    required this.lastUpdatedAt,
    required this.groupName,
    required this.participantsIds,
    this.documentId,
    this.lastMessage,
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

  final String initiatedBy;
  final DateTime initiatedAt;
  @override
  final DateTime lastUpdatedAt;
  final List<String> participantsIds;
  final String groupName;
  final GroupMessage? lastMessage;
  final String? documentId;

  Map<String, dynamic> toMap() {
    return {
      'initiatedBy': initiatedBy,
      'initiatedAt': initiatedAt.millisecondsSinceEpoch,
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'participantsIds': participantsIds,
      'groupName': groupName,
      'documentId': documentId,
      'lastMessage': lastMessage?.toMap(),
    };
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
