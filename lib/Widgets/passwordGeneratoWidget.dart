import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class generatepassword extends StatefulWidget {
  const generatepassword({Key? key}) : super(key: key);

  @override
  State<generatepassword> createState() => _generatepasswordState();
}

class _generatepasswordState extends State<generatepassword> {
  final controller = TextEditingController();
  bool hasNumbers = false;
  bool hasSpecial = false;
  bool hasUpercase = false;
  bool hasLowerCase = false;
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double v = 10.0;
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Generate Password",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Checkbox(
                  value: hasNumbers,
                  onChanged: (bool? newValue) {
                    setState(() {
                      hasNumbers = newValue!;
                    });
                  }),
              const SizedBox(
                width: 25.0,
              ),
              Checkbox(
                  value: hasLowerCase,
                  onChanged: (bool? newValue) {
                    setState(() {
                      hasLowerCase = newValue!;
                    });
                  }),
              const SizedBox(
                width: 30.0,
              ),
              Checkbox(
                  value: hasUpercase,
                  onChanged: (bool? newValue) {
                    setState(() {
                      hasUpercase = newValue!;
                    });
                  }),
              const SizedBox(
                width: 25.0,
              ),
              Checkbox(
                  value: hasSpecial,
                  onChanged: (bool? newValue) {
                    setState(() {
                      hasSpecial = newValue!;
                    });
                  }),
            ],
          ),
          Row(
            children: const [
              Text('Numbers'),
              SizedBox(
                width: 10.0,
              ),
              Text('LowerCase'),
              SizedBox(
                width: 10.0,
              ),
              Text('UperCase'),
              SizedBox(
                width: 10.0,
              ),
              Text('Special'),
            ],
          ),
          TextField(
              readOnly: true,
              controller: controller,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      final data = ClipboardData(text: controller.text);
                      Clipboard.setData(data);

                      const snackbar = SnackBar(
                        content: Text("Password Coppied"),
                        backgroundColor: Colors.red,
                      );

                      ScaffoldMessenger.of(context)
                        ..removeCurrentMaterialBanner()
                        ..showSnackBar(snackbar);
                    },
                  ))),
          const SizedBox(
            height: 20.0,
          ),
          Center(child: buildButton()),
        ],
      ),
    );
  }

  Widget buildButton() {
    return ElevatedButton(
        child: const Text("Generate"),
        onPressed: () {
          final password = generatePasswrod();
          controller.text = password;
        });
  }

  String generatePasswrod() {
    final length = 20;
    String capitalalphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String smallalphabets = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';
    String special = '!@#\$%^&*()_+';
    String chars = '';
    chars += hasUpercase == true ? capitalalphabets : "";
    chars += hasNumbers == true ? numbers : "";
    chars += hasLowerCase == true ? smallalphabets : "";
    chars += hasSpecial == true ? special : "";
    return List.generate(length, (index) {
      final random = Random.secure().nextInt(chars.length);
      return chars[random];
    }).join('');
  }
}
