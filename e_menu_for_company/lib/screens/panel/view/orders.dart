import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:e_menu_for_company/models/orders_model.dart';
import 'package:e_menu_for_company/widgets/order_tile.dart';


class ViewOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    var _value = Provider.of<List>(context);
    OrdersModel _model = Provider.of<OrdersModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: GoogleFonts.sourceSansPro(
              textStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: _value != null
            ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: 612.h,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _model.getOrders().length,
                        itemBuilder: (context, index) {
                          Map _order = _value[index];

                          String _items = _order['items'].length.toString();
                          String _time = _order['time'].toString();
                          String _tableNum = _order['tablenum'].toString();
                          String _phone = _order['phonenum'].toString();

                          return OrderTile(
                              _items, _time, _tableNum, _phone, _model, index);
                        }),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
