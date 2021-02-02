import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_menu_for_company/models/page_two_model.dart';
import 'package:e_menu_for_company/widgets/payment.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;

import 'package:e_menu_for_company/other/state_objects/new_menu.dart';
import 'package:e_menu_for_company/other/state_objects/panel/edit_menu.dart';
import 'package:e_menu_for_company/other/state_objects/panel/panel.dart' as p;
import 'package:e_menu_for_company/models/items_model.dart';
import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/encode.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/widgets/text_form_field.dart';
import 'package:e_menu_for_company/screens/panel/panel.dart';
import 'package:screenshot/screenshot.dart';


part 'page_three.dart';
part 'page_two.dart';

NewMenu newMenuObj = new NewMenu();
EditMenu editMenuObj = new EditMenu();
p.Panel panelObj = new p.Panel();

class PageOne extends StatelessWidget {
  // ignore: non_constant_identifier_names
  Future _QRScan(BuildContext context) async {
    String result = await scanner.scan();
    loading(context).show();
    await RESTCalls.get('restaurant/?restaurant=$result}');
    Navigator.of(context).pop();
    panelObj.setCameraResult(result);
    return result;
  }

  Future _checkAndSetMenuName(BuildContext context) async {
    loading(context).show();

    FormState restNameState = newMenuObj.restaurantNameKey.currentState;

    List _allRestaurants = await RESTCalls.get('restaurant');

    for (int i = 0; i < _allRestaurants.length; i++) {
      if (_allRestaurants[i]['name'] ==
          newMenuObj.textControllerNameText) {
        Navigator.pop(context);
        return popUpBasic(
          context,
          title: "Error",
          content: "There is already a restaurant with this name.",
        );
      }
    }

    if (restNameState.validate()) {
      newMenuObj.setRestaurantName(newMenuObj.textControllerNameText);
    }

    Navigator.pop(context);
  }

  uploadMenuItem(BuildContext context, ItemsModel model) {
    for (int i = 0;
        i <
            context
                .read<ItemsModel>()
                .getMenuItemsAndPricesSetToPost()
                .length;
        i++) {
      if (context.read<ItemsModel>().getMenuItemsAndPricesSetToPost()[i]
              [0] ==
          newMenuObj.textControllerItemText) {
        return popUpBasic(
          context,
          title: "Error",
          content: "An item with this name already exists",
        );
      }
    }

    List tempLst = [
      newMenuObj.textControllerItemText,
      newMenuObj.textControllerPriceText,
      context.read<ItemsModel>().getCheckedValue() ? true : false,
    ];

    //this will be sent to the backend
    model.addMenuItemsAndPricesSetToPost(values: tempLst);

    String isNoteRequired = context.read<ItemsModel>().getCheckedValue()
        ? "\nNote is required"
        : "";

    List<Widget> addThis = [
      Text(newMenuObj.textControllerItemText +
          " - \$" +
          newMenuObj.textControllerPriceText +
          "$isNoteRequired")
    ];

    //this will be shown to the user
    model.insertAllItemsAndPricesWidgets(indexes: [0], widgets: addThis);

    model.setCheckedValue(false);

    newMenuObj.setTextControllerPriceText('');
    newMenuObj.setTextControllerItemText('');
  }

