part of 'start_groupchat_cubit.dart';

sealed class StartGroupchatState extends Equatable {
  const StartGroupchatState(this.conversers);

  final List<MinChatUser> conversers;

  @override
  List<Object> get props => [conversers];
}

final class StartGroupchatInitial extends StartGroupchatState {
  const StartGroupchatInitial(super.conversers);
}

final class GotConversersState extends StartGroupchatState {
  const GotConversersState(super.conversers);
}

final class CreatingGroupChatState extends StartGroupchatState {
  const CreatingGroupChatState(super.conversers);
}

final class GroupChatCreatedState extends StartGroupchatState {
  const GroupChatCreatedState(
    super.conversers, {
    required this.groupConversation,
  });
  final GroupConversation groupConversation;
}

class ErrorState extends StartGroupchatState {
  const ErrorState(super.conversers, {this.errorMessage});

  final String? errorMessage;
}
