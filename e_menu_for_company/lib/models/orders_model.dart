import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class OrdersModel extends ChangeNotifier {
  List _orders = [];

  List getOrders() {
    return this._orders;
  }

  void removeOrder(int index) {
    this._orders.removeAt(index);
    if (this._orders == null) {
      this._orders = [];
    }
    notifyListeners();
  }

  Future getOrdersFromDB() async {
    return await RESTCalls.get(
        'order/?restaurant=${panelObj.getCameraResult()}');
  }

  Stream<List> getLiveData() async* {
    while (true) {
      this._orders = await getOrdersFromDB();
      yield this._orders;
      await Future.delayed(Duration(seconds: 30));
    }
  }
}
