import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/auth/data/user_dao.dart';

@Singleton(as: UserDao)
class HiveUserDao implements UserDao {
  HiveUserDao({
    required Box<MinChatUser> userBox,
  }) : _userBox = userBox;

  final Box<MinChatUser> _userBox;

  static const String _key = '__user__key__';

  @override
  MinChatUser readUser() {
    if (_userBox.isEmpty) {
      return MinChatUser.empty;
    }
    return _userBox.get(_key) ?? MinChatUser.empty;
  }

  @override
  void writeUser(MinChatUser authenticatedUser) =>
      _userBox.put(_key, authenticatedUser);

  @override
  void deleteUser() => _userBox.delete(_key);

  @override
  bool get userExists => _userBox.isNotEmpty;
}
