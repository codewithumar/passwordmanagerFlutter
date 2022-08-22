import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passmanager/Widgets/Signup.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //String? email, password;
  late SharedPreferences logindata;
  late bool newuser;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
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
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter email");
                      }
                      if (!EmailValidator.validate(value)) {
                        return ("Please Enter valid email");
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // email = value;
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
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (value) {
                      // password = value;
                      setState(() {});
                    },
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return ("Please Enter your password");
                      }
                      if (!regex.hasMatch(value)) {
                        return ("Please Enter a valid password from 6-30");
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password',
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          await auth
                              .signInWithEmailAndPassword(
                                  email: nameController.text,
                                  password: passwordController.text)
                              .then((uid) => {
                                    FirebaseFirestore.instance
                                        .collection(uid.user!.email!)
                                        .doc(uid.user!.uid),
                                    showLoaderDialog(context),
                                    Fluttertoast.showToast(
                                        msg: "Login successfull"),
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen()),
                                        (route) => false)
                                  })
                              .catchError((e) {
                            Fluttertoast.showToast(msg: e!.message);
                          });
                        } else {
                          Fluttertoast.showToast(msg: "Error");
                        }
                      },
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.black,
                      ),
                      onPressed: () async {
                        await signInWithGoogle().then((uid2) => {
                              FirebaseFirestore.instance
                                  .collection(uid2.user!.email!)
                                  .doc(uid2.user!.uid),
                              showLoaderDialog(context),
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false)
                            });
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.amber,
                      ),
                      label: const Text('Signup with google')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Does not have account?'),
                    ElevatedButton(
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const SignUp()));
                      },
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }

  buildsnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(snackbar);
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
