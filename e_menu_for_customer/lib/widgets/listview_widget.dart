import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu/screens/main_screens/main_page.dart';

class ListViewWidget extends StatelessWidget {
  final bool receiptOrOrder;

  ListViewWidget(this.receiptOrOrder);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: (receiptOrOrder
            ? orderObj.getOrder().length
            : receiptObj.getReceipt().length),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  color: index % 2 == 0 ? Colors.white : Color(0xffF8F8F8),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                            "Item: ${(receiptOrOrder ? orderObj.getOrder()[index]['item'] : receiptObj.getReceipt()[index]['item'])}"),
                        Text(
                            "Price: \$${(receiptOrOrder ? orderObj.getOrder()[index]['price'] : receiptObj.getReceipt()[index]['price'])}"),
                      ],
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                color: index % 2 == 0 ? Colors.white : Color(0xffF8F8F8),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Text(
                      'Note: ${receiptOrOrder ? orderObj.getOrder()[index]['note'] : receiptObj.getReceipt()[index]['note']}'),
                ),
              ),
            ],
          );
        });
  }
}