  Future toPanel(BuildContext context) async {
    TextEditingController _passController = new TextEditingController();
    final _passKey = GlobalKey<FormState>();
    String scanResult = await _QRScan(context);
    String getPass = await RESTCalls.get('restaurant/?name=$scanResult')
        .then((value) => Encode.decode(value[0]['password']));

    Padding _passField = new Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.h),
      child: TextFormFieldWidget(
        globalKey: _passKey,
        labelText: "Password",
        validation: (value) {
          if (value.isEmpty) {
            return "Enter password";
          }
          if (value != getPass) {
            return "Incorrect password";
          }
          return null;
        },
        textEditingController: _passController,
        textInputType: TextInputType.visiblePassword,
        obscure: true,
      ),
    );

    Padding _submit = new Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: RaisedButton.icon(
        icon: Icon(Icons.arrow_forward_ios),
        label: Text(""),
        elevation: 5,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(3)),
        color: Colors.green,
        onPressed: () {
          if (_passKey.currentState.validate()) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Panel()));
          }
          if (scanResult.isEmpty) {
            return popUpBasic(
              context,
              title: "Error!",
              content: "Make sure you have the correct QRCode",
            );
          }
        },
      ),
    );

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Enter Password"),
            children: [
              _passField,
              _submit,
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    final _model = Provider.of<ItemsModel>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Create eMenu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: () async {
                await toPanel(context);
              })
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Transform(
              alignment: FractionalOffset.topRight,
              transform: Matrix4.rotationZ(0.3),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(500),
                        left: Radius.circular(100))),
                width: MediaQuery.of(context).size.width,
                height: 600,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
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
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 5.h),
                              child: TextFormFieldWidget(
                                  globalKey: newMenuObj.restaurantNameKey,
                                  labelText: "Enter Restaurant's Name",
                                  validation: (value) {
                                    if (value.length == 0) {
                                      return "Enter a name";
                                    }
                                    return null;
                                  },
                                  textEditingController:
                                      newMenuObj.textControllerName,
                                  textInputType: TextInputType.text),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: RaisedButton.icon(
                                label: Text("Upload"),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                elevation: 5.0,
                                icon: Icon(Icons.upload_sharp),
                                onPressed: () async {
                                  await _checkAndSetMenuName(context);
                                }),
                          )
                        ],
                      ),
                    ),
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
                              EdgeInsets.only(left: 5.w, top: 5.h, bottom: 5.h),
                          child: Container(
                            width: 60.w,
                            child: TextFormFieldWidget(
                                globalKey: newMenuObj.itemPriceKey,
                                labelText: "Price",
                                validation: (value) {
                                  if (value.length == 0) {
                                    return "Enter a price";
                                  } else if ('.'.allMatches(value).length > 1 ||
                                      value.contains('-')) {
                                    return "Enter a valid number";
                                  }
                                  return null;
                                },
                                textEditingController:
                                    newMenuObj.textControllerPrice,
                                textInputType: TextInputType.number),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          child: TextFormFieldWidget(
                              globalKey: newMenuObj.itemNameKey,
                              labelText: "Item Name",
                              validation: (value) {
                                if (value.length == 0) {
                                  return "Enter an item";
                                }
                                return null;
                              },
                              textEditingController:
                                  newMenuObj.textControllerItem,
                              textInputType: TextInputType.text),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.h, bottom: 5.h, right: 5.w),
                  child: RaisedButton.icon(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      icon: Icon(Icons.upload_sharp),
                      label: Text("Upload Menu Item"),
                      onPressed: () {
                        FormState restNameState =
                            newMenuObj.restaurantNameKey.currentState;
                        FormState itemPriceState =
                            newMenuObj.itemPriceKey.currentState;
                        FormState itemNameState =
                            newMenuObj.itemNameKey.currentState;
                        if (newMenuObj.restaurantName.isEmpty) {
                          return popUpBasic(
                            context,
                            title: "Error!",
                            content: "Please upload your restaurant's name",
                          );
                        }
                        if (restNameState.validate() &&
                            itemPriceState.validate() &&
                            itemNameState.validate()) {
                          uploadMenuItem(context, _model);
                        }
                      }),
                ),
                Consumer<ItemsModel>(builder: (context, model, child) {
                  return Column(
                    children: [
                      CheckboxListTile(
                        title: Text("Require note, i.e. size"),
                        value: model.getCheckedValue(),
                        onChanged: (newValue) {
                          model.setCheckedValue(newValue);
                        },
                      ),
                    ],
                  );
                }),
                Consumer<ItemsModel>(
                  builder: (context, model, child) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      height: 240.h,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: model.getAllItemsAndPricesWidgets().length,
                          itemBuilder: (context, index) {
                            Color _colour;
                            if (index % 2 == 0) {
                              _colour = Colors.white.withOpacity(0.98);
                            } else {
                              _colour = Color(0xffF8F8F8).withOpacity(0.98);
                            }
                            return Container(
                              color: _colour,
                              padding: EdgeInsets.symmetric(vertical: 25.h),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      model
                                          .getAllItemsAndPricesWidgets()[index],
                                      OutlineButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        onPressed: () {
                                          model
                                              .removeAtMenuItemsAndPricesSetToPost(
                                                  index: index);
                                          model
                                              .removeAtAllItemsAndPricesWidgets(
                                                  index: index);
                                        },
                                        child: Text("Remove"),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),
                    );
                  },
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Container(
                            width: 150.w,
                            child: RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                elevation: 5.0,
                                icon: Icon(CupertinoIcons.right_chevron),
                                label: Text("Next"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider<
                                                      PageTwoModel>(
                                                  create: (context) =>
                                                      PageTwoModel(),
                                                  child: PageTwo())));
                                }),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
