import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PointNotifier extends ChangeNotifier {
  bool _inflate = false;
  bool _filled = false;
  bool joggle = false;
  int num = 0;

  PointNotifier(this.num);

  bool get filled => _filled;

  set filled(bool filled) {
    _filled = filled;
    notifyListeners();
  }

  bool get inflate => _inflate;

  set inflate(bool inflate) {
    _inflate = inflate;
    notifyListeners();
  }

  void runInflateAnitmation() {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      // TODO: разобраться с этим
      inflate = false;
    });
    inflate = true;
  }

  void runJoggleAnitmation() {
    joggle = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      joggle = false;
    });
  }
}

class PinNotifier extends ChangeNotifier {
  int pinCap;
  int _pinLen = 0;
  final List<PointNotifier> _pin;
  bool joggle = false;
  bool isFilled = false;
  bool? _isAuth;

  PinNotifier(this.pinCap)
      : _pin = List.generate(pinCap, (index) => PointNotifier(0));

  String get pin => _pin.take(_pinLen).map((e) => e.num).join();

  List<PointNotifier> get pointers => _pin;

  int get pinLen => _pinLen;

  set isAuth(auth) {
    _isAuth = auth;

    notifyListeners();

    if (_isAuth != null && !_isAuth!) {
      HapticFeedback.heavyImpact();
      for (var p in _pin) {
        p.runJoggleAnitmation();
      }
    }
  }

  bool? get isAuth => _isAuth;

  void addNum(int num) {
    if (_pinLen >= pinCap) return;

    var point = _pin[_pinLen];
    point.num = num;
    _pinLen++;

    if (_pinLen == pinCap) {
      isFilled = true;
    }

    point.filled = true;
    point.runInflateAnitmation();

    notifyListeners();
  }

  void clear() {
    isFilled = false;
    isAuth = null;
    _pinLen = 0;

    for (var point in _pin) {
      point.filled = false;
    }
  }

  void pop() {
    isFilled = false;
    if (_pinLen > 0) {
      _pin[_pinLen - 1].filled = false;
      _pinLen--;
    }
  }
}
