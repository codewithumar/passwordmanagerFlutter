// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class GeneratePassword extends StatefulWidget {
  const GeneratePassword({Key? key}) : super(key: key);

  @override
  State<GeneratePassword> createState() => GeneratePasswordState();
}

class GeneratePasswordState extends State<GeneratePassword> {
  final controller = TextEditingController();
  final controllerLength = TextEditingController();
  int value = 8;
  bool hasNumbers = false;
  bool hasSpecial = false;
  bool hasUpercase = false;
  bool hasLowerCase = false;
  late SharedPreferences logindata;
  late String? username;
  @override
  void initState() {
    super.initState();
    username = "";
    setState(() {});
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username');
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            TextField(
                readOnly: true,
                maxLines: 2,
                minLines: 1,
                controller: controller,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                    hintText: "Your Random Password will be here",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        if (controller.text == '') {
                          buildsnackbar(
                              context, "Error! Password Field is empty");
                        } else {
                          final data = ClipboardData(text: controller.text);
                          Clipboard.setData(data);

                          buildsnackbar(context, "Password Coppied");
                        }
                      },
                    ))),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
                height: 20,
                width: 150,
                child: Text(
                  "Password length: $value",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 10.0,
            ),
            Slider(
              onChanged: (double newvalue) {
                setState(() {
                  value = newvalue.round();
                });
              },
              min: 8,
              max: 50,
              divisions: 42,
              value: value.toDouble(),
              label: "length : $value",
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildButton(),
                const SizedBox(
                  width: 20.0,
                ),
                IconButton(
                  onPressed: () {
                    controller.text = "";
                  },
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        showbottomsheet();
                      });
                    },
                    icon: const Icon(Icons.settings)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildbottom() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: Text(
          "Setting",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )),
        StatefulBuilder(
          builder: (BuildContext context, setState) => CheckboxListTile(
            value: hasNumbers,
            title: const Text("Numbers"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? newValue) {
              setState(() {
                hasNumbers = newValue!;
              });
            },
          ),
        ),
        StatefulBuilder(
          builder: (BuildContext context, setState) => CheckboxListTile(
            value: hasUpercase,
            title: const Text("Upper Case"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? newValue) {
              setState(() {
                hasUpercase = newValue!;
              });
            },
          ),
        ),
        StatefulBuilder(
          builder: (BuildContext context, setState) => CheckboxListTile(
            value: hasLowerCase,
            title: const Text("Lower Case"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? newValue) {
              setState(() {
                hasLowerCase = newValue!;
              });
            },
          ),
        ),
        StatefulBuilder(
          builder: (BuildContext context, setState) => CheckboxListTile(
            value: hasSpecial,
            title: const Text("Special Characters"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? newValue) {
              setState(() {
                hasSpecial = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  showbottomsheet() {
    showModalBottomSheet(
      backgroundColor: const Color(0xFF737373),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.32,
          builder: (BuildContext context, ScrollController scrollController) =>
              Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                )),
            height: 200,
            child: buildbottom(),
          ),
        );
      },
    );
  }

  buildsnackbar(BuildContext conetxt, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.cyan,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentMaterialBanner()
      ..showSnackBar(snackbar);
  }

  Widget buildButton() {
    return ElevatedButton(
      child: const Text("Generate"),
      onPressed: () {
        final password = generatePasswrod();

        controller.text = password;
        setState(() {});
      },
    );
  }

  String generatePasswrod() {
    String capitalalphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String smallalphabets = 'abcdefghijklmnopqrstuvwxyz';
    String numbers = '0123456789';
    String special = '!@#\$%^&*()_+/.,`';
    String chars = '';
    chars += hasUpercase == true ? capitalalphabets : "";
    chars += hasNumbers == true ? numbers : "";
    chars += hasLowerCase == true ? smallalphabets : "";
    chars += hasSpecial == true ? special : "";

    if (chars.isEmpty) {
      buildsnackbar(context, "Please select any option in Setting ");
      return '';
    }

    return List.generate(
      value,
      (index) {
        final random = Random().nextInt(chars.length);
        return chars[random];
      },
    ).join('');
  }
}
