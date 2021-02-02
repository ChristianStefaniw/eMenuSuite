import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


import 'edit/edit_tax_multiplier.dart';
import 'view/tax.dart';
import 'view/finances.dart';
import 'edit/edit_menu.dart';
import 'view/tips.dart';
import 'package:e_menu_for_company/models/edit_menu_model.dart';
import 'package:e_menu_for_company/models/orders_model.dart';
import 'package:e_menu_for_company/screens/panel/View/Orders.dart';


class Panel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    OrdersModel _ordersModel = new OrdersModel();
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Dashboard",
            style: GoogleFonts.sourceSansPro(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: ScreenUtil().setWidth(200),
                child: RaisedButton.icon(
                  color: Color(0xffFAEBD7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                  elevation: 5.0,
                  icon: Icon(Icons.settings_overscan_rounded),
                  label: Text("View Orders"),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MultiProvider(
                              providers: [
                                StreamProvider.value(
                                  value: _ordersModel.getLiveData(),
                                ),
                                ChangeNotifierProvider.value(
                                    value: _ordersModel),
                              ],
                              child: ViewOrders(),
                            )),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                child: RaisedButton.icon(
                  color: Color(0xffFAEBD7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  elevation: 5.0,
                  icon: Icon(Icons.border_color),
                  label: Text("Edit Menu"),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => EditMenuModel(),
                        child: EditMenu(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                child: RaisedButton.icon(
                  color: Color(0xffFAEBD7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                  elevation: 5.0,
                  icon: Icon(Icons.attach_money_rounded),
                  label: Text("Tips"),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Tips(),
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                child: RaisedButton.icon(
                  color: Color(0xffFAEBD7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  elevation: 5.0,
                  icon: Icon(Icons.money_off_csred_rounded),
                  label: Text("Tax"),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Tax(),
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                child: RaisedButton.icon(
                  color: Color(0xffFAEBD7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                  elevation: 5.0,
                  icon: Icon(Icons.clear),
                  label: Text("Edit Tax Multiplier"),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditTaxMultiplier(),
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(200),
                child: RaisedButton.icon(
                  color: Color(0xffFAEBD7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                  elevation: 5.0,
                  icon: Icon(FontAwesomeIcons.moneyBill),
                  label: Text("Finances"),
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Finances(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
