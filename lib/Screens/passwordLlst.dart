// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:passmanager/Models/data.dart';

class PasswordList extends StatefulWidget {
  const PasswordList({Key? key}) : super(key: key);

  @override
  State<PasswordList> createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  final auth = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserData>>(
          stream: readusers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error in loading ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final users = snapshot.data;
              return ListView(
                children: users!.map(builduserdata).toList(),
              );
            } else if (snapshot.data == null) {
              return const Center(child: Text("No Data"));
            } else {
              return Center(child: Text("Error in loading ${snapshot.error}"));
            }
          }),
    );
  }

  Widget builduserdata(UserData data) => Card(
        margin: const EdgeInsets.all(10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 5.0),
                Text(
                  data.email,
                ),
                Text.rich(TextSpan(text: data.pass)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    final pass = ClipboardData(text: data.pass.toString());
                    Clipboard.setData(pass);
                    Fluttertoast.showToast(msg: "Password Copied");
                  },
                  icon: const Icon(Icons.copy)),
              IconButton(
                  onPressed: () {
                    _showMyDialog(data);
                  },
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    emailcontroller.text = data.email;
                    passcontroller.text = data.pass;
                    _updateMyDialog(data);
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
        ]),
      );

  Stream<List<UserData>> readusers() => FirebaseFirestore.instance
      .collection(currentuser!.email!)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserData.fromuserdata(doc.data()))
          .toList());

  Future<void> _showMyDialog(UserData data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warrning'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are You Sure you want to delete - ${data.name}?.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete '),
              onPressed: () {
                final doc = FirebaseFirestore.instance
                    .collection(currentuser!.email!)
                    .doc(data.name);
                doc.delete();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateMyDialog(UserData data) async {
    final GlobalKey formkey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Form(
          key: formkey,
          child: AlertDialog(
            title: Text(data.name),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter email");
                        }
                        if (!EmailValidator.validate(value)) {
                          return ("Please Enter valid email");
                        }
                        return null;
                      },
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: passcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Password");
                        }
                        if (!EmailValidator.validate(value)) {
                          return ("Please Enter valid password");
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Update'),
                  onPressed: () {
                    {
                      final doc = FirebaseFirestore.instance
                          .collection(currentuser!.email!)
                          .doc(data.name);
                      doc.update({
                        'email': emailcontroller.text,
                        'pass': passcontroller.text
                      });
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  }),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
