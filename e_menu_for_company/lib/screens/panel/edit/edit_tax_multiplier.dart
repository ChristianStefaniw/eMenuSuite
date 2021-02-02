import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';
import 'package:e_menu_for_company/widgets/text_form_field.dart';

class EditTaxMultiplier extends StatefulWidget {
  @override
  _EditTaxMultiplierState createState() => _EditTaxMultiplierState();
}

class _EditTaxMultiplierState extends State<EditTaxMultiplier> {
  GlobalKey _newTaxKey = new GlobalKey<FormState>();
  TextEditingController _newTaxController = new TextEditingController();

  Future _upload(String newMultiplier) async {
    loading(context).show();

    FormData _data = new FormData.fromMap({
      'tax': newMultiplier,
    });

    await RESTCalls.update("restaurant/${panelObj.getCameraResult()}/",
        data: _data);

    Navigator.pop(context);

    setState(() {
      _newTaxController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Edit Tax Multiplier',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: RESTCalls.get('restaurant/?name=${panelObj.getCameraResult()}'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
                    child: Text("Current: ${snapshot.data[0]['tax']}"),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(8),
                          horizontal: ScreenUtil().setWidth(8)),
                      child: TextFormFieldWidget(
                          globalKey: _newTaxKey,
                          labelText: "New Multiplier",
                          validation: (value) {
                            if (value.contains('-') ||
                                '.'.allMatches(value).length > 1) {
                              return "Enter a valid number";
                            } else if (value.isEmpty) {
                              return "Enter a multiplier";
                            }
                            return null;
                          },
                          textEditingController: _newTaxController,
                          textInputType: TextInputType.number)),
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    elevation: 5.0,
                    color: Color(0xffE8F1D4),
                    icon: Icon(Icons.cloud_upload),
                    label: Text("Upload"),
                    onPressed: () async {
                      await _upload(_newTaxController.text);
                    },
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
