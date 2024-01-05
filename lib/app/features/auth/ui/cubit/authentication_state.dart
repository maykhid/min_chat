part of 'authentication_cubit.dart';

final class AuthenticationState extends Equatable {
  const AuthenticationState._({
    required this.status,
    this.user = MinChatUser.empty,
  });

  const AuthenticationState.authenticated(MinChatUser user)
      : this._(
          user: user,
          status: AuthenticationStatus.authenticated,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final MinChatUser user;

  @override
  List<Object> get props => [status, user];
}
