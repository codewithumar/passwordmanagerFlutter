import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:passmanager/Models/Data.dart';

class passwordlist extends StatefulWidget {
  const passwordlist({Key? key}) : super(key: key);

  @override
  State<passwordlist> createState() => _passwordlistState();
}

class _passwordlistState extends State<passwordlist> {
  final auth = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    namecontroller.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<userdata>>(
          stream: readusers(),
          builder: (context, snapshot) {
            print(snapshot.data.toString());
            if (snapshot.hasError) {
              return const Center(child: Text("Nothing to show up"));
            } else if (snapshot.hasData) {
              final users = snapshot.data;
              return ListView(
                children: users!.map(builduserdata).toList(),
              );
            } else {
              return const Center(child:CircularProgressIndicator() );
            }
          }),
    );
  }

  Widget builduserdata(userdata data) => ListTile(
        onTap: () {
          _updateMyDialog(data);
        },
        onLongPress: () {
          _showMyDialog(data);
        },
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        title: Text(data.email),
        subtitle: Text(
          data.pass,
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
        trailing: IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            final pass = ClipboardData(text: data.pass.toString());
            Clipboard.setData(pass);
            Fluttertoast.showToast(msg: "Password Copied");
          },
        ),
      );
  Stream<List<userdata>> readusers() => FirebaseFirestore.instance
      .collection(currentuser!.email!)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => userdata.fromuserdata(doc.data()))
          .toList());

  Future<void> _showMyDialog(userdata data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateMyDialog(userdata data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.name),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    // initialValue: data.email,
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
                    onChanged: (value) {
                      // email = value;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    // initialValue: data.pass,
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
                    onChanged: (value) {
                      // email = value;
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
                final doc = FirebaseFirestore.instance
                    .collection(currentuser!.email!)
                    .doc(data.name);
                doc.update({
                  'email': emailcontroller.text,
                  'pass': passcontroller.text
                });
                Navigator.of(context).pop();

                //Navigator.of(context).pop();
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
}
