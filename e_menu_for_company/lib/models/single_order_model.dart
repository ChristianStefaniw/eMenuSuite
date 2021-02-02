import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class SingleOrderModel extends ChangeNotifier {
  bool _checked;
  List _order;

  bool getCheckedVal() {
    return this._checked;
  }

  void setChecked(value) {
    this._checked = value;
  }

  List getOrder() {
    return this._order;
  }

  Future checkUncheck(bool newValue, String phonenum) async {
    FormData data = FormData.fromMap({'chosen': newValue});
    this._checked = newValue;
    await RESTCalls.update(
        'order/$phonenum/?restaurant=${panelObj.getCameraResult()}',
        data: data);

    notifyListeners();
  }

  Future removeOrder(String phonenum, BuildContext context) async {
    await RESTCalls.delete(
        'order/$phonenum/?restaurant=${panelObj.getCameraResult()}');

    notifyListeners();

    Navigator.of(context).pop();
  }

  Future getOrderFromDB(String phone) async {
    var _response = await RESTCalls.get(
        'order/?restaurant=${panelObj.getCameraResult()}&phonenum=$phone');

    if (_response.isEmpty) {
      return false;
    }

    this._checked = _response[0]['chosen'];
    return _response;
  }

  Stream<List> getLiveData(String phone) async* {
    while (true) {
      var _val = await getOrderFromDB(phone);
      if (_val == false) {
        break;
      } else {
        this._order = _val;
        yield this._order;
        await Future.delayed(Duration(seconds: 30));
      }
    }
  }
}
