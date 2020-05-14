import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

import 'create_party_screen.dart';
import 'join_screen.dart';

void main() {
  _setupLogger();
  runApp(MyApp());
}

void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.currentUser().then(
          (u) => setState(() => _currentUser = u),
    );
  }

  Future<AuthCredential> _authWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final AuthCredential credential = await _authWithGoogle();

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  _doLogin() {
    _handleSignIn().then((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    }).catchError((e) => print(e));
  }

  _doAnonLogin() async {
    var result = await FirebaseAuth.instance.signInAnonymously();
    if (result != null) {
      setState(() {
        _currentUser = result.user;
      });
      print(_currentUser.displayName);
    }
  }

  _linkGoogleAccount() async {
    var credentials = await _authWithGoogle();
    if (credentials != null) {
      var result = await _currentUser.linkWithCredential(credentials);
      if (result != null) {
        setState(() {
          _currentUser = result.user;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentUser == null
          ? Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  onPressed: _doLogin,
                  child: Text("Entrar con Google"),
                ),
                RaisedButton(
                  onPressed: _doAnonLogin,
                  child: Text("Entrar como Anónimo"),
                ),
              ],
            ))
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(JoinScreen.route(_currentUser.uid));
                    },
                    child: Text("Ir a una Fiesta"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(CreatePartyScreen.route(_currentUser.uid));
                    },
                    child: Text("Crear Fiesta"),
                  ),
                  if (_currentUser.isAnonymous)
                    RaisedButton(
                      onPressed: () {
                        _linkGoogleAccount();
                      },
                      child: Text("Agregar Cuenta de Google"),
                    ),
                  RaisedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        _currentUser = null;
                      });
                    },
                    child: Text("Salir"),
                  ),
                ],
              ),
            ),
    );
  }
}
