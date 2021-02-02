import 'dart:io';
import 'package:flutter/cupertino.dart';


class NewMenu {
  String _restaurantName = '';

  TextEditingController _textControllerName = new TextEditingController();

  TextEditingController _textControllerPrice = new TextEditingController();

  TextEditingController _textControllerItem = new TextEditingController();

  TextEditingController _textControllerPassword = new TextEditingController();

  TextEditingController _textControllerTax = new TextEditingController();

  File _menuFile;

  File _logo;

  String _stripeID;

  final GlobalKey _formKeyTax = GlobalKey<FormState>();
  final GlobalKey _formKeyPass = GlobalKey<FormState>();
  final GlobalKey _formKeyRestaurantName = GlobalKey<FormState>();
  final GlobalKey _formKeyItemPrice = GlobalKey<FormState>();
  final GlobalKey _formKeyItemName = GlobalKey<FormState>();

  String _currency;


  //getters and setters

  void setCurrency(String currency){
    this._currency = currency;
  }
  String get currency{
    return this._currency;
  }

  GlobalKey get itemNameKey{
    return this._formKeyItemName;
  }

  GlobalKey get restaurantNameKey{
    return this._formKeyRestaurantName;
  }

  GlobalKey get itemPriceKey{
    return this._formKeyItemPrice;
  }

  GlobalKey get taxKey{
    return this._formKeyTax;
  }

  GlobalKey get passKey{
    return this._formKeyPass;
  }

  String get textControllerTaxText{
    return this._textControllerTax.text;
  }

  TextEditingController get textControllerTax{
    return this._textControllerTax;
  }

  String get stripeID{
    return this._stripeID;
  }

  void setStripeID(String stripeID){
    this._stripeID = stripeID;
  }

  String get restaurantName{
    return this._restaurantName;
  }

  void setRestaurantName(String restaurantName){
    this._restaurantName = restaurantName;
  }


  TextEditingController get textControllerName{
    return this._textControllerName;
  }

  String get textControllerNameText{
    return this._textControllerName.text;
  }


  TextEditingController get textControllerPrice{
    return this._textControllerPrice;
  }

  String  get textControllerPriceText{
    return this._textControllerPrice.text;
  }

  void setTextControllerPriceText(String value){
    this._textControllerPrice.text = value;
  }


  TextEditingController get textControllerItem{
    return this._textControllerItem;
  }

  String get textControllerItemText{
    return this._textControllerItem.text;
  }

  void setTextControllerItemText(String value){
    this._textControllerItem.text = value;
  }


  TextEditingController get textControllerPassword{
    return this._textControllerPassword;
  }

  String get textControllerPasswordText{
    return this._textControllerPassword.text;
  }


  File get menuFile{
    return this._menuFile;
  }

  void setMenuFile(File file){
    this._menuFile = file;
  }


  File get logo{
    return this._logo;
  }

  void setLogo(File file){
    this._logo = file;
  }



  void reset(){
    this.setRestaurantName('');
    this.setTextControllerPriceText(null);
    this.setTextControllerItemText(null);
    this.setMenuFile(null);
    this.setLogo(null);
    this.setCurrency(null);
    this.setStripeID(null);
  }

}
