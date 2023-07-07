import 'package:flutter/material.dart';

class KeyboardStyle {
  final Color? deleteButtonColor;
  final Color? onPressColorAnimation;
  final Color? buttonColor;
  final Icon deleteIcon;
  final TextStyle? numberStyle;
  final BorderSide? borderSide;
  final double width;
  final double height;
  final double horizontalSpacing;
  final double verticalSpacing;

  const KeyboardStyle(
      {this.width = 400,
      this.height = 600,
      this.horizontalSpacing = 20,
      this.verticalSpacing = 20,
      this.deleteButtonColor,
      this.onPressColorAnimation,
      this.buttonColor,
      this.deleteIcon = const Icon(Icons.backspace_outlined),
      this.numberStyle,
      this.borderSide});

  Color getButtonColor(BuildContext context) =>
      buttonColor ?? Theme.of(context).primaryColor;
  Color getDeleteButtonColor(BuildContext context) =>
      deleteButtonColor ?? Theme.of(context).colorScheme.error;
  Color getOnPressColorAnimation(BuildContext context) =>
      onPressColorAnimation ?? Theme.of(context).primaryColorLight;
  BorderSide getBorderSide(BuildContext context) =>
      borderSide ??
      BorderSide(color: Theme.of(context).colorScheme.onPrimary, width: 2);
  TextStyle? getNumberStyle(BuildContext context) =>
      numberStyle ?? Theme.of(context).primaryTextTheme.displayMedium;
}

class KeyboardWidget extends StatelessWidget {
  const KeyboardWidget(
      {super.key,
      this.keyboardStyle = const KeyboardStyle(),
      this.onPressed,
      this.onDeletePressed,
      this.authButton});

  final KeyboardStyle keyboardStyle;
  final Function()? onDeletePressed;
  final Function(int)? onPressed;

  final Widget? authButton;

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
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            12,
            (index) {
              if (index == 9) return authButton ?? Container();
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
