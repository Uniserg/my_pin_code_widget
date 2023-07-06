import 'package:flutter/material.dart';
import 'package:my_pin_code_widget/src/flutter_pin_code_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  get newPin => PinCodeWidget(
        onFilledPin: (String pin) {},
        onAuth: (pin) async => pin == "1234",
        pinLen: 4,
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Введите код-пароль",
                      style: TextStyle(
                          fontSize: 24, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                        // width: 400,
                        // height: 650,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(8),
                        child: newPin),
                  ),
                  // const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Не можете войти?",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
