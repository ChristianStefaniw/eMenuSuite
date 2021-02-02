import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:e_menu/widgets/listview_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:e_menu/models/order_model.dart';
import 'package:e_menu/models/tip_model.dart';
import 'package:e_menu/other/state_objects/menu.dart';
import 'package:e_menu/other/state_objects/order.dart';
import 'package:e_menu/other/state_objects/receipt.dart';
import 'package:e_menu/other/util/constants.dart';
import 'package:e_menu/other/util/net/rest_calls.dart';
import 'package:e_menu/other/util/scan_qr.dart';
import 'package:e_menu/widgets/order_item.dart';
import 'package:e_menu/widgets/side_nav_drawer.dart';
import 'package:e_menu/widgets/text_form_field.dart';
import 'package:e_menu/other/state_objects/pay.dart';
import 'package:e_menu/other/util/encode.dart';
import 'package:e_menu/other/util/order_requests.dart';
import 'package:e_menu/widgets/rounded_bordered_container.dart';
import 'package:e_menu/screens/other/receipt.dart';


part 'package:e_menu/screens/main_screens/final_order.dart';
part 'package:e_menu/screens/main_screens/checkout.dart';


OrderObj orderObj = new OrderObj();
MenuObj menuObj = new MenuObj();
ReceiptObj receiptObj = new ReceiptObj();

class MainPage extends StatelessWidget {
  final _formKeyPhoneNum = GlobalKey<FormState>();
  final _formKeyTableNum = GlobalKey<FormState>();

  //scan QRCode to bring user to receipt page
  Future _scanQRCodeR(BuildContext context) async {
    String _cameraScanResult;
    _cameraScanResult = await scanner.scan();
    receiptObj.setCameraScanResults(_cameraScanResult);
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => PhoneNumber()));
  }

  //scan QRCode to bring user to menu
  Future _scanQRCode(BuildContext context) async {
    String _cameraScanResult;

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    _cameraScanResult = await scanner.scan();
    pr.show();

    if (await ScanQR.scan(_cameraScanResult) == false) {
      List<Widget> _actions = [
        FlatButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Text("OK"),
        )
      ];
      return popUpCustom(context,
          title: "Error!",
          content: "Make sure you have the correct QRCode",
          actions: _actions);
    }

    Navigator.pop(context);

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => LoadDocument()),
    );
  }

  checkout(BuildContext context) {
    if (!_formKeyPhoneNum.currentState.validate() ||
        !_formKeyTableNum.currentState.validate()) {
      return;
    }
    if (orderObj.getOrder().isEmpty) {
      return popUpBasic(
        context,
        title: "Error!",
        content: "Please add to your order",
      );
    }

    orderObj.setTableNum(int.parse(orderObj.getTextControllerTableNumText()));
    orderObj.setPhoneNum(orderObj.getTextControllerPhoneNumText());

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => TipModel(), child: Checkout())));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    final _model = Provider.of<OrderModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'eMenu',
            style: GoogleFonts.sourceSansPro(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,

          //allow user to open menu that was recently opened without scanning QRCode again
          leading: Consumer<OrderModel>(
            builder: (context, model, child) {
              return menuObj.getMenuURL().isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.restaurant),
                      color: Colors.black,
                      onPressed: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => LoadDocument()),
                      ),
                    )
                  : SizedBox();
            },
          ),
          //allow user to scan a QRCode to start process of finding their receipt
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.receipt),
              color: Colors.black,
              onPressed: () => _scanQRCodeR(context),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 160.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 40.0)],
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 40)),
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/MenuIcon.png",
                      width: 230.w,
                      height: 150.h,
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                    ),
                    Container(
                      width: 130.w,
                      child: Text(
                        'Scan the QR Code on your table.',
                        style: GoogleFonts.sourceSansPro(
                            fontWeight: FontWeight.w300, fontSize: 20.sp),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),

              //Enter phone number form
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                child: TextFormFieldWidget(
                  globalKey: _formKeyPhoneNum,
                  labelText: "Enter your phone number",
                  validation: (value) {
                    if (value.isEmpty) {
                      return "Enter your phone number";
                    } else if (value.length != 10) {
                      return "Enter a valid phone number";
                    } else if (value.contains('.') || value.contains('-')) {
                      return "Only numbers";
                    }
                    return null;
                  },
                  textEditingController: orderObj.getTextControllerPhoneNum(),
                  textInputType: TextInputType.number,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 14.0)],
                  color: Colors.white,
                ),

                //list view with items added to order plus values from "top" list
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: orderObj.getOrder().length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 15.h, left: 5.w, right: 5.w),
                            child: TextFormFieldWidget(
                              globalKey: _formKeyTableNum,
                              labelText: "Enter your table number",
                              validation: (value) {
                                if (value.isEmpty) {
                                  return "Enter your table number";
                                } else if (value.contains('.') ||
                                    value.contains('-')) {
                                  return "Only numbers";
                                }
                                return null;
                              },
                              textEditingController:
                                  orderObj.getTextControllerTableNum(),
                              textInputType: TextInputType.number,
                            )),
                      );
                    }
                    if (index == 1) {
                      return Container(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Center(
                          child: ButtonTheme(
                            minWidth: 350.w,
                            child: RaisedButton.icon(
                              icon: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ),
                              color: Colors.grey,
                              label: Text(
                                'Checkout',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => checkout(context),
                            ),
                          ),
                        ),
                      );
                    }
                    return OrderItem(
                      index: index,
                      model: _model,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Container(
                width: 170,
                child: RaisedButton.icon(
                  color: Color(0xff739AC5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  label: Text("Scan"),
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _scanQRCode(context),
                ),
              ),
            ),
          ],
        ));
  }
}

class LoadDocument extends StatelessWidget {
  Future getDoc(BuildContext context) async {
    String url =
        await RESTCalls.get("restaurant/?search=${orderObj.getCameraScanResults()}")
            .then((value) => value[0]['menuurl']);
    Provider.of<OrderModel>(context, listen: false).setURL(url);
    PDFDocument _doc = await PDFDocument.fromURL(url);
    return _doc;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDoc(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ViewMenu(
            snapshot.data,
          );
        }
        return Container(
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class ViewMenu extends StatelessWidget {
  final PDFDocument document;

  ViewMenu(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideNavDrawer(
        total: menuObj.getItemsAndPrices(),
      ),

      appBar: AppBar(
        title: Text(
          'Menu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,

        //back button
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        actions: [
          // button to open side drawer that will allow the user to add to their order
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.border_color,
                  color: Colors.black,
                ),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            },
          ),
        ],
      ),

      // view the menu
      body: PDFViewer(
        document: document,
      ),
    );
  }
}
