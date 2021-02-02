import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu/models/order_model.dart';
import 'package:e_menu/screens/main_screens/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderItem extends StatelessWidget {
  final int index;
  final OrderModel model;

  OrderItem({this.index, this.model});

  List<Widget> getItems() {
    List<Widget> _widgets = [];
    if (orderObj.getOrder()[index - 2]['note'].isEmpty) {
      _widgets = [
        Text(
          orderObj.getOrder()[index - 2]['item'],
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 16.h, color: Colors.black54),
        )
      ];
    } else {
      _widgets = [
        Text(
          orderObj.getOrder()[index - 2]['item'] + '\n',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 16.h, color: Colors.black54),
        ),
        Text(
          orderObj.getOrder()[index - 2]['note'],
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 16.h, color: Colors.black54),
        ),
      ];
    }
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _items = getItems();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5.w,
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
                    child: Text(
                      '\$' + orderObj.getOrder()[index - 2]['price'].toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _items,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.grey[300],
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      child: IconButton(
                          color: Colors.redAccent,
                          icon: Icon(Icons.remove_circle),
                          onPressed: () {
                            model.removeFromOrder(index - 2);
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
