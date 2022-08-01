import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/Widgets/login.dart';
import 'package:passmanager/Widgets/passwordGeneratoWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences logindata;
  late String? username;
  // String? email, password;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = "";
    setState(() {});
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
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
              keyboardType: TextInputType.emailAddress,
              controller: nameController,
              onChanged: (value) {
                // email = value;
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
                //password = value;
                setState(() {});
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
                child: const Text('Create Account'),
                onPressed: () async {
                  Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator(
                        value: 0.8,
                      ));
                  try {
                    final credientals =
                        await auth.createUserWithEmailAndPassword(
                            email: nameController.text,
                            password: passwordController.text);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const GeneratePassword()));
                    buildsnackbar("Signed in");
                  } on FirebaseAuthException catch (error) {
                    final snackbar = SnackBar(
                      content: Text(error.toString()),
                      backgroundColor: Colors.red,
                    );

                    ScaffoldMessenger.of(context)
                      ..removeCurrentMaterialBanner()
                      ..showSnackBar(snackbar);
                  }
                },
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Have an account?'),
              const SizedBox(width: 20),
              ElevatedButton(
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const login()));
                },
              )
            ],
          ),
        ],
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
}
