import 'package:flutter/material.dart';

class KeyboardStyle {
  final double _aspectRatio;
  final Color? _deleteButtonColor;
  final Color? _onPressColorAnimation;
  final Color? _buttonColor;
  final Icon _deleteIcon;
  final TextStyle? _numberStyle;
  final BorderSide? _borderSide;

  const KeyboardStyle(
      {aspectRatio,
      deleteButtonColor,
      onPressColorAnimation,
      buttonColor,
      deleteIcon,
      numberStyle,
      borderSide})
      : _aspectRatio = aspectRatio ?? 1,
        _deleteButtonColor = deleteButtonColor,
        _onPressColorAnimation = onPressColorAnimation,
        _buttonColor = buttonColor,
        _deleteIcon = deleteIcon ?? const Icon(Icons.arrow_back_rounded),
        _numberStyle = numberStyle,
        _borderSide = borderSide;

  Color getButtonColor(BuildContext context) =>
      _buttonColor ?? Theme.of(context).primaryColor;
  Color getDeleteButtonColor(BuildContext context) =>
      _deleteButtonColor ?? Theme.of(context).colorScheme.error;
  Color getOnPressColorAnimation(BuildContext context) =>
      _onPressColorAnimation ?? Theme.of(context).primaryColorLight;
  BorderSide getBorderSide(BuildContext context) =>
      _borderSide ??
      BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 2);
  TextStyle? getNumberStyle(BuildContext context) =>
      _numberStyle ?? Theme.of(context).primaryTextTheme.displayMedium;

  double get aspectRatio => _aspectRatio;
  Icon get deleteIcon => _deleteIcon;
}

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget({
    super.key,
    this.keyboardStyle = const KeyboardStyle(),
    this.onPressed,
    this.onDeletePressed,
  });

  final KeyboardStyle keyboardStyle;
  final Function()? onDeletePressed;
  final Function(int)? onPressed;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: keyboardStyle.aspectRatio,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        11,
        (index) {
          const double marginRight = 15;
          const double marginLeft = 15;
          const double marginBottom = 4;

          if (index == 9) {
            return Container(
              margin:
                  const EdgeInsets.only(left: marginLeft, right: marginRight),
              child: MergeSemantics(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        keyboardStyle.getDeleteButtonColor(context),
                    foregroundColor:
                        keyboardStyle.getOnPressColorAnimation(context),
                    side: keyboardStyle.getBorderSide(context),
                    shape: const CircleBorder(),
                  ),
                  onPressed: onDeletePressed,
                  child: keyboardStyle.deleteIcon,
                ),
              ),
            );
          } else if (index == 10) {
            index = 0;
          } else if (index == 11) {
          } else {
            index++;
          }
          return Container(
            margin: const EdgeInsets.only(
                left: marginLeft, right: marginRight, bottom: marginBottom),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: keyboardStyle.getButtonColor(context),
                foregroundColor:
                    keyboardStyle.getOnPressColorAnimation(context),
                side: keyboardStyle.getBorderSide(context),
                shape: const CircleBorder(),
              ),
              onPressed: () => onPressed!(index),
              child:
                  Text('$index', style: keyboardStyle.getNumberStyle(context)),
            ),
          );
        },
      ),
    );
  }
}
