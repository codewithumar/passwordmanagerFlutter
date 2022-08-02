import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:passmanager/Screens/datainput.dart';
import 'package:passmanager/Screens/passwordLlst.dart';
import 'package:passmanager/Widgets/passwordGeneratoWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
              onPressed: () async {
                _showMyDialog();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      // child: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        iconSize: 20,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Saved Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add credientals',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    GeneratePassword(),
    passwordlist(),
    datainput(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warrning'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are You Sure yoy want to Signout?.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await auth.signOut().then((value) => {
                      Fluttertoast.showToast(msg: "Signed Out"),
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const login()))
                    });
                await GoogleSignIn().signOut();
                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                //Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
