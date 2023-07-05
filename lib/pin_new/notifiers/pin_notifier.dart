import 'package:flutter/material.dart';

class PinNotifier extends ChangeNotifier {
  int pinCap;
  int _pinLen = 0;
  final List<int> _pin;

  bool animate = false;

  PinNotifier(this.pinCap) : _pin = List.filled(pinCap, 0);

  String get pin => _pin.take(_pinLen).join();
  int get pinLen => _pinLen;

  void addNum(int num) {
    animate = false;
    _pin[_pinLen] = num;
    _pinLen++;

    notifyListeners();
  }

  void clear() {
    _pinLen = 0;
    notifyListeners();
  }

  void pop() {
    if (_pinLen > 0) {
      _pinLen--;
      notifyListeners();
    }
  }

  void runleInflateAnimation() {
    Future.delayed(const Duration(milliseconds: 60)).then((value) {
      animate = true;
      notifyListeners();
    });
  }
}