import 'Encode.dart';
import 'net/rest_calls.dart';
import 'package:e_menu/screens/main_screens/main_page.dart';

class CreateReceipt {

  final phone;
  CreateReceipt({this.phone});


  Future getPrices(List itemsAsList) async{

    List temp = [];

    List _allItems = await RESTCalls.get(
        'item/?restaurant=${receiptObj.getCameraScanResults()}');

    for (int i = 0; i < itemsAsList.length; i++) {
      _allItems.forEach((element) {
        if (itemsAsList.contains(element['item'])) {
          temp.add(element['price']);
        }
      });
    }

    return temp;
  }


  Future createReceipt() async {
    List _itemsAsList = [];
    List _notesAsList = [];
    List _pricesAsList = [];


    dynamic _order = await RESTCalls.get(
        'order/?restaurant=${receiptObj.getCameraScanResults()}&phonenum=${Encode.encodePhone(phone)}');

    if (_order.isEmpty) {
      return false;
    }

    _order = _order[0];

    _order['items'] = _order['items'].substring(0, _order['items'].length-1);
    _order['notes'] = _order['notes'].substring(0, _order['notes'].length-1);

    _itemsAsList = _order['items'].split("*");
    _notesAsList = _order['notes'].split("*");

    _pricesAsList = await getPrices(_itemsAsList);


    for (int i = 0; i < _itemsAsList.length; i++) {
      receiptObj.addToReceipt(
          item: _itemsAsList[i],
          note: _notesAsList[i],
          price: _pricesAsList[i]);
    }

    receiptObj.setReceiptTotal(_order['cost']);
    receiptObj.setTip(_order['tip']);
    receiptObj.setAmountTaxed(_order['tax']);
    receiptObj.setPhoneNum(phone);

    return true;
  }
}