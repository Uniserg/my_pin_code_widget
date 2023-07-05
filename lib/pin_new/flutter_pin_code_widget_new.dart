import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_pin_code_widget/pin_new/widgets/keyboard.dart';

class PinCodeWidgetNew extends StatefulWidget {
  const PinCodeWidgetNew(
      {super.key,
      required this.pinLen,
      required this.onFilledPin,
      this.pinColor,
      this.keyboardStyle,
      this.pinSize = 20,
      this.pinInflateRatio = 1.5,
      this.pinSpacing = 15,
      this.marginPincode = const EdgeInsets.only(bottom: 10),
      this.authButton});

  final KeyboardStyle? keyboardStyle;

  final Widget? authButton;

  final void Function(String pin) onFilledPin;

  final int pinLen;

  final double pinSize;

  final double pinInflateRatio;

  final double pinSpacing;

  final EdgeInsets marginPincode;

  final Color? pinColor;

  @override
  State<StatefulWidget> createState() => PinCodeWidgetNewState();
}

class PinCodeWidgetNewState<T extends PinCodeWidgetNew> extends State<T> {
  final ScrollController listController = ScrollController();

  late String pin;
  bool animate = false;

  int get currentPinLength => pin.length;

  @override
  void initState() {
    super.initState();
    pin = '';
  }

  void reset() => setState(() {
        pin = '';
      });

  void _onPressed(int num) async {
    if (currentPinLength >= widget.pinLen) {
      await HapticFeedback.heavyImpact();
      return;
    }
    setState(() {
      animate = false;

      pin += num.toString();
      
      widget.onFilledPin(pin);
    });
    Future.delayed(const Duration(milliseconds: 60)).then((value) {
      setState(() {
        animate = true;
      });
    });
    listController.jumpTo(listController.position.maxScrollExtent);
  }

  void _onRemove() {
    if (currentPinLength == 0) {
      return;
    }
    setState(() => pin = pin.substring(0, pin.length - 1));
  }

  Color getPinColor(context) =>
      widget.pinColor ?? Theme.of(context).primaryColor;

  Widget get pinCode => SizedBox(
        height: widget.pinSize * widget.pinInflateRatio,
        child: ListView(
          controller: listController,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: List.generate(pin.length, (index) {
            var size = widget.pinSize;
            var inflateRatio = widget.pinInflateRatio;

            if (index == pin.length - 1) {
              return AnimatedContainer(
                margin: EdgeInsets.only(
                    right: widget.pinSpacing, left: widget.pinSpacing),
                width: animate ? size : size * inflateRatio,
                height: !animate ? size : size * inflateRatio,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getPinColor(context),
                ),
              );
            }
            return Container(
              margin: EdgeInsets.only(
                  right: widget.pinSpacing, left: widget.pinSpacing),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getPinColor(context),
              ),
            );
          }),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: widget.marginPincode,
          child: pinCode,
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
