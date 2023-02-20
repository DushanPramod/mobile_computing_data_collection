import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/home.dart';
import '../pages/login.dart';

class AuthService{
  handleAuthState(){
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          // Navigator.pushReplacementNamed(context, '/home');
          return const Home();
        }else{
          // Navigator.pushReplacementNamed(context, '/');
          return const Login();
        }
      }
    );
  }

  signInWithGoogle() async {
    // Trigger the authenatication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // Sign out
  signOut(){
    FirebaseAuth.instance.signOut();
  }
}


