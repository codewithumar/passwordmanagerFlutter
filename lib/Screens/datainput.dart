import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:passmanager/Models/Data.dart';

class datainput extends StatefulWidget {
  const datainput({Key? key}) : super(key: key);

  @override
  State<datainput> createState() => _datainputState();
}

class _datainputState extends State<datainput> {
  TextEditingController passcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
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
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                  keyboardType: TextInputType.name,
                )),
            Container(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: passcontroller,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            passcontroller.text = generatePasswrod();
                            setState(() {});
                          },
                          icon: const Icon(Icons.add))),
                  keyboardType: TextInputType.name,
                )),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                  onPressed: () {
                    final data = userdata(
                        email: emailController.text,
                        name: nameController.text,
                        pass: passcontroller.text);
                    createdata(data);
                  },
                  child: const Text(
                    ('Save'),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future createdata(userdata data) async {
    FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email!)
        .doc(data.name)
        .set(data.toMap());
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
