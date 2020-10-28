import 'package:firebase_auth_platform_interface/src/auth_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:see_you_here_app/main.dart';

class MockUser implements User {
  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  String get displayName => "Mock User";

  @override
  // TODO: implement email
  String get email => throw UnimplementedError();

  @override
  // TODO: implement emailVerified
  bool get emailVerified => throw UnimplementedError();

  @override
  Future<String> getIdToken([bool forceRefresh = false]) {
    // TODO: implement getIdToken
    throw UnimplementedError();
  }

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) {
    // TODO: implement getIdTokenResult
    throw UnimplementedError();
  }

  @override
  bool get isAnonymous => true;

  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) {
    // TODO: implement linkWithCredential
    throw UnimplementedError();
  }

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber,
      [RecaptchaVerifier verifier]) {
    // TODO: implement linkWithPhoneNumber
    throw UnimplementedError();
  }

  @override
  // TODO: implement metadata
  UserMetadata get metadata => throw UnimplementedError();

  @override
  // TODO: implement phoneNumber
  String get phoneNumber => throw UnimplementedError();

  @override
  // TODO: implement photoURL
  String get photoURL => throw UnimplementedError();

  @override
  // TODO: implement photoUrl
  String get photoUrl => throw UnimplementedError();

  @override
  // TODO: implement providerData
  List<UserInfo> get providerData => throw UnimplementedError();

  @override
  Future<UserCredential> reauthenticateWithCredential(
      AuthCredential credential) {
    // TODO: implement reauthenticateWithCredential
    throw UnimplementedError();
  }

  @override
  // TODO: implement refreshToken
  String get refreshToken => throw UnimplementedError();

  @override
  Future<void> reload() {
    // TODO: implement reload
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification([ActionCodeSettings actionCodeSettings]) {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  @override
  // TODO: implement tenantId
  String get tenantId => throw UnimplementedError();

  @override
  String get uid => "userId";

  @override
  Future<User> unlink(String providerId) {
    // TODO: implement unlink
    throw UnimplementedError();
  }

  @override
  Future<void> updateEmail(String newEmail) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) {
    // TODO: implement updatePhoneNumber
    throw UnimplementedError();
  }

  @override
  Future<void> updateProfile({String displayName, String photoURL}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings actionCodeSettings]) {
    // TODO: implement verifyBeforeUpdateEmail
    throw UnimplementedError();
  }
}

class FakeLoginService implements LoginService {
  @override
  User currentUser() {
    return null;
  }

  @override
  Future<User> signInAnonymously() async {
    return MockUser();
  }

  @override
  Future<User> signInWithCredential(AuthCredential credential) async {
    return null;
  }

  @override
  void signOut() {}
}
