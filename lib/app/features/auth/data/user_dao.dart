import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

abstract class UserDao {
  MinChatUser readUser();
  void writeUser(MinChatUser authenticatedUser);
}
