import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  final f = new DateFormat('yyyy-MM-dd hh:mm');

  Future _resetTips() async {
    loading(context).show();
    FormData data = FormData.fromMap(
        {'tip': 0.0, 'lastTipReset': f.format(DateTime.now())});
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
        backgroundColor: Colors.white,
        title: Text(
          "Tips",
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
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
                                  Text("Amount:\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200)),
                                  Text("\$${snapshot.data[0]['tip']}"),
                                ],
                              ),
                            ),
                            width: 150.w,
                            height: 100.h),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Last Reset:\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200)),
                                  Text(
                                    "${f.format(DateTime.parse(snapshot.data[0]['lastTipReset']))}",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            width: 150.w,
                            height: 100.h),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton.icon(
                            color: Color(0xffEED5D2),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0))),
                            elevation: 5.0,
                            icon: Icon(Icons.refresh),
                            label: Text("Reset tips"),
                            onPressed: () async {
                              await _resetTips();
                            }),
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
