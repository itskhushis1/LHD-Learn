import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wastood/pages/wastood_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final hideOnboarding = prefs.getBool('hideOnboarding');
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  runApp(WastoodApp(
    showOnboarding: hideOnboarding == null || !hideOnboarding,
    showLogin: firebaseAuth.currentUser == null,
  ));
}
