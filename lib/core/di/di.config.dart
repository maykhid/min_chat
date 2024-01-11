// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:audioplayers/audioplayers.dart' as _i3;
import 'package:cloud_firestore/cloud_firestore.dart' as _i8;
import 'package:firebase_auth/firebase_auth.dart' as _i7;
import 'package:firebase_storage/firebase_storage.dart' as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;
import 'package:min_chat/app/features/auth/data/authentication_interface.dart'
    as _i10;
import 'package:min_chat/app/features/auth/data/authentication_repository.dart'
    as _i18;
import 'package:min_chat/app/features/auth/data/firebase_authentication.dart'
    as _i11;
import 'package:min_chat/app/features/auth/data/hive_user_dao.dart' as _i15;
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart'
    as _i6;
import 'package:min_chat/app/features/auth/data/user_dao.dart' as _i14;
import 'package:min_chat/app/features/chat/data/chat_interface.dart' as _i12;
import 'package:min_chat/app/features/chat/data/chat_repository.dart' as _i19;
import 'package:min_chat/app/features/chat/data/firebase_chat_impl.dart'
    as _i13;
import 'package:min_chat/app/features/chat/domain/get_conversations_use_case.dart'
    as _i20;
import 'package:min_chat/core/di/module.dart' as _i21;
import 'package:min_chat/core/services/voice_recorder/record_voice_recorder.dart'
    as _i17;
import 'package:min_chat/core/services/voice_recorder/voice_recorder.dart'
    as _i16;
import 'package:record/record.dart' as _i4;

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
    gh.factory<_i3.AudioPlayer>(() => registerModule.audioPlayer);
    gh.factory<_i4.AudioRecorder>(() => registerModule.audioRecorder);
    await gh.factoryAsync<_i5.Box<_i6.MinChatUser>>(
      () => registerModule.userBox,
      preResolve: true,
    );
    gh.singleton<_i7.FirebaseAuth>(registerModule.firebaseAuth);
    gh.singleton<_i8.FirebaseFirestore>(registerModule.firebaseFirestore);
    gh.factory<_i9.FirebaseStorage>(() => registerModule.firebaseStorage);
    gh.singleton<_i10.IAuthentication>(_i11.FirebaseAuthentication(
      firebaseAuth: gh<_i7.FirebaseAuth>(),
      firebaseFirestore: gh<_i8.FirebaseFirestore>(),
    ));
    gh.singleton<_i12.IChat>(_i13.FirebaseChat(
      firebaseFirestore: gh<_i8.FirebaseFirestore>(),
      firebaseStorage: gh<_i9.FirebaseStorage>(),
    ));
    gh.singleton<_i14.UserDao>(
        _i15.HiveUserDao(userBox: gh<_i5.Box<_i6.MinChatUser>>()));
    gh.factory<_i16.VoiceRecorder>(() => _i17.RecordVoiceRecorder(
          audioRecorder: gh<_i4.AudioRecorder>(),
          audioPlayers: gh<_i3.AudioPlayer>(),
        ));
    gh.singleton<_i18.AuthenticationRepository>(_i18.AuthenticationRepository(
      authenticationInterface: gh<_i10.IAuthentication>(),
      userDao: gh<_i14.UserDao>(),
    ));
    gh.singleton<_i19.ChatRepository>(_i19.ChatRepository(
      chatInterface: gh<_i12.IChat>(),
      userDao: gh<_i14.UserDao>(),
    ));
    gh.singleton<_i20.GetConversationsUseCase>(_i20.GetConversationsUseCase(
        chatRepository: gh<_i19.ChatRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i21.RegisterModule {}
