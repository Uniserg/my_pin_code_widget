import 'package:flutter/material.dart';
import 'package:my_pin_code_widget/pin_new/flutter_pin_code_widget_new.dart';
import 'package:my_pin_code_widget/pin_old/flutter_pin_code_widget_old.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  get newPin => PinCodeWidgetNew(
        onChangedPin: (String pin) {},
        onEnter: (String pin, PinCodeWidgetNewState<PinCodeWidgetNew> state) {},
        pinLen: 4,
      );

  get oldPin => PinCodeWidgetOld(
        onChangedPin: (String pin) {},
        initialPinLength: 4,
        onFullPin:
            (String pin, PinCodeWidgetOldState<PinCodeWidgetOld> state) {},
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 150),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: newPin),
        ),
      ),
    );
  }
}
