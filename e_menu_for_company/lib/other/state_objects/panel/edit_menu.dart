import 'package:flutter/material.dart';

class EditMenu{

  TextEditingController _textControllerItemSelected = new TextEditingController();

  TextEditingController _textControllerItemEdit = new TextEditingController();

  TextEditingController _textControllerPriceEdit = new TextEditingController();

  final GlobalKey _formKeySelectItem = GlobalKey<FormState>();

  final GlobalKey _formKeyItemEditPrice = GlobalKey<FormState>();
  final GlobalKey _formKeyItemEditName = GlobalKey<FormState>();

  final GlobalKey _formKeyItemCreateName= GlobalKey<FormState>();
  final GlobalKey _formKeyItemCreatePrice = GlobalKey<FormState>();


  String _itemBeingEdited;


  bool _successfulUpload = false;

  bool _noteRequired;


  GlobalKey get formKeyItemCreateName{
    return this._formKeyItemCreateName;
  }

  GlobalKey get formKeyItemCreatePrice{
    return this._formKeyItemCreatePrice;
  }

  GlobalKey get formKeyItemEditPrice{
    return this._formKeyItemEditPrice;
  }

  GlobalKey get formKeyItemEditName{
    return this._formKeyItemEditName;
  }

  GlobalKey get formKeySelectItem{
    return this._formKeySelectItem;
  }

  bool get noteRequired{
    return this._noteRequired;
  }

  void setNoteRequired(bool value){
    this._noteRequired = value;
  }

  bool get successfulUpload{
    return this._successfulUpload;
  }

  void setSuccessfulUpload(bool value){
    this._successfulUpload = value;
  }


  void setItemBeingEdited(String item){
    this._itemBeingEdited = item;
  }

  String get itemBeingEdited{
    return this._itemBeingEdited;
  }

  TextEditingController get textControllerItemSelected{
    return this._textControllerItemSelected;
  }

  String get textControllerItemSelectedText{
    return this._textControllerItemSelected.text;
  }

  void setTextControllerItemSelectedText(String text){
    this._textControllerItemSelected.text = text;
  }

  TextEditingController get textControllerItemEdit{
    return this._textControllerItemEdit;
  }

  String get textControllerItemEditText{
    return this._textControllerItemEdit.text;
  }

  void setTextControllerItemEditText(String text){
    this._textControllerItemEdit.text = text;
  }

  TextEditingController get textControllerPriceEdit{
    return this._textControllerPriceEdit;
  }

  String get textControllerPriceEditText{
    return this._textControllerPriceEdit.text;
  }

  void setTextControllerPriceEditText(String text){
      this._textControllerPriceEdit.text = text;
  }


  void reset(){
    this.setTextControllerItemEditText('');
    this.setTextControllerPriceEditText('');
    this.setTextControllerItemSelectedText('');
    this.setItemBeingEdited('');
    this.setSuccessfulUpload(false);
  }

}