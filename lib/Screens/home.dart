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
                await auth.signOut().then((value) => {
                      Fluttertoast.showToast(msg: "Signed Out"),
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const login()))
                    });
                await GoogleSignIn().signOut();
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'DashBoard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Saved Passwords',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add ',
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
}
