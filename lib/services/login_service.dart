import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  User currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<User> signInWithCredential(AuthCredential credential) async {
    return (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  }

  Future<User> signInAnonymously() async {
    var result = await FirebaseAuth.instance.signInAnonymously();
    if (result != null) {
      return result.user;
    }
    return null;
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
