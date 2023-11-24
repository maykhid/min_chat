part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    required this.status,
  });

  const AuthenticationState.authenticated()
      : this._(
          status: AuthenticationStatus.authenticated,
        );

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unAuthenticated);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
