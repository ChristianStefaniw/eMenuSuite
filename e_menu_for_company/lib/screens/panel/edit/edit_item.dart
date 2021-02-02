import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:e_menu_for_company/models/edit_menu_model.dart';
import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';
import 'package:e_menu_for_company/widgets/text_form_field.dart';

class EditItem extends StatelessWidget {
  Future _delete(String item, EditMenuModel model) async {
    await await RESTCalls.delete(
        "item/$item/?restaurant=${panelObj.getCameraResult()}");
    editMenuObj.reset();
    model.setSuccessfulUpload(true);
  }

  Future _upload(BuildContext context, EditMenuModel model) async {
    FormState _editItemPriceForm =
        editMenuObj.formKeyItemEditPrice.currentState;

    bool _editItemPrice = _editItemPriceForm.validate();

    if (!_editItemPrice) {
      return;
    }

    loading(context).show();

    await _editItem(
        item: editMenuObj.textControllerItemEditText,
        price: editMenuObj.textControllerPriceEditText,
        selectedItem: editMenuObj.textControllerItemSelectedText,
        required: editMenuObj.noteRequired.toString());
    editMenuObj.reset();

    Navigator.pop(context);

    model.setSuccessfulUpload(true);
  }

  Future _editItem(
      {@required String item,
      @required String price,
      @required String selectedItem,
      @required String required}) async {
    if (item.isEmpty) {
      FormData data = FormData.fromMap({'price': price, 'req': required});
      RESTCalls.update(
          'item/$selectedItem/?restaurant=${panelObj.getCameraResult()}',
          data: data);
    } else if (price.isEmpty) {
      FormData data = FormData.fromMap({'item': item, 'req': required});
      return await RESTCalls.update(
          'item/$selectedItem/?restaurant=${panelObj.getCameraResult()}',
          data: data);
    } else {
      FormData data =
          FormData.fromMap({'item': item, 'price': price, 'req': required});
      return await RESTCalls.update(
          'item/$selectedItem/?restaurant=${panelObj.getCameraResult()}',
          data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    final EditMenuModel _model = Provider.of<EditMenuModel>(context);

    return Expanded(
      child: editMenuObj.successfulUpload
          ? Text(
              "Success",
              style: TextStyle(color: Colors.greenAccent),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 80.h, bottom: 20.h),
                  child: Text(
                    "Item Being Edited: ${editMenuObj.itemBeingEdited}",
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 5.w, bottom: 2.h, top: 2.h),
                          child: TextFormFieldWidget(
                              globalKey: editMenuObj.formKeyItemEditPrice,
                              labelText: "Price",
                              validation: (value) {
                                if (value.contains('-') ||
                                    '.'.allMatches(value).length > 1) {
                                  return "Enter a valid number";
                                }
                                return null;
                              },
                              textEditingController:
                                  editMenuObj.textControllerPriceEdit,
                              textInputType: TextInputType.number),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 2.h, top: 2.h, left: 8.w),
                          child: TextFormFieldWidget(
                              globalKey: editMenuObj.formKeyItemEditName,
                              labelText: "Item",
                              validation: null,
                              textEditingController:
                                  editMenuObj.textControllerItemEdit,
                              textInputType: TextInputType.text),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.h),
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          elevation: 5.0,
                          icon: Icon(Icons.cloud_upload),
                          label: Text("Upload"),
                          onPressed: () async {
                            await _upload(context, _model);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                CheckboxListTile(
                  title: Text("Require note, i.e. size"),
                  value: editMenuObj.noteRequired,
                  onChanged: (newValue) {
                    _model.setNoteReq(newValue);
                  },
                ),
                RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    elevation: 5.0,
                    icon: Icon(CupertinoIcons.trash),
                    color: Colors.redAccent,
                    label: Text("Delete"),
                    onPressed: () async {
                      await _delete(editMenuObj.itemBeingEdited, _model);
                    }),
              ],
            ),
    );
  }
}
