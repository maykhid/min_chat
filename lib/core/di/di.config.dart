// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:min_chat/app/features/auth/data/authentication_interface.dart'
    as _i4;
import 'package:min_chat/app/features/auth/data/authentication_repository.dart'
    as _i6;
import 'package:min_chat/app/features/auth/data/firebase_authentication.dart'
    as _i5;
import 'package:min_chat/core/di/module.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i3.FirebaseAuth>(registerModule.firebaseAuth);
    gh.singleton<_i4.AuthenticationInterface>(
        _i5.FirebaseAuthentication(firebaseAuth: gh<_i3.FirebaseAuth>()));
    gh.singleton<_i6.AuthenticationRepository>(_i6.AuthenticationRepository(
        authenticationInterface: gh<_i4.AuthenticationInterface>()));
    return this;
  }
}

class _$RegisterModule extends _i7.RegisterModule {}
