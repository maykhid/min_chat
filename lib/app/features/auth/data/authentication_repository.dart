import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/authentication_interface.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/data/user_dao.dart';
import 'package:min_chat/core/data/model/result.dart';

@singleton
class AuthenticationRepository {
  AuthenticationRepository({
    required IAuthentication authenticationInterface,
    required UserDao userDao,
  })  : _authenticationInterface = authenticationInterface,
        _userDao = userDao {
    _initializeBroadcast();
  }

  final IAuthentication _authenticationInterface;
  final UserDao _userDao;

  late StreamController<MinChatUser?> _userController;
  Stream<MinChatUser?> get userSubscription => _userController.stream;

  void _initializeBroadcast() {
    _userController = StreamController<MinChatUser?>.broadcast();
  }

  MinChatUser get user {
    if (_authenticationInterface.authenticatedUser.isNotEmpty &&
        _userDao.userExists) {
      return _userDao.readUser();
    }
    return MinChatUser.empty;
  }

  Future<Result<void>> signInWithGithub() async {
    try {
      final response = await _authenticationInterface.signInGithub();
      _userController.add(_authenticationInterface.authenticatedUser);
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  Future<Result<void>> signInWithGoogle() async {
    try {
      final response = await _authenticationInterface.signInWithGoogle();
      final minChatUser = _authenticationInterface.authenticatedUser;

      if (minChatUser.isNotEmpty) {
        _userDao.writeUser(minChatUser);
        _userController.add(minChatUser);
      } else {
        return Result.failure(errorMessage: 'Google sign in failed.');
      }

      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  Future<Result<void>> signOut() async {
    try {
      final response = await _authenticationInterface.signOut();
      _userDao.deleteUser();
      _userController.add(null); // User is signed out, notify subscribers.
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  void dispose() {
    _userController.close();
  }
}
