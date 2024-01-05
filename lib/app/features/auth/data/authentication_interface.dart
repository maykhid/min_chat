import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

abstract class IAuthentication {
  MinChatUser get authenticatedUser;
  Future<void> signInGithub();
  Future<void> signInWithGoogle();
  Future<void> signOut();
}
