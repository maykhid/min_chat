
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/authentication_interface.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/core/data/model/result.dart';

@singleton
class AuthenticationRepository {
  AuthenticationRepository({
    required AuthenticationInterface authenticationInterface,
  }) : _authenticationInterface = authenticationInterface;

  final AuthenticationInterface _authenticationInterface;

  AuthenticatedUser get user => _authenticationInterface.user;

  Future<Result<void>> signInWithGithub() async {
    try {
      final response = await _authenticationInterface.signInGithub();
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }

  Future<Result<void>> signInWithGoogle() async {
    try {
      final response = await _authenticationInterface.signInWithGoogle();
      return Result.success(response);
    } catch (e) {
      return Result.failure(errorMessage: e.toString());
    }
  }
}
