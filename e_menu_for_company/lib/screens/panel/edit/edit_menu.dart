import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'create_item.dart';
import 'edit_item.dart';
import 'package:e_menu_for_company/models/edit_menu_model.dart';
import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';
import 'package:e_menu_for_company/widgets/text_form_field.dart';


class EditMenu extends StatelessWidget {
  Future _selectItem(BuildContext context, EditMenuModel model) async {
    FormState _selectItemFormState =
        editMenuObj.formKeySelectItem.currentState;
    if (!_selectItemFormState.validate()) {
      return;
    }

    String _itemChosen = editMenuObj.textControllerItemSelectedText;

    editMenuObj.setTextControllerItemEditText(_itemChosen);
    editMenuObj.setTextControllerPriceEditText('');
    editMenuObj.setSuccessfulUpload(false);

    loading(context).show();

    var items =
        await RESTCalls.get("item/?restaurant=${panelObj.getCameraResult()}");
    Navigator.of(context).pop();

    if (items.length == 0) {
      editMenuObj.setTextControllerItemEditText(_itemChosen);
      model.changeState(FoundState.create);
    }

    bool found = false;

    for (int i = 0; i < items.length; i++) {
      if (items[i]['item'] == editMenuObj.textControllerItemSelectedText) {
        editMenuObj.setItemBeingEdited(_itemChosen);
        editMenuObj.setNoteRequired(items[i]['req']);
        model.changeState(FoundState.edit);
        found = true;
      }
    }

    if (!found) {
      editMenuObj.setNoteRequired(false);
      model.changeState(FoundState.create);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    final EditMenuModel _model = Provider.of<EditMenuModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Edit eMenu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
          child: Container(
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
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(2),
                  left: ScreenUtil().setWidth(5),
                  top: ScreenUtil().setHeight(2)),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormFieldWidget(
                        globalKey: editMenuObj.formKeySelectItem,
                        labelText: "Enter an Item",
                        validation: (value) {
                          if (value.isEmpty) {
                            return "Enter an item";
                          }
                          return null;
                        },
                        textEditingController:
                            editMenuObj.textControllerItemSelected,
                        textInputType: TextInputType.text),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(5)),
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      elevation: 5.0,
                      icon: Icon(Icons.arrow_circle_down),
                      label: Text("Select"),
                      onPressed: () async {
                        await _selectItem(context, _model);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _model.getState() == FoundState.edit ? EditItem() : SizedBox(),
        _model.getState() == FoundState.create ? CreateItem() : SizedBox(),
      ]),
    );
  }
}
