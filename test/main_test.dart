import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:see_you_here_app/main.dart';
import 'package:see_you_here_app/notifications_provider.dart';

class FakeUser implements User {
  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  String get displayName => "Fake User";

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
  // TODO: implement isAnonymous
  bool get isAnonymous => throw UnimplementedError();

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
  // TODO: implement uid
  String get uid => throw UnimplementedError();

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
  User _user;

  @override
  User currentUser() {
    return null;
  }

  @override
  Future<User> signInWithCredential(AuthCredential credential) async {
    return null;
  }

  @override
  Future<User> signInAnonymously() async {
    return _user;
  }

  void setUser(User user) {
    _user = user;
  }
}

void main() {
  testWidgets("initial status should show login buttons",
      (WidgetTester tester) async {
    // GIVEN
    var widget = LoginScreen(
      loginService: FakeLoginService(),
    );

    // WHEN
    await tester.pumpWidget(
      MaterialApp(
        home: widget,
      ),
    );

    // THEN
    expect(find.text("Entrar como Anónimo"), findsOneWidget);
    expect(find.text("Entrar con Google"), findsOneWidget);
    expect(find.text("Ir a una Fiesta"), findsNothing);
    expect(find.text("Crear Fiesta"), findsNothing);
  });

  testWidgets("login as anon user", (WidgetTester tester) async {
    // GIVEN
    var fakeService = FakeLoginService();
    var widget = LoginScreen(
      loginService: fakeService,
    );

    // WHEN
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => NotificationsProvider.instance,
        builder: (BuildContext context, Widget child) => child,
        child: MaterialApp(
          home: widget,
        ),
      ),
    );
    var btn = find.text("Entrar como Anónimo");
    var user = FakeUser();
    fakeService.setUser(user);
    await tester.tap(btn);
    await tester.pump();

    // THEN
    expect(find.text("Entrar como Anónimo"), findsNothing);
    expect(find.text("Entrar con Google"), findsNothing);
    expect(find.text("Ir a una Fiesta"), findsOneWidget);
    expect(find.text("Crear Fiesta"), findsOneWidget);
  });
}
