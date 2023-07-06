import 'package:flutter/material.dart';
import 'package:my_pin_code_widget/src/notifiers/pin_notifier.dart';


/// Pin-code field with hiding points
class PinNumbersStyle {
  /// Defines size of points
  final double pinSize;
  /// Defines coefficient size factor of inflate animation
  final double pinInflateRatio;
  /// Defines distanse between points
  final double pinSpacing;
  /// Defines point color
  final Color? pinColor;
  /// Defines color on failure authenticaton 
  final Color? failedPinColor;

  const PinNumbersStyle({
    this.pinSize = 20,
    this.pinInflateRatio = 1.5,
    this.pinSpacing = 15,
    this.pinColor,
    this.failedPinColor,
  });

  Color getPinPrimaryColor(context) =>
      pinColor ?? Theme.of(context).primaryColor;

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

  Color getPinColor(context) =>
      (pinNotifier.isAuth == null || pinNotifier.isAuth)
          ? style.getPinPrimaryColor(context)
          : style.getPinFailedColor(context);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pinNotifier,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          height: style.pinSize * style.pinInflateRatio,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: List.generate(pinNotifier.pinLen, (index) {
              var size = style.pinSize;
              var inflateRatio = style.pinInflateRatio;

              if (index == pinNotifier.pinLen - 1) {
                return AnimatedContainer(
                  margin: EdgeInsets.only(
                      right: style.pinSpacing, left: style.pinSpacing),
                  width: pinNotifier.inflate ? size : size * inflateRatio,
                  height: !pinNotifier.inflate ? size : size * inflateRatio,
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
                    right: style.pinSpacing, left: style.pinSpacing),
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
      },
    );
  }
}
