import 'package:flutter/foundation.dart';

import 'package:e_menu/screens/main_screens/main_page.dart';

class OrderModel extends ChangeNotifier{

  void rebuild(){
    notifyListeners();
  }

  void addToOrder(
      {@required String item, @required String note, @required double price}) {
    orderObj.addToOrder(item: item, note: note, price: price);
    notifyListeners();
  }

  void removeFromOrder(int index) {
    orderObj.removeFromOrder(index);
    notifyListeners();
  }

  void setURL(String url){
    menuObj.setMenuURL(url);
    notifyListeners();
  }


}
