import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.contain,
          )
        ),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: ElevatedButton.icon(
          onPressed: () {
              print("You pressed Icon Elevated Button");
            },
          icon:Image.asset('assets/google image.png', height: 40, fit: BoxFit.cover,),
          label: const Text('Sign In with Google'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, 
              foregroundColor: Colors.black,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }
}
