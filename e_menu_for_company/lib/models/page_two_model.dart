import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:e_menu_for_company/screens/main_pages/page_one.dart';


class PageTwoModel extends ChangeNotifier{

  String _selectedCurrency;

  void setSelectedCurrency(String curr){
    newMenuObj.setCurrency(curr);
    notifyListeners();
  }

  String getSelectedCurrency(){
    return this._selectedCurrency;
  }

  void setMenuFile(File file){
    newMenuObj.setMenuFile(file);
    notifyListeners();
  }

  void setLogo(File file){
    newMenuObj.setLogo(file);
    notifyListeners();
  }

  void rebuild() => notifyListeners();

}