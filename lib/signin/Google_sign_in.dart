import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;
  Future googlelogin() async {
    final googleuser = await googleSignIn.signIn();
    if (googleuser == null) return;
    _user = googleuser;
    final googleauth = await googleuser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleauth.idToken,
      accessToken: googleauth.accessToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }
}
