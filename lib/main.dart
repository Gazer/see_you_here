import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:see_you_here_app/features/welcome/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:see_you_here_app/services/login_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GetIt.instance.registerSingleton(LoginService());

  runApp(WelcomeScreen());
}
