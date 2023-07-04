import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:my_pin_code_widget/pin_new/widgets/keyboard.dart';

class PinCodeWidgetNew extends StatefulWidget {
  const PinCodeWidgetNew(
      {super.key,
      required this.onEnter,
      required this.pinLen,
      required this.onChangedPin,
      this.clearStream,
      this.centerBottomWidget,
      this.filledIndicatorColor,
      this.keyboardStyle,
      this.pinSize = 20,
      this.pinInflateRatio = 1.8,
      this.pinSpacing = 18, 
      this.marginPincode = EdgeInsets.zero,
      });

  final KeyboardStyle? keyboardStyle;

  /// Callback after all pins input
  final void Function(String pin, PinCodeWidgetNewState state) onEnter;

  /// Callback onChange
  final void Function(String pin) onChangedPin;

  /// Event for clear pin
  final Stream<bool>? clearStream;

  final int pinLen;

  final double pinSize;

  final double pinInflateRatio;

  final double pinSpacing;

  final EdgeInsets marginPincode;

  /// Any widgets on the empty place, usually - 'forgot?'
  final Widget? centerBottomWidget;

  /// filled pins color
  final Color? filledIndicatorColor;

  @override
  State<StatefulWidget> createState() => PinCodeWidgetNewState();
}

class PinCodeWidgetNewState<T extends PinCodeWidgetNew> extends State<T> {
  final _gridViewKey = GlobalKey();
  final _key = GlobalKey<ScaffoldState>();
  final ScrollController listController = ScrollController();

  late String pin;
  late double _aspectRatio;
  bool animate = false;

  int get currentPinLength => pin.length;

  @override
  void initState() {
    super.initState();
    pin = '';
    _aspectRatio = 1;

    if (widget.clearStream != null) {
      widget.clearStream!.listen((val) {
        if (val) {
          clear();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void clear() {
    if (_key.currentState?.mounted != null && _key.currentState!.mounted) {
      setState(() => pin = '');
    }
  }

  void reset() => setState(() {
        pin = '';
      });

  void calculateAspectRatio() {
    final renderBox =
        _gridViewKey.currentContext!.findRenderObject() as RenderBox;
    final cellWidth = renderBox.size.width / 3;
    final cellHeight = renderBox.size.height / 4;
    if (cellWidth > 0 && cellHeight > 0) {
      _aspectRatio = cellWidth / cellHeight;
    }

    setState(() {});
  }

  void changeProcessText(String text) {}

  void close() {
    Navigator.of(_key.currentContext!).pop();
  }

  Color getFilledIndicatorColor(context) =>
      widget.filledIndicatorColor ?? Theme.of(context).primaryColor;

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
                margin: EdgeInsets.only(right: widget.pinSpacing, left: widget.pinSpacing),
                width: animate ? size : size * inflateRatio,
                height: !animate ? size : size * inflateRatio,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getFilledIndicatorColor(context),
                ),
              );
            }
            return Container(
              margin: EdgeInsets.only(right: widget.pinSpacing, left: widget.pinSpacing),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getFilledIndicatorColor(context),
              ),
            );
          }),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _key,
        body: body(context),
        resizeToAvoidBottomInset: false,
      );

  Widget body(BuildContext context) {
    return MeasureSize(
      onChange: (size) {
        calculateAspectRatio();
      },
      child: Container(
        key: _gridViewKey,
        child: Column(
          children: [
            Container(
              margin: widget.marginPincode,
              child: pinCode,
              ),
            KeyboardWidget(onPressed: _onPressed, onDeletePressed: _onRemove),
            widget.centerBottomWidget != null
                ? Flexible(
                    flex: 2,
                    child: Center(child: widget.centerBottomWidget!),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _onPressed(int num) async {
    if (currentPinLength >= widget.pinLen) {
      await HapticFeedback.heavyImpact();
      return;
    }
    setState(() {
      animate = false;

      pin += num.toString();
      widget.onChangedPin(pin);
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

  void _afterLayout(dynamic _) {
    calculateAspectRatio();
  }
}

typedef OnWidgetSizeChange = void Function(Size size);

class _MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  _MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  /// Function to be called when layout changes
  final OnWidgetSizeChange onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }
}