import 'package:flutter/foundation.dart';

import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class EditMenuModel extends ChangeNotifier {
  FoundState _state = FoundState.home;
  bool _noteReq = false;
  bool _uploadStatus = false;

  void changeState(FoundState state) {
    this._state = state;
    notifyListeners();
  }

  FoundState getState() {
    return this._state;
  }

  void setNoteReq(bool req) {
    this._noteReq = req;
    editMenuObj.setNoteRequired(req);
    notifyListeners();
  }

  bool getNoteReq() {
    return this._noteReq;
  }

  void setSuccessfulUpload(bool upload) {
    this._uploadStatus = upload;
    editMenuObj.setSuccessfulUpload(upload);
    notifyListeners();
  }

  bool getSuccessfulUpload() {
    return this._uploadStatus;
  }
}

enum FoundState {
  edit,
  create,
  home,
}
