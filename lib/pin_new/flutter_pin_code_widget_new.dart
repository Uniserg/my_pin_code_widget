import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pin_code_widget/pin_new/notifiers/pin_notifier.dart';
import 'package:my_pin_code_widget/pin_new/widgets/keyboard.dart';
import 'package:my_pin_code_widget/pin_new/widgets/pin_numbers.dart';

class PinCodeWidgetNew extends StatefulWidget {
  const PinCodeWidgetNew({
    super.key,
    required this.pinLen,
    required this.onFilledPin,
    required this.onAuth,
    this.keyboardStyle,
    this.marginPincode = const EdgeInsets.only(bottom: 10),
    this.authButton,
    this.pinNumbersStyle = const PinNumbersStyle(),
  });

  final KeyboardStyle? keyboardStyle;

  final PinNumbersStyle pinNumbersStyle;

  final Widget? authButton;

  final void Function(String pin) onFilledPin;

  final Future<bool> Function(String pin) onAuth;

  final int pinLen;

  final EdgeInsets marginPincode;

  @override
  State<StatefulWidget> createState() => PinCodeWidgetNewState();
}

class PinCodeWidgetNewState<T extends PinCodeWidgetNew> extends State<T> {
  late PinNotifier pinNotifier;

  @override
  void initState() {
    pinNotifier = PinNotifier(widget.pinLen);
    super.initState();
  }

  @override
  void dispose() {
    pinNotifier.dispose();
    super.dispose();
  }

  // void runleInflateAnimation() {
  //   Future.delayed(const Duration(milliseconds: 60)).then((value) {
  //     setState(() {
  //       animate = true;
  //     });
  //   });
  // }

  // void runHeavyImpactAnimation() {
  //   Future.delayed(const Duration(milliseconds: 60)).then((value) {
  //     setState(() {
  //       animate = true;
  //     });
  //   });
  // }

  void _onPressed(int num) async {
    // if (currentPinLength >= widget.pinLen) {
    //   // await HapticFeedback.heavyImpact(); // зачем это????
    //   return;
    // }

    // if (isFilled) {
    //   getPinColor = widget.pinNumbersStyle.getPinPrimaryColor;
    //   setState(() {
    //     pinNotifier.clear();
    //     isFilled = false;
    //   });
    // }

    // setState(() {
    //   animate = false;
    //   pinNotifier.addNum(num);
    // });
    setState(() {
        pinNotifier.addNum(num);    
    });
    

    setState(() {
          Future.delayed(const Duration(milliseconds: 60)).then((value) {
      setState(() {
      pinNotifier.runleInflateAnimation();  
      });
    });   
    });
    

    // if (currentPinLength == widget.pinLen) {
    //   isFilled = true;
    //   bool isAuth = await widget.onAuth(pinNotifier.pin); // авторизация
    //   if (!isAuth) {
    //     getPinColor = widget.pinNumbersStyle.getPinFailedColor;
    //     await HapticFeedback.heavyImpact();
    //   }
    // }
  }

  void _onRemove() {
    if (pinNotifier.pinLen == 0) {
      return;
    }

    setState(() {
          pinNotifier.pop();      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: widget.marginPincode,
          child:
              PinNumbersWidget(pinLen: widget.pinLen, pinNotifier: pinNotifier, style: widget.pinNumbersStyle,),
        ),
        KeyboardWidget(
          onPressed: _onPressed,
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
