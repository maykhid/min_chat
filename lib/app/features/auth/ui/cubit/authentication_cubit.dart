
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/auth/data/authentication_repository.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/core/di/di.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    AuthenticationRepository? authenticationRepository,
  })  : _authenticationRepository =
            authenticationRepository ?? locator<AuthenticationRepository>(),
        super(const AuthenticationState.authenticated()) {
    authState();
  }

  final AuthenticationRepository _authenticationRepository;

  void authState() {
    if (_authenticationRepository.user.isEmpty) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      emit(const AuthenticationState.authenticated());
    }
  }

  AuthenticatedUser get user => _authenticationRepository.user;
}

enum AuthenticationStatus {
  authenticated,
  unAuthenticated;
}
