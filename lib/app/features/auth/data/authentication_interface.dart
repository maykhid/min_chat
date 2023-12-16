import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

abstract class IAuthentication {
  // AuthenticatedUser get user;
  Future<void> signInGithub();
  Future<MinChatUser> signInWithGoogle();
}
