import 'package:flutter/foundation.dart';

class TipModel extends ChangeNotifier{

  double _tip = 0;

  double getTip() {
    return this._tip;
  }

  void setTip(double tip) {
    this._tip = tip;
    notifyListeners();
  }
}