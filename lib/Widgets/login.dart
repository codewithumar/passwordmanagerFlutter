import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passmanager/Widgets/Singup.dart';
import 'package:passmanager/Widgets/passwordGeneratoWidget.dart';
import 'package:passmanager/Widgets/signup.dart';

import 'package:passmanager/signin/Google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? email, password;
  late SharedPreferences logindata;
  late bool newuser;
  @override
  void initState() {
    // TODO: implement initState

    check_if_already_login();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    //print(newuser);
    if (newuser == false) {
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => const GeneratePassword()));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GeneratePassword()));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: nameController,
                    onChanged: (value) {
                      email = value;
                      setState(() {});
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
                      password = value;
                      setState(() {});
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
                        logindata.setBool('login', false);
                        logindata.setString('username', email!);
                        showLoaderDialog(context);
                        try {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const GeneratePassword()));
                          buildsnackbar("Signed in");
                        } on FirebaseAuthException catch (error) {
                          buildsnackbar(error.toString());
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
                      onPressed: () {
                        signInWithGoogle();
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
                            builder: (context) => const signup()));
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
    buildsnackbar("Loged in");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GeneratePassword()));
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
