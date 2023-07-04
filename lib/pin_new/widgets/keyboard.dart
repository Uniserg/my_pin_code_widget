import 'package:flutter/material.dart';

class KeyboardStyle {
  final Color? _deleteButtonColor;
  final Color? _onPressColorAnimation;
  final Color? _buttonColor;
  final Icon _deleteIcon;
  final TextStyle? _numberStyle;
  final BorderSide? _borderSide;
  final double width;
  final double height;
  final double horizontalSpacing;
  final double verticalSpacing;

  const KeyboardStyle(
      {this.width = 400,
      this.height = 600,
      this.horizontalSpacing = 30,
      this.verticalSpacing = 30,
      deleteButtonColor,
      onPressColorAnimation,
      buttonColor,
      deleteIcon,
      numberStyle,
      borderSide})
      : _deleteButtonColor = deleteButtonColor,
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
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: keyboardStyle.width,
        height: keyboardStyle.height,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: keyboardStyle.verticalSpacing,
          crossAxisSpacing: keyboardStyle.horizontalSpacing,
          children: List.generate(
            12,
            (index) {
              if (index == 9) return Container();

              if (index == 11) {
                return MergeSemantics(
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
                );
              } else if (index == 10) {
                index = 0;
              } else if (index == 11) {
              } else {
                index++;
              }
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: keyboardStyle.getButtonColor(context),
                  foregroundColor:
                      keyboardStyle.getOnPressColorAnimation(context),
                  side: keyboardStyle.getBorderSide(context),
                  shape: const CircleBorder(),
                ),
                onPressed: () => onPressed!(index),
                child: Text('$index',
                    style: keyboardStyle.getNumberStyle(context)),
              );
            },
          ),
        ),
      ),
    );
  }
}
