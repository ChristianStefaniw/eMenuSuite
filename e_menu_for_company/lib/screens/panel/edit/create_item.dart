import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:e_menu_for_company/models/edit_menu_model.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';
import 'package:e_menu_for_company/widgets/text_form_field.dart';

class CreateItem extends StatelessWidget {


  Future _upload(EditMenuModel model) async {
    FormState _itemNameCreateForm =
        editMenuObj.formKeyItemCreateName.currentState;
    FormState _itemPriceCreateForm =
        editMenuObj.formKeyItemCreatePrice.currentState;

    bool _validateName = _itemNameCreateForm.validate();
    bool _validatePrice = _itemPriceCreateForm.validate();

    if (!_validatePrice || !_validateName) {
      return;
    }

    await _createItem(
        item: editMenuObj.textControllerItemEditText,
        price: editMenuObj.textControllerPriceEditText,
        required: editMenuObj.noteRequired.toString());
    editMenuObj.reset();
    model.setSuccessfulUpload(true);
  }

  Future _createItem(
      {@required String item,
      @required String price,
      @required String required}) async {
    FormData data = FormData.fromMap({
      'restaurant': panelObj.getCameraResult(),
      'item': item,
      'price': price,
      'req': required
    });
    await RESTCalls.post('item', data: data);
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
                  padding: EdgeInsets.only(top: 80.h, bottom: 20.w),
                  child: Text(
                    "Create Item",
                    style: TextStyle(fontSize: 20.sp),
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
                            padding: EdgeInsets.only(
                                bottom: 2.h, top: 2.h, left: 5.w),
                            child: TextFormFieldWidget(
                                globalKey:
                                    editMenuObj.formKeyItemCreatePrice,
                                labelText: "Price",
                                validation: (value) {
                                  if (value.contains('-') ||
                                      '.'.allMatches(value).length > 1) {
                                    return "Enter a valid number";
                                  } else if (value.isEmpty) {
                                    return "Enter a price";
                                  }
                                  return null;
                                },
                                textEditingController:
                                    editMenuObj.textControllerPriceEdit,
                                textInputType: TextInputType.number)),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 5.w, top: 2.h, bottom: 2.h),
                          child: TextFormFieldWidget(
                              globalKey: editMenuObj.formKeyItemCreateName,
                              labelText: "Item",
                              validation: (value) {
                                if (value.isEmpty) {
                                  return "Enter an item";
                                }
                                return null;
                              },
                              textEditingController:
                                  editMenuObj.textControllerItemEdit,
                              textInputType: TextInputType.text),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5.w, left: 8.w),
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          elevation: 5.0,
                          icon: Icon(Icons.cloud_upload),
                          label: Text("Upload"),
                          onPressed: () async {
                            await _upload(_model);
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
              ],
            ),
    );
  }
}
