import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

abstract class UserDao {
  AuthenticatedUser readUser();
  void writeUser(AuthenticatedUser authenticatedUser);
}
