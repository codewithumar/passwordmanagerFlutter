import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passmanager/Models/data.dart';

class DataInput extends StatefulWidget {
  const DataInput({Key? key}) : super(key: key);

  @override
  State<DataInput> createState() => _DataInputState();
}

class _DataInputState extends State<DataInput> {
  TextEditingController passcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Material(
      child: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'Website name'),
                    keyboardType: TextInputType.name,
                  )),
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter email");
                      } else if (!EmailValidator.validate(value)) {
                        return ("Please Enter valid email");
                      }

                      // else if (!(RegExp("[\w-]+@([\w-]+\.)+[\w-]+")
                      //     .hasMatch(value))) {
                      //   return ("Please Enter valid email");
                      // }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  )),
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    onChanged: (text) => setState(() => text),
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
                    controller: passcontroller,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              passcontroller.text = generatePasswrod();
                              setState(() {});
                            },
                            icon: const Icon(Icons.password))),
                    keyboardType: TextInputType.name,
                  )),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        final data = UserData(
                            email: emailController.text,
                            name: nameController.text,
                            pass: passcontroller.text);
                        createdata(data);
                      }
                    },
                    child: const Text(
                      ('Save'),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future createdata(UserData data) async {
    await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc(data.name)
        .set(data.toMap());
    Fluttertoast.showToast(msg: "Scuess");
  }

  String generatePasswrod() {
    int value = 12;
    String capitalalphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String smallalphabets = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';
    String special = '!@#\$%^&*()_+/.,`';
    String chars = ' ';
    chars += capitalalphabets;
    chars += numbers;
    chars += smallalphabets;
    chars += special;
    return List.generate(value, (index) {
      final random = Random().nextInt(chars.length);
      return chars[random];
    }).join('');
  }
}
