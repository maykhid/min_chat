import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

abstract class UserDao {
  void writeUser(MinChatUser authenticatedUser);
  void deleteUser();
  bool get userExists;
  MinChatUser readUser();
}
