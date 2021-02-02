import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:e_menu/screens/main_screens/main_page.dart';
import 'package:e_menu/other/util/api_keys.dart';

class PayObj {
  Map _card;
  Map<String, String> _payData;
  String _paymentIntentID;
  String _paymentMethodID;
  Map<String, String> _paymentMethodData;

  void setPaymentMethodData({@required String paymentMethodID}) =>
      this._paymentMethodData = {
        "payment_method": paymentMethodID,
      };

  Map getPaymentMethodData() => this._paymentMethodData;

  void setPaymentMethodID(String id) => this._paymentMethodID = id;

  String getPaymentMethodID() => this._paymentMethodID;

  void setPaymentIntentID(String id) => this._paymentIntentID = id;

  String getPaymentIntentID() => this._paymentIntentID;

  void createCard(
          {@required String number,
          @required int exp_month,
          @required int exp_year,
          @required int cvc}) =>
      this._card = {
        "type": "card",
        "card[number]": number,
        "card[exp_month]": exp_month,
        "card[exp_year]": exp_year,
        "card[cvc]": cvc
      };

  Map getCard() => this._card;

  void createPayData(
      {@required String amount,
      @required String currency,
      @required String fee,
      @required String email}) =>
    this._payData = {
      "payment_method_types[]": "card",
      "amount": amount,
      "currency": currency,
      "application_fee_amount": fee,
      "receipt_email": email,
    };

  Map<String, String> getPayData() => this._payData;

  Future payIntent({@required Map<String, String> data}) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('https://api.stripe.com/v1/payment_intents',
        options: Options(headers: {
          "Stripe-Account": menuObj.getRestaurantStripeAccount(),
          "Authorization": 'Bearer ${getStripeKey()}'
        }, contentType: Headers.formUrlEncodedContentType),
        data: data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return false;
    }
  }

  Future paymentIntentConfirm({@required Map data, @required String id}) async {
    Response response;
    Dio dio = new Dio();
    response =
        await dio.post('https://api.stripe.com/v1/payment_intents/$id/confirm',
            options: Options(headers: {
              "Authorization": 'Bearer ${getStripeKey()}',
              "Stripe-Account": menuObj.getRestaurantStripeAccount(),
            }, contentType: Headers.formUrlEncodedContentType),
            data: data);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      return false;
    }
  }

  Future paymentMethod({@required Map data}) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('https://api.stripe.com/v1/payment_methods',
        options: Options(headers: {
          "Authorization": 'Bearer ${getStripeKey()}',
          "Stripe-Account": menuObj.getRestaurantStripeAccount(),
        }, contentType: Headers.formUrlEncodedContentType),
        data: data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return false;
    }
  }
}
