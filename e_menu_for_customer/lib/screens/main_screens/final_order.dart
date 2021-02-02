part of 'main_page.dart';


class PlaceOrder extends StatelessWidget {
  final cardNum;
  final exp_month;
  final exp_year;
  final cvc;
  final email;

  PlaceOrder(
      {@required this.email,
      @required this.cardNum,
      @required this.exp_month,
      @required this.exp_year,
      @required this.cvc});

  String _formatTimeOfDay() {
    final now = new DateTime.now();
    final dt = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final format = DateFormat('yyyy-MM-dd hh:mm:ss');
    return format.format(dt);
  }

  Future _placeOrder(BuildContext context) async {
    String _itemsToString = '';
    String _notesToString = '';

    Map _restaurantInfo = await RESTCalls
        .get("restaurant/?name=${orderObj.getCameraScanResults()}").then((value) => value[0]);
    FormData _tipAndTaxed = FormData.fromMap({
      'tip': (_restaurantInfo['tip'] + orderObj.getTip()).toStringAsFixed(2),
      'taxed': (_restaurantInfo['taxed'] + orderObj.getAmountTaxed())
          .toStringAsFixed(2),
    });
    await RESTCalls.update(
        'restaurant/${orderObj.getCameraScanResults()}/?name=${orderObj.getCameraScanResults()}',
        data: _tipAndTaxed);
    PayObj _pay = new PayObj();

    String _amount = ((orderObj.getTotalCost() * 100) +
            (orderObj.getAmountTaxed() * 100) +
            (orderObj.getTip()) * 100)
        .toInt()
        .toString();

    String _fee = ((orderObj.getTotalCost() * 100) * 0.01).toInt().toString();

    _pay.createPayData(
        amount: _amount,
        currency: _restaurantInfo['currency'],
        fee: _fee,
        email: email);

    _pay.createCard(
        number: cardNum,
        exp_month: int.parse(exp_month),
        exp_year: int.parse(exp_year),
        cvc: int.parse(cvc));
    Map _paymentIntent = await _pay.payIntent(data: _pay.getPayData());
    _pay.setPaymentIntentID(_paymentIntent['id']);

    Map paymentMethod = await _pay.paymentMethod(data: _pay.getCard());
    _pay.setPaymentMethodID(paymentMethod['id']);

    _pay.setPaymentMethodData(paymentMethodID: _pay.getPaymentMethodID());

    await _pay.paymentIntentConfirm(
        data: _pay.getPaymentMethodData(), id: _pay.getPaymentIntentID());


    orderObj.setTOD(_formatTimeOfDay());

    orderObj.getOrder().forEach((element) {
      _itemsToString += element['item'] + '*';
      _notesToString += element['note'] + '*';
    });



    FormData data = FormData.fromMap({
      "restaurant": orderObj.getCameraScanResults(),
      "time": orderObj.getTOD(),
      "chosen": "false",
      "cost": orderObj.getTotalCost().toString(),
      "items": _itemsToString,
      "notes": _notesToString,
      "phonenum": Encode.encodePhone(orderObj.getPhoneNum()),
      "tablenum": orderObj.getTableNum().toString(),
      "tax": orderObj.getAmountTaxed().toString(),
      "tip": orderObj.getTip().toString(),
    });

    await RESTCalls.post('order', data: data);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _placeOrder(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return PaymentError();
          }
          if (snapshot.hasData) {
            return FinalOrder();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PaymentError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Error!',
          style: GoogleFonts.sourceSansPro(
            color: Colors.red,
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
      ),
      body: Center(
        child: Text("Make sure you have the correct card details!"),
      ),
    );
  }
}


class FinalOrder extends StatelessWidget {

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
              orderObj.reset();
              Provider.of<OrderModel>(context, listen: false).rebuild();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
        body: StreamBuilder<Map>(
          stream: OrderRequests(orderObj).checkOrderStream,
          builder: (context, snapshot) {
            return snapshot.hasData ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    height: 315.h,
                    child: ListViewWidget(true),
                  ),
                ),
                Container(
                  child: Text(
                    'There ${snapshot.data['numOrders'] == 1 ? 'is' : 'are'} ${snapshot.data['numOrders']} order${snapshot.data['numOrders'] == 1 ? '' : 's'} ahead of you',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sourceSansPro(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),

                snapshot.data['putStatus'],

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 27.w),
                      child: Text("Tax: \$${orderObj.getAmountTaxed()}"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 27.w),
                      child: Text("Tip: \$${orderObj.getTip()}"),
                    ),
                  ],
                ),
                RoundedContainer(
                  elevation: 7,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: ListTile(
                    leading: Text('Total: '),
                    trailing: Text(
                        '\$${double.parse((orderObj.getTotalCost() + orderObj.getAmountTaxed() + orderObj.getTip()).toStringAsFixed(3))}'),
                  ),
                ),
                RoundedContainer(
                  elevation: 7,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: ListTile(
                    leading: Text('Status:'),
                    trailing: Text(
                      'PAID',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ) : Center(child: CircularProgressIndicator(),);
          }
        ));
  }
}
