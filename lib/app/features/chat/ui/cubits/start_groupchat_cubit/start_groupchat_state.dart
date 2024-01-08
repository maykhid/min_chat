part of 'start_groupchat_cubit.dart';

sealed class StartGroupchatState extends Equatable {
  const StartGroupchatState();

  @override
  List<Object> get props => [];
}

final class StartGroupchatInitial extends StartGroupchatState {}

final class GotConversersState extends StartGroupchatState {
  const GotConversersState({
    this.conversers = const [],
  });

  final List<MinChatUser> conversers;
}

final class CreatingGroupChatState extends StartGroupchatState {}

final class GroupChatCreatedState extends StartGroupchatState {}

class ErrorState extends StartGroupchatState {
  const ErrorState({this.errorMessage});

  final String? errorMessage;
}
