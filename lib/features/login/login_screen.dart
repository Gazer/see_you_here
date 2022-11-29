import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:see_you_here_app/features/create_party/create_party_screen.dart';
import 'package:see_you_here_app/features/join_party/join_screen.dart';
import 'package:see_you_here_app/services/login_service.dart';
import 'package:see_you_here_app/ui/if.dart';
import 'package:see_you_here_app/ui/menu_button.dart';
import 'package:see_you_here_app/providers/notifications_provider.dart';

class LoginScreen extends StatefulWidget {
  final LoginService loginService;

  const LoginScreen({Key key, @required this.loginService}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User _currentUser;

  @override
  void initState() {
    super.initState();

    _currentUser = widget.loginService.currentUser();
  }

  Future<AuthCredential> _authWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  Future<User> _handleSignIn() async {
    final AuthCredential credential = await _authWithGoogle();

    final User user =
        (await widget.loginService.signInWithCredential(credential));
    print("signed in " + user.displayName);
    return user;
  }

  _doLogin() {
    _handleSignIn().then((User user) {
      setState(() {
        _currentUser = user;
      });
    }).catchError((e) => print(e));
  }

  _doAnonLogin() async {
    var result = await widget.loginService.signInAnonymously();
    if (result != null) {
      setState(() {
        _currentUser = result;
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "See you here",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          if (_currentUser != null)
            IconButton(
              icon: Consumer<NotificationsProvider>(
                builder: (_, NotificationsProvider provider, __) {
                  print(provider.unread);
                  var icon = Icons.notifications;
                  if (provider.unread > 0) {
                    icon = Icons.notifications_active;
                  }
                  return Icon(icon);
                },
              ),
              onPressed: () {
                var provider =
                    Provider.of<NotificationsProvider>(context, listen: false);
                provider.clear();
              },
            ),
          if (_currentUser != null)
            PopupMenuButton<String>(
              key: Key("menu"),
              onSelected: (String option) {
                if (option == "salir") {
                  widget.loginService.signOut();
                  setState(() {
                    _currentUser = null;
                  });
                } else if (option == "google") {
                  _linkGoogleAccount();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  if (_currentUser.isAnonymous)
                    PopupMenuItem<String>(
                      value: "google",
                      child: Text("Agregar Cuenta de Google"),
                    ),
                  PopupMenuItem<String>(
                    key: Key("signout"),
                    value: "salir",
                    child: Text("Salir"),
                  )
                ];
              },
            ),
        ],
      ),
      body: If(
        expect: _currentUser == null,
        then: () => Column(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: SvgPicture.asset('assets/map-logo.svg'),
              ),
            ),
            Spacer(flex: 1),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MenuButton(
                  onPressed: _doAnonLogin,
                  child: Text("Entrar como Anónimo"),
                ),
                MenuButton(
                  onPressed: _doLogin,
                  child: Text("Entrar con Google"),
                ),
              ],
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: Text(
                "Al ingresar estas aceptando los términos y condiciones de uso.",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
        or: () => Column(
          children: <Widget>[
            Expanded(
              flex: 20,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: SvgPicture.asset('assets/map-logo.svg'),
              ),
            ),
            Spacer(flex: 1),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MenuButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      JoinScreen.route(_currentUser.uid),
                    );
                  },
                  child: Text("Ir a una Fiesta"),
                ),
                MenuButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CreatePartyScreen.route(_currentUser.uid),
                    );
                  },
                  child: Text("Crear Fiesta"),
                ),
              ],
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
