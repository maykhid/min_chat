import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

@module
abstract class RegisterModule {
  @singleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @singleton
  // ignore: lines_longer_than_80_chars
  FirebaseFirestore get firebaseFirestore => FirebaseFirestore.instance;

  // @singleton
  @preResolve
  Future<Box<MinChatUser>> get userBox => Hive.openBox<MinChatUser>('userBox');
}
