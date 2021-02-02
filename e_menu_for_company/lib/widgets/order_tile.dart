import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu_for_company/models/single_order_model.dart';
import 'package:e_menu_for_company/screens/panel/view/single_order.dart';

class OrderTile extends StatelessWidget {
  final items;
  final time;
  final tableNum;
  final phone;
  final orderModel;
  final index;

  OrderTile(this.items, this.time, this.tableNum, this.phone, this.orderModel,
      this.index);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    SingleOrderModel _model = new SingleOrderModel();

    final f = new DateFormat('yyyy-MM-dd hh:mm');

    var timeFormat = f.format(DateTime.parse(time));

    return Container(
      height: 87.h,
      margin: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.grey[300],
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Column(children: [
                      Text(
                        "Table:",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w200),
                      ),
                      Text(
                        tableNum,
                        style: TextStyle(color: Colors.black),
                      ),
                    ]),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        timeFormat,
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        "# of items: $items",
                        style: GoogleFonts.montserrat(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    height: 43.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_right),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                    providers: [
                                      StreamProvider.value(
                                        value: _model.getLiveData(phone),
                                      ),
                                      ChangeNotifierProvider.value(
                                          value: _model),
                                    ],
                                    child:
                                        SingleOrder(phone, orderModel, index),
                                  ))),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
