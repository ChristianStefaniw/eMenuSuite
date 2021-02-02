import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class Finances extends StatelessWidget {
  Future _getBalanceDetails() async {
    List _restInfo =
        await RESTCalls.get('restaurant/?name=${panelObj.getCameraResult()}');

    Map _balances = await RESTCallStripe.get('v1/balance',
        headers: {"Stripe-Account": _restInfo[0]['stripeid']});

    double _available = _balances['available'][0]['amount'] / 100;
    double _pending = _balances['pending'][0]['amount'] / 100;

    return {
      'available': _available,
      'pending': _pending,
      'tip': _restInfo[0]['tip'],
      'tax': _restInfo[0]['taxed']
    };
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
          ' Finances',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _getBalanceDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Container(
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Available:\n",
                                style: TextStyle(fontWeight: FontWeight.w200)),
                            Text("\$${snapshot.data['available']}"),
                          ],
                        ),
                      ),
                      width: 150,
                      height: 100),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Pending:\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200)),
                                Text("\$${snapshot.data['pending']}"),
                              ],
                            ),
                          ),
                          width: 150.w,
                          height: 100.h),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Pending funds will be available for payout every 7 days",
                    style: GoogleFonts.sourceSansPro(
                        textStyle: TextStyle(fontWeight: FontWeight.w300)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.h),
                            Container(
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Tips Collected:\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200)),
                                      Text("\$${snapshot.data['tip']}"),
                                    ],
                                  ),
                                ),
                                width: 150.w,
                                height: 100.h),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.h),
                            Container(
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Tax owed:\n",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200)),
                                      Text("\$${snapshot.data['tax']}"),
                                    ],
                                  ),
                                ),
                                width: 150,
                                height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  RaisedButton.icon(
                    color: Color(0xffFFDAB9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    elevation: 5.0,
                    icon: Icon(Icons.schedule),
                    label: Text("Set Payout Schedule"),
                    onPressed: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PayoutScheduleWebView())),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RaisedButton.icon(
                    color: Color(0xffFFDAB9),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0))),
                    elevation: 5.0,
                    icon: Icon(Icons.monetization_on_outlined),
                    label: Text("View Finances on Stripe"),
                    onPressed: () => Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Stripe())),
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

class PayoutScheduleWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Payout Schedule",
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context)),
      ),
      body: WebView(
        initialUrl: 'https://dashboard.stripe.com/settings/payouts',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class Stripe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Stripe",
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context)),
      ),
      body: WebView(
        initialUrl: 'https://dashboard.stripe.com/',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
