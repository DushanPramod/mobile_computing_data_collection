import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase/auth_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AuthService().handleAuthState(),
  ));
}