import 'net/rest_calls.dart';

import 'package:e_menu/screens/main_screens/main_page.dart';

class ScanQR{
  static Future scan(String cameraScanResult) async{

    List _contents = [];
    List _total = [];

    try {
      _contents = await RESTCalls.get('item/?restaurant=$cameraScanResult');
    } catch (DioError) {}

    if (_contents.isEmpty) {
      return false;
    }

    menuObj.resetMenuItems();
    Map _restaurant =
        await RESTCalls.get('restaurant/?name=${orderObj.getCameraScanResults()}').then((value) => value[0]);


    menuObj.setTax(_restaurant['tax']);

    String _stripeID = _restaurant['stripeid'];
    menuObj.setRestaurantStripeAccount(_stripeID);

    orderObj.setCameraScanResults(cameraScanResult);
    menuObj.setFullQuery(_contents);

    for (int i = 0; i < _contents.length; i++) {
      _total.add({'item': _contents[i]['item'], 'price': _contents[i]['price']});
    }


    menuObj.setItemsAndPrices(_total);


  }
}