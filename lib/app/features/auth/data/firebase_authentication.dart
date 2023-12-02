import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/app/features/auth/data/authentication_interface.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/core/utils/helpers.dart';

@Singleton(as: IAuthentication)
class FirebaseAuthentication implements IAuthentication {
  FirebaseAuthentication({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore {
    _firebaseAuth.authStateChanges().listen((user) => _user = user);
  }

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  User? _user;

  @override
  Future<void> signInGithub() async {
    try {
      final githubProvider = GithubAuthProvider();
      await _firebaseAuth.signInWithProvider(githubProvider);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<MinChatUser> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        // TODO(maykhid): check that mID has not been previously assigned to a user

        final mID = generateMID;

        final authenticatedUser = MinChatUser(
          id: _user?.uid ?? '',
          name: _user?.displayName,
          email: _user?.email,
          mID: mID,
          imageUrl: _user?.photoURL,
        );

        // create firestore user
        await _firebaseFirestore
            .collection('users')
            .doc(_user?.uid)
            .set(authenticatedUser.toMap());

        return authenticatedUser;
      } else {
        final snapshot =
            await _firebaseFirestore.collection('users').doc(_user?.uid).get();
        final userMap = snapshot.data();
        return MinChatUser.fromMap(userMap!);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e);
    }
  }

  // @override
  // AuthenticatedUser get user => _authenticatedUser;

  String get generateMID => '${generatePrefixForID()}${generateSuffixForID(2)}';
}
