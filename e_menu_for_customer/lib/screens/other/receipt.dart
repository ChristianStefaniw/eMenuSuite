import 'package:e_menu/other/util/order_requests.dart';
import 'package:e_menu/widgets/listview_widget.dart';
import 'package:e_menu/widgets/rounded_bordered_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu/other/util/constants.dart';
import 'package:e_menu/other/util/create_receipt.dart';
import 'package:loading_button/loading_button.dart';
import 'package:e_menu/screens/main_screens/main_page.dart';


class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final TextEditingController _textControllerPhoneNumEntered =
      new TextEditingController();
  final _formKeyPhoneNum = GlobalKey<FormState>();
  bool _loading = false;


  Future _validate() async {
    if (!_formKeyPhoneNum.currentState.validate()) {
      return;
    }

    CreateReceipt _createReceipt = new CreateReceipt(phone: _textControllerPhoneNumEntered.text);

    setState(() {
      _loading = true;
    });

    if (await _createReceipt.createReceipt()) {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ReceiptView(),
          ));
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      return popUpBasic(
        context,
        title: "Error!",
        content: "Make sure you have the right phone number",
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Receipt',
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
              orderObj.setCameraScanResults('');
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 20.h),
            child: Form(
              key: _formKeyPhoneNum,
              child: TextFormField(
                decoration: new InputDecoration(
                  labelText: "Enter your phone number",
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(),
                  ),
                ),
                validator: (value) {
                  if (value.length < 10 || value.length > 11) {
                    return "Enter your phone number";
                  } else if (value.contains('.') || value.contains('-')) {
                    return "Enter your phone number";
                  }
                  return null;
                },
                controller: _textControllerPhoneNumEntered,
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: LoadingButton(
              isLoading: _loading,
              child: Text("Enter"),
              onPressed: _validate,
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ordered Items',
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
                receiptObj.reset();
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
        ),
        body: StreamBuilder<Map>(
            stream: OrderRequests(receiptObj).checkOrderStream,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15.h),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            height: 300.h,
                            child: ListViewWidget(false),
                          ),
                        ),
                        Container(
                          child: Text(
                            'There ${snapshot.data['numOrders'] == 1 ? 'is' : 'are'} ${snapshot.data['numOrders']} order${snapshot.data['numOrders'] == 1 ? '' : 's'} ahead of you',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSansPro(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 17.sp),
                            ),
                          ),
                        ),
                        snapshot.data['putStatus'],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 27.w),
                              child:
                                  Text("Tax: \$${receiptObj.getAmountTaxed()}"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 27.w),
                              child: Text("Tip: \$${receiptObj.getTip()}"),
                            ),
                          ],
                        ),
                        RoundedContainer(
                          elevation: 7,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 8.h),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 8.h),
                          child: ListTile(
                            leading: Text('Total: '),
                            trailing: Text(
                                '\$${double.parse((receiptObj.getReceiptTotal() + receiptObj.getAmountTaxed() + receiptObj.getTip()).toStringAsFixed(2))}'),
                          ),
                        ),
                        RoundedContainer(
                          elevation: 7,
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 8.w),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 8.w),
                          child: ListTile(
                            leading: Text('Status: '),
                            trailing: Text(
                              'PAID',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
