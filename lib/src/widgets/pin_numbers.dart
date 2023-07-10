import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_pin_code_widget/src/notifiers/pin_notifier.dart';
import 'package:my_pin_code_widget/src/widgets/point_number.dart';

class PinNumbersStyle {
  final double pinSize;

  final double pinInflateRatio;

  final double pinJoggleRatio;

  final double pinSpacing;

  final Color? filledPinColor;

  final Color? failedPinColor;

  final Color? unfilledPinColor;

  const PinNumbersStyle({
    this.pinSize = 25,
    this.pinInflateRatio = 1.5,
    this.pinJoggleRatio = 1.5,
    this.pinSpacing = 20,
    this.filledPinColor,
    this.failedPinColor,
    this.unfilledPinColor = Colors.transparent,
  });

  Color getPinPrimaryColor(context) =>
      filledPinColor ?? Theme.of(context).primaryColor;

  Color getPinFailedColor(context) =>
      failedPinColor ?? Theme.of(context).colorScheme.error;
}

class PinNumbersWidget extends StatelessWidget {
  const PinNumbersWidget(
      {super.key,
      required this.pinLen,
      this.style = const PinNumbersStyle(),
      required this.pinNotifier});

  final PinNotifier pinNotifier;

  final int pinLen;

  final PinNumbersStyle style;

  Color getPinColor(BuildContext context) {
    return (pinNotifier.isAuth == null || pinNotifier.isAuth!)
        ? style.getPinPrimaryColor(context)
        : style.getPinFailedColor(context);
  }

  @override
  Widget build(BuildContext context) {
    double size = max(style.pinSize * style.pinInflateRatio, style.pinJoggleRatio * style.pinSpacing);

    return AnimatedBuilder(
      animation: pinNotifier,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          height: size,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: List.generate(pinNotifier.pinCap, (index) {
              var curPoint = pinNotifier.pointers[index];

              return PointNumber(
                  pointNotifier: curPoint,
                  style: style,
                  pinNotifier: pinNotifier);
            }),
          ),
        );
      },
    );
  }
}
