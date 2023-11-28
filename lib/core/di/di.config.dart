// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:min_chat/app/features/auth/data/authentication_interface.dart'
    as _i7;
import 'package:min_chat/app/features/auth/data/authentication_repository.dart'
    as _i11;
import 'package:min_chat/app/features/auth/data/firebase_authentication.dart'
    as _i8;
import 'package:min_chat/app/features/auth/data/hive_user_dao.dart' as _i10;
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart'
    as _i4;
import 'package:min_chat/app/features/auth/data/user_dao.dart' as _i9;
import 'package:min_chat/core/di/module.dart' as _i12;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i3.Box<_i4.AuthenticatedUser>>(
      () => registerModule.userBox,
      preResolve: true,
    );
    gh.singleton<_i5.FirebaseAuth>(registerModule.firebaseAuth);
    gh.singleton<_i6.FirebaseFirestore>(registerModule.firebaseFirestore);
    gh.singleton<_i7.IAuthentication>(_i8.FirebaseAuthentication(
      firebaseAuth: gh<_i5.FirebaseAuth>(),
      firebaseFirestore: gh<_i6.FirebaseFirestore>(),
    ));
    gh.singleton<_i9.UserDao>(
        _i10.HiveUserDao(userBox: gh<_i3.Box<_i4.AuthenticatedUser>>()));
    gh.singleton<_i11.AuthenticationRepository>(_i11.AuthenticationRepository(
      authenticationInterface: gh<_i7.IAuthentication>(),
      userDao: gh<_i9.UserDao>(),
    ));
    return this;
  }
}

class _$RegisterModule extends _i12.RegisterModule {}
