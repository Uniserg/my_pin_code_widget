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
    this.marginPincode = const EdgeInsets.only(bottom: 10),
    this.authButton,
    this.pinNumbersStyle = const PinNumbersStyle(),
  });

  final KeyboardStyle keyboardStyle;

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pinNotifier.dispose();
    super.dispose();
  }

  void _refresh() {
    if (pinNotifier.isFilled) {
      pinNotifier.clear();
    }
  }

  void _onPressed(int num) async {
    _refresh();
    pinNotifier.addNum(num);

    if (pinNotifier.isFilled) {
      pinNotifier.isAuth = await widget.onAuth(pinNotifier.pin);
    }
  }

  void _onRemove() {
    _refresh();
    if (pinNotifier.pinLen == 0) {
      return;
    }
    pinNotifier.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: widget.marginPincode,
          child: PinNumbersWidget(
            pinLen: widget.pinLen,
            pinNotifier: pinNotifier,
            style: widget.pinNumbersStyle,
          ),
        ),
        KeyboardWidget(
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
        ),
      ],
    );
  }
}
