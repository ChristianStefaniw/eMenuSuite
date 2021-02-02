import 'package:e_menu/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderObj {
  int _tableNum;
  String _phoneNum = '';
  String _cameraResult = '';
  TextEditingController _textControllerTableNum = new TextEditingController();
  TextEditingController _textControllerPhoneNum = new TextEditingController();
  String _tod = '';
  double _amountTaxed;
  double _totalCost = 0;
  double _tip = 0;
  List _order = [];
  OrderModel _model;

  void setModel(OrderModel model) => this._model = model;

  void addToOrder(
          {@required String item,
          @required String note,
          @required double price}) =>
      this._order.add({'item': item, 'note': note, 'price': price});

  void removeFromOrder(int index) => this._order.removeAt(index);

  void setTip(double tip) => this._tip = tip;

  void setTotalCost(double totalCost) => this._totalCost = totalCost;

  void setAmountTaxed(double taxed) => this._amountTaxed = taxed;

  void setCameraScanResults(var value) => this._cameraResult = value;

  void setTableNum(int table) => this._tableNum = table;

  void setPhoneNum(String phoneNum) => this._phoneNum = phoneNum;

  void setTOD(String tod) => this._tod = tod;

  OrderModel getModel() => this._model;

  List getOrder() => this._order;

  double getTip() => this._tip;

  double getTotalCost() => this._totalCost;

  double getAmountTaxed() => this._amountTaxed;

  String getCameraScanResults() => this._cameraResult;

  int getTableNum() => this._tableNum;

  String getPhoneNum() => this._phoneNum;

  String getTOD() => this._tod;

  TextEditingController getTextControllerTableNum() =>
      this._textControllerTableNum;

  String getTextControllerTableNumText() => this._textControllerTableNum.text;

  TextEditingController getTextControllerPhoneNum() =>
      this._textControllerPhoneNum;

  String getTextControllerPhoneNumText() => this._textControllerPhoneNum.text;

  void reset() {
    this._tableNum = null;
    this._phoneNum = '';
    this._tod = '';
    this._order.clear();
    this._textControllerPhoneNum.text = '';
    this._textControllerTableNum.text = '';
  }
}
