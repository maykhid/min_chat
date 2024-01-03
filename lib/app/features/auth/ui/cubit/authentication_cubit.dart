import 'dart:async';

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
        super(
          authenticationRepository!.user.isNotEmpty
              ? AuthenticationState.authenticated(
                  authenticationRepository.user,
                )
              : const AuthenticationState.unauthenticated(),
        ) {
    _initUserSubscription();
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<MinChatUser?> _userSubscription;

  void _initUserSubscription() {
    _userSubscription =
        _authenticationRepository.userSubscription.listen(_onUserChanged);
  }

  void _onUserChanged(MinChatUser? user) {
    if (user == null || user.isEmpty) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      emit(AuthenticationState.authenticated(_authenticationRepository.user));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

enum AuthenticationStatus {
  authenticated,
  unauthenticated;
}
