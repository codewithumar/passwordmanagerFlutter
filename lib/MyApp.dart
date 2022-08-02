import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/Screens/home.dart';
import 'package:passmanager/Widgets/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password Manger',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Password Manger'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return const HomeScreen();
    } else {
      return const login();
    }
  }
}
