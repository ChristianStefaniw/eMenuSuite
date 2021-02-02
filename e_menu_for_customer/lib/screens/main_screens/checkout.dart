part of 'main_page.dart';


class Checkout extends StatelessWidget {

  PaymentPopUp(BuildContext context) {
    TextEditingController _cardNum = new TextEditingController();
    TextEditingController _exp_month = new TextEditingController();
    TextEditingController _exp_year = new TextEditingController();
    TextEditingController _cvc = new TextEditingController();
    TextEditingController _email = new TextEditingController();
    final _emailKey = GlobalKey<FormState>();
    final _cardNumKey = GlobalKey<FormState>();
    final _exp_month_key = GlobalKey<FormState>();
    final _exp_year_key = GlobalKey<FormState>();
    final _cvcKey = GlobalKey<FormState>();

    RaisedButton _payButton = RaisedButton(
        child: Text(
          "Pay",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black,
        onPressed: () async {
          if (_cardNumKey.currentState.validate() &&
              _exp_year_key.currentState.validate() &&
              _exp_month_key.currentState.validate() &&
              _cvcKey.currentState.validate() &&
              _emailKey.currentState.validate()) {
            List _orders = await RESTCalls
                .get("order/?restaurant=${orderObj.getCameraScanResults()}");
            for (int i = 0; i < _orders.length; i++) {
              if (_orders[i]['phonenum'] ==
                  Encode.encodePhone(orderObj.getPhoneNum()) ||
                  _orders[i]['tablenum'] == orderObj.getTableNum()) {
                return popUpBasic(context,
                    title: "Error!",
                    content:
                    "There is already an order with your phone number or table number.",
                    );
              }
            }

            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    PlaceOrder(
                      email: _email.text,
                      cardNum: _cardNum.text,
                      exp_month: _exp_month.text,
                      exp_year: _exp_year.text,
                      cvc: _cvc.text,
                    ),
              ),
            );
          }
        });

    TextFormFieldWidget _emailField = new TextFormFieldWidget(
        globalKey: _emailKey,
        labelText: "Email",
        validation: (value) {
          if (value.isEmpty) {
            return "Enter an email";
          }
          if (!value.contains("@")) {
            return "Enter a valid email";
          }
          return null;
        },
        textEditingController: _email,
        textInputType: TextInputType.emailAddress);

    TextFormFieldWidget _cardNumField = TextFormFieldWidget(
      globalKey: _cardNumKey,
      labelText: "Card Number",
      validation: (value) {
        if (value.isEmpty) {
          return "Enter your card number";
        } else if (value.contains('.') || value.contains('-')) {
          return "Only numbers";
        } else if (value.length != 16) {
          return "Enter a valid card number";
        }
        return null;
      },
      textEditingController: _cardNum,
      textInputType: TextInputType.number,
    );

    TextFormFieldWidget _expMonthField = TextFormFieldWidget(
      globalKey: _exp_month_key,
      labelText: "Expiration Month",
      validation: (value) {
        if (value.isEmpty) {
          return "Enter expiration month";
        } else if (value.contains('.') || value.contains('-')) {
          return "Only numbers";
        } else if (value.length != 2 ||
            int.parse(value) > 12 ||
            int.parse(value) < 1) {
          return "Enter a valid month";
        }
        return null;
      },
      textEditingController: _exp_month,
      textInputType: TextInputType.number,
    );

    TextFormFieldWidget _expYearField = TextFormFieldWidget(
      globalKey: _exp_year_key,
      labelText: "Expiration Year",
      validation: (value) {
        if (value.isEmpty) {
          return "Enter expiration year";
        } else if (value.contains('.') || value.contains('-')) {
          return "Only numbers";
        } else if (value.length != 4) {
          return "Enter a valid year";
        }
        return null;
      },
      textEditingController: _exp_year,
      textInputType: TextInputType.number,
    );

    TextFormFieldWidget _cvcField = new TextFormFieldWidget(
      globalKey: _cvcKey,
      labelText: "CVC",
      validation: (value) {
        if (value.length == 0) {
          return "Enter CVC";
        } else if (value.contains('.') || value.contains('-')) {
          return "Only numbers";
        } else if (value.length != 3) {
          return "Enter a valid CVC";
        }
        return null;
      },
      textEditingController: _cvc,
      textInputType: TextInputType.number,
    );

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
            title: Text("Add your card"),
            children: [
              SizedBox(height: 15.h,),
              _emailField,
              SizedBox(height: 15.h,),
              _cardNumField,
              SizedBox(height: 15.h,),
              _expMonthField,
              SizedBox(height: 15.h,),
              _expYearField,
              SizedBox(height: 15.h,),
              _cvcField,
              SizedBox(height: 15.h,),
              _payButton,
              Center(
                child: Text(
                  "Payment secured by Stripe",
                  style: GoogleFonts.sourceSansPro(
                    textStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {


    final _loadTip = Provider.of<TipModel>(context);

    double _totalCost = 0;
    var _table = '';

    orderObj.getOrder().forEach((element) {
      _totalCost += element['price'];
    });

    orderObj.setTotalCost(double.parse(_totalCost.toStringAsFixed(2)));

    orderObj.setAmountTaxed(double.parse(
        (orderObj.getTotalCost() * menuObj.getTax()).toStringAsFixed(2)));

    _table = 'Table #${orderObj.getTableNum()}';


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
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
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              height: 315.h,
              child: ListViewWidget(true),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 27.w),
                child: Text("Tax: \$${orderObj.getAmountTaxed()}"),
              ),
              Row(
                children: [
                  Text("Tip: "),
                  Padding(
                    padding: EdgeInsets.only(right: 27.w),
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          if (text.isEmpty) {
                            _loadTip.setTip(0);
                            return;
                          }
                          try {
                            _loadTip.setTip(double.parse(
                                double.parse(text).toStringAsFixed(2)));
                          } catch (Exception) {
                            //error is user enters ".", nothing will break so continue
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          RoundedContainer(
            elevation: 7,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: ListTile(
              leading: Text(_table),
              trailing: Text(
                  'Total: \$${double.parse(
                      (orderObj.getTotalCost() + orderObj.getAmountTaxed() +
                          _loadTip.getTip()).toStringAsFixed(2))}'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25.h),
            child: RoundedContainer(
              elevation: 7,
              margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: FlatButton(
                onPressed: () {
                  orderObj.setTip(_loadTip.getTip());
                  PaymentPopUp(context);
                },
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.creditCard,
                    color: Colors.indigo,
                  ),
                  title: Text("Pay with debit/credit"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
