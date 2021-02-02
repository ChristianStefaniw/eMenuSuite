import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class Tax extends StatefulWidget {
  @override
  _TaxState createState() => _TaxState();
}

class _TaxState extends State<Tax> {
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  Future _resetTaxDue() async {
    loading(context).show();
    FormData data = FormData.fromMap(
        {'taxed': 0.0, 'lastTaxedReset': f.format(DateTime.now())});
    await RESTCalls.update('restaurant/${panelObj.getCameraResult()}/',
        data: data);
    Navigator.of(context).pop();
    setState(() {});
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
          'Tax',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FutureBuilder(
              future: RESTCalls.get(
                  'restaurant/?restaurant=${panelObj.getCameraResult()}'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      children: [
                        Container(
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Tax Owed:\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200)),
                                  Text("\$${snapshot.data[0]['taxed']}"),
                                ],
                              ),
                            ),
                            width: 150,
                            height: 100),
                        Container(
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Last Reset:\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200)),
                                  Text(
                                    "${f.format(DateTime.parse(snapshot.data[0]['lastTaxedReset']))}",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            width: 150.w,
                            height: 100.h),
                        SizedBox(
                          height: 20.h,
                        ),
                        RaisedButton.icon(
                            color: Color(0xffEED5D2),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0))),
                            elevation: 5.0,
                            icon: Icon(Icons.refresh),
                            label: Text("Reset tax owed"),
                            onPressed: () async {
                              await _resetTaxDue();
                            }),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    );
  }
}
