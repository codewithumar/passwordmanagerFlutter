import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passmanager/Models/Data.dart';
import 'package:passmanager/Screens/datainput.dart';

class passwordlist extends StatefulWidget {
  const passwordlist({Key? key}) : super(key: key);

  @override
  State<passwordlist> createState() => _passwordlistState();
}

class _passwordlistState extends State<passwordlist> {
  final auth =FirebaseAuth.instance;
  final currentuser=FirebaseAuth.instance.currentUser;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder<List<userdata>>(stream: readusers(),builder:  (context,snapshot){
      //print(snapshot.data.toString());
      if(snapshot.hasError){
        return const  Center(child:Text("Nothing to show up"));
      }
      else if(snapshot.hasData){
        final users=snapshot.data;
        return ListView(
      children: users!.map(builduserdata).toList(),
        );
      }
      else{
        return const Center(child: Text("Nothing to show up"));
      }
    }),);

  }

  Widget builduserdata(userdata data)=>ListTile(
    onLongPress: (){
      _showMyDialog(data);
    },
    leading:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(data.name,style: TextStyle(fontWeight: FontWeight.bold),),
      ],
    ),
    title: Text(data.email),

    subtitle: Text(data.pass,style: TextStyle(decoration: TextDecoration.lineThrough),),
    trailing: IconButton(icon:Icon(Icons.copy),onPressed: (){
      final pass = ClipboardData(text: data.pass.toString());
      Clipboard.setData(pass);
      Fluttertoast.showToast(msg: "Password Copied");},),


  );
  Stream<List<userdata>> readusers()=>FirebaseFirestore.instance
      .collection(currentuser!.email!)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) =>userdata.fromuserdata(doc.data()) ).toList());

  Future<void> _showMyDialog(userdata data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warrning'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are You Sure yoy want to delete?.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                final doc=FirebaseFirestore.instance.collection(currentuser!.email!).doc(data.name);
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
}

