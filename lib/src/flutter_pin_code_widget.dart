import 'package:flutter/material.dart';
import 'package:my_pin_code_widget/src/notifiers/pin_notifier.dart';
import 'package:my_pin_code_widget/src/widgets/keyboard.dart';
import 'package:my_pin_code_widget/src/widgets/pin_numbers.dart';

class PinCodeWidget extends StatefulWidget {
  const PinCodeWidget({
    super.key,
    required this.pinLen,
    required this.onFilledPin,
    required this.onAuth,
    this.keyboardStyle = const KeyboardStyle(),
    this.marginPincode = const EdgeInsets.only(bottom: 0),
    this.authButton,
    this.pinNumbersStyle = const PinNumbersStyle(),
    this.onFailureHint = const SizedBox(),
  });

  final KeyboardStyle keyboardStyle;

  final Widget onFailureHint;

  final PinNumbersStyle pinNumbersStyle;

  final Widget? authButton;

  final void Function(String pin) onFilledPin;

  final Future<bool> Function(String pin) onAuth;

  final int pinLen;

  final EdgeInsets marginPincode;

  @override
  State<StatefulWidget> createState() => PinCodeWidgetState();
}

class PinCodeWidgetState<T extends PinCodeWidget> extends State<T> {
  late PinNotifier pinNotifier = PinNotifier(widget.pinLen);

  @override
  void dispose() {
    pinNotifier.dispose();
    super.dispose();
  }

  void _onPressed(int num) async {
    pinNotifier.addNum(num);

    if (pinNotifier.isFilled) {
      var isAuth = await widget.onAuth(pinNotifier.pin);
      pinNotifier.isAuth = isAuth;

      // if (!isAuth) {
      //   Future.delayed(const Duration(milliseconds: 1000), () {
      //     pinNotifier.clear();
      //   });

      Future.delayed(const Duration(milliseconds: 1000), () {
        pinNotifier.clear();
      });
    }
  }

  void _onRemove() {
    if (pinNotifier.pinLen == 0) {
      return;
    }
    pinNotifier.pop();
  }

  bool get isFailure => !(pinNotifier.isAuth == null || pinNotifier.isAuth!);

  // Widget get titleHint => isFailure ? widget.onFailureHint : const SizedBox();

  get keyboard => KeyboardWidget(
        onPressed: _onPressed,
        keyboardStyle: widget.keyboardStyle,
        onDeletePressed: _onRemove,
        authButton: ElevatedButton(
          // заменить
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              side: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary, width: 2)),
          onPressed: () {},
          child: const Icon(
            Icons.fingerprint,
            size: 32,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: pinNotifier,
          builder: (BuildContext context, Widget? child) => Visibility(
            visible: isFailure,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: widget.onFailureHint,
          ),
        ),
        Container(
          margin: widget.marginPincode,
          child: PinNumbersWidget(
            pinLen: widget.pinLen,
            pinNotifier: pinNotifier,
            style: widget.pinNumbersStyle,
          ),
        ),
        AnimatedBuilder(
          animation: pinNotifier,
          builder: (BuildContext context, Widget? child) => AbsorbPointer(
            absorbing: pinNotifier.isFilled,
            child: keyboard,
          ),
        ),
      ],
    );
  }
}
