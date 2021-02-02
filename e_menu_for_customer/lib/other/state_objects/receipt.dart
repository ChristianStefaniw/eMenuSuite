import 'package:flutter/material.dart';

class ReceiptObj {
  double _receiptTotal;
  double _tip;
  double _amountTaxed;
  String _phoneNum;
  String _cameraScanResults;
  List _receipt = [];

  void setReceiptTotal(double total) => this._receiptTotal = total;

  void setPhoneNum(String phoneNum) => this._phoneNum = phoneNum;

  void setCameraScanResults(String result) => this._cameraScanResults = result;

  void setTip(double tip) => this._tip = tip;

  void setAmountTaxed(double taxed) => this._amountTaxed = taxed;

  void addToReceipt(
          {@required String item,
          @required String note,
          @required double price}) =>
      this._receipt.add({'item': item, 'note': note, 'price': price});



  String getPhoneNum() => this._phoneNum;

  String getCameraScanResults() => this._cameraScanResults;

  double getTip() => this._tip;

  double getAmountTaxed() => this._amountTaxed;

  double getReceiptTotal() => this._receiptTotal;

  List getReceipt() => this._receipt;

  void reset() {
    this._receiptTotal = null;
    this._amountTaxed = null;
    this._receipt.clear();
    this._tip = null;
    this._phoneNum = null;
    this._cameraScanResults = null;
  }
}
