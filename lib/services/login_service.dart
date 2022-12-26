import 'package:firebase_auth/firebase_auth.dart' as FA;

import 'models/user.dart';
import 'firebase_user_mapper.dart';

class LoginService {
  User currentUser() {
    if (FA.FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    return FA.FirebaseAuth.instance.currentUser.toSeeYouHereUser();
  }

  Future<User> signInWithCredential(FA.AuthCredential credential) async {
    return (await FA.FirebaseAuth.instance.signInWithCredential(credential))
        .user
        .toSeeYouHereUser();
  }

  Future<User> signInAnonymously() async {
    var result = await FA.FirebaseAuth.instance.signInAnonymously();
    if (result != null) {
      return result.user.toSeeYouHereUser();
    }
    return null;
  }

  void signOut() {
    FA.FirebaseAuth.instance.signOut();
  }
}
