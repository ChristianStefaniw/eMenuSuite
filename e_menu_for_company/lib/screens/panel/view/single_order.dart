import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu_for_company/models/single_order_model.dart';
import 'package:e_menu_for_company/other/util/constants.dart';
import 'package:e_menu_for_company/other/util/encode.dart';


class SingleOrder extends StatelessWidget {
  final phone;
  final orderModel;
  final index;
  SingleOrder(this.phone, this.orderModel, this.index);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    SingleOrderModel _model = Provider.of<SingleOrderModel>(context);
    Provider.of<List>(context);

    if (_model.getOrder() == null) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    }

    Map _order = _model.getOrder()[0];

    List items = _order['items'].toString().split('*');
    List notes = _order['notes'].toString().split('*');

    Map itemsAndNotes = {};

    for (int i = 0; i < items.length; i++) {
      if (notes[i].isEmpty) {
        notes[i] = 'None';
      }
      itemsAndNotes[i] = [items[i], notes[i]];
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Order",
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
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 25.h),
          child: Column(
            children: [
              for (var value in itemsAndNotes.values)
                Text("Item: ${value[0]} \nNote: ${value[1]} \n",
                    style: TextStyle(fontSize: 20.sp),
                    textAlign: TextAlign.center),
              Text(
                "Table #: ${_order['tablenum']}\n",
              ),
              Text(
                "Phone #: ${Encode.decodePhone(_order['phonenum'])}",
              ),
              CheckboxListTile(
                  value: _model.getCheckedVal(),
                  onChanged: (bool newValue) async {
                    loading(context).show();
                    await _model.checkUncheck(newValue, _order['phonenum']);
                    Navigator.of(context).pop();
                  }),
              OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () async {
                  List<Widget> actions = [
                    FlatButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Text("No"),
                    ),
                    FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        loading(context).show();
                        await _model.removeOrder(_order['phonenum'], context);
                        orderModel.removeOrder(index);
                        Navigator.of(context).pop();
                      },
                      child: Text("Yes"),
                    ),
                  ];

                  return popUpCustom(context,
                      title: "Are You Sure?",
                      content:
                          "Are you sure you would like to remove this order?",
                      actions: actions);
                },
                child: Text('Remove Order'),
              )
            ],
          ),
        ));
  }
}
