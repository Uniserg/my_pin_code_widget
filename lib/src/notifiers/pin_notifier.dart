import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinNotifier extends ChangeNotifier {
  int pinCap;
  int _pinLen = 0;
  final List<int> _pin;

  bool inflate = false;
  bool joggle = false;
  bool isFilled = false;
  bool? _isAuth;

  PinNotifier(this.pinCap) : _pin = List.filled(pinCap, 0);

  String get pin => _pin.take(_pinLen).join();
  int get pinLen => _pinLen;

  set isAuth(auth) {
    _isAuth = auth;

    notifyListeners();

    if (_isAuth != null && !_isAuth!) {
      HapticFeedback.heavyImpact();
      runJoggleAnimation();
    }
  }

  get isAuth => _isAuth;

  void addNum(int num) {
    inflate = false;
    _pin[_pinLen] = num;
    _pinLen++;

    if (_pinLen == pinCap) {
      isFilled = true;
    }

    notifyListeners();

    runInflateAnimation();
  }

  void clear() {
    _pinLen = 0;
    isFilled = false;
    _isAuth = null;

    notifyListeners();
  }

  void pop() {
    if (_pinLen > 0) {
      _pinLen--;
      notifyListeners();
    }
  }

  void runInflateAnimation() {
    Future.delayed(const Duration(milliseconds: 60)).then((value) {
      inflate = true;
      notifyListeners();
    });
  }

  void runJoggleAnimation() {
    Future.delayed(const Duration(milliseconds: 60)).then((value) {
      joggle = true;
      notifyListeners();
    });
  }
}
