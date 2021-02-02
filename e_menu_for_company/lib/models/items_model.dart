import 'package:flutter/material.dart';

class ItemsModel extends ChangeNotifier {
  bool _checkedValue = false;
  List _menuItemsAndPricesToPost = [];
  List _allItemsAndPricesWidgets = [];

  void setCheckedValue(bool value) {
    this._checkedValue = value;
    notifyListeners();
  }

  bool getCheckedValue() {
    return this._checkedValue;
  }

  List getMenuItemsAndPricesSetToPost() {
    return this._menuItemsAndPricesToPost;
  }

  void addMenuItemsAndPricesSetToPost({@required List values}) {
    this._menuItemsAndPricesToPost.add(values);
    notifyListeners();
  }

  void removeAtMenuItemsAndPricesSetToPost({@required int index}) {
    this._menuItemsAndPricesToPost.removeAt(index);
    notifyListeners();
  }

  List getAllItemsAndPricesWidgets() {
    return this._allItemsAndPricesWidgets;
  }

  void removeAtAllItemsAndPricesWidgets({@required int index}) {
    this._allItemsAndPricesWidgets.removeAt(index);
    notifyListeners();
  }

  void insertAllItemsAndPricesWidgets(
      {List<int> indexes, List<Widget> widgets}) {
    for (int i = 0; i < indexes.length; i++) {
      this._allItemsAndPricesWidgets.insert(indexes[i], widgets[i]);
    }
    notifyListeners();
  }


  void reset(){
    this._checkedValue = false;
    this._allItemsAndPricesWidgets.clear();
    this._menuItemsAndPricesToPost.clear();
    notifyListeners();
  }
}
