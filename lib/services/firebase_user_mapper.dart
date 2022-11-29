import 'package:firebase_auth/firebase_auth.dart';

import 'models/user.dart' as SeeYouHere;

extension UserMapper on User {
  SeeYouHere.User toSeeYouHereUser() {
    return SeeYouHere.User(
      userId: this.uid,
      name: this.displayName,
      isAnonymous: this.isAnonymous,
    );
  }
}
