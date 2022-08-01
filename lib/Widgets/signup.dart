import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passmanager/Widgets/login.dart';
import 'package:passmanager/Widgets/passwordGeneratoWidget.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  @override
  Widget build(BuildContext context) {
    String? _email, _password;
    final auth = FirebaseAuth.instance;
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    return Form(
        child: Material(
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: passController,
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      try {
                        await auth.createUserWithEmailAndPassword(
                            email: _email!, password: _password!);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const GeneratePassword()));
                      } on FirebaseAuthException catch (error) {
                        buildsnackbar(error.toString());
                      }
                    },
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Have An account?'),
                  TextButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const login()));
                    },
                  )
                ],
              ),
            ],
          )),
    ));
  }

  buildsnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
