import 'package:flutter/material.dart';
import 'package:flutter_seekbar/seekbar/seekbar.dart';

class generatepassword extends StatefulWidget {
  const generatepassword({Key? key}) : super(key: key);

  @override
  State<generatepassword> createState() => _generatepasswordState();
}

class _generatepasswordState extends State<generatepassword> {
  final controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double v = 10.0;
    return Container(
      padding: const EdgeInsets.all(32.0),
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
              controller: controller,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {},
                  ))),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
              width: 200,
              child: SeekBar(
                progresseight: 10,
                indicatorRadius: 0.0,
                value: v,
                isRound: false,
                progressColor: Colors.red,
              )),
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
    return "abccccc";
  }
}
