import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_computing_data_collection/pages/create-form-field.dart';
import 'package:mobile_computing_data_collection/pages/create-form.dart';
import 'package:mobile_computing_data_collection/pages/home.dart';
import './firebase/auth_server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: AuthService().handleAuthState(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => AuthService().handleAuthState(),
        '/home': (BuildContext context) => const Home(),
        '/create-form': (BuildContext context) => const CreateForm(),
        // '/create-form-field': (BuildContext context) => CreateFormField(title: context, description: '', numberOfInputFields: null,)
      }));
}
