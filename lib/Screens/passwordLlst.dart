import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class passwordlist extends StatefulWidget {
  const passwordlist({Key? key}) : super(key: key);

  @override
  State<passwordlist> createState() => _passwordlistState();
}

class _passwordlistState extends State<passwordlist> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(child: const Text("Nothng to show up")),
    );
  }
}
