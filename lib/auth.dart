import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

class Auth{

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> handleSignInEmail(String email, String password) async {

    UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user;

    assert(user != null);
    assert(await user.getIdToken() != null);

    final User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user;

  }

  Future<User> handleSignUp(String email, String password) async {

    UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = result.user;

    assert (user != null);
    assert (await user.getIdToken() != null);

    return user;

  }

  void handleSignOut() async {
    await auth.signOut();
  }

}