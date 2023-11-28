import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/data/user_dao.dart';

@Singleton(as: UserDao)
class HiveUserDao implements UserDao {
  HiveUserDao({
    required Box<AuthenticatedUser> userBox,
  }) : _userBox = userBox;

  final Box<AuthenticatedUser> _userBox;

  static const String key = '__user__key__';

  @override
  AuthenticatedUser readUser() {
    if (_userBox.isEmpty) {
      return AuthenticatedUser.empty;
    }
    return _userBox.get(key)!;
  }

  @override
  void writeUser(AuthenticatedUser authenticatedUser) =>
      _userBox.put(key, authenticatedUser);
}
