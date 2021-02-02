import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_key.dart';

class RESTCalls {
  static Future get(String extension) async {
    Dio dio = new Dio();
    Response response;
      response = await dio.get('https://emenu-service.herokuapp.com/api/$extension',
          options: Options(headers: {"Authorization": "Api-Key ${getkey()}"}));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return false;
      }
  }

  static Future post(String extension,
      {Map<String, String> headers, FormData data}) async {
    Response response;
    Dio dio = new Dio();

    response = await dio.post('https://emenu-service.herokuapp.com/api/$extension/',
        options: Options(headers: {"Authorization": "Api-Key ${getkey()}"}),
        data: data);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future delete(String extension) async {
    Dio dio = new Dio();
    Response response;

    response = await dio.delete('https://emenu-service.herokuapp.com/api/$extension',
        options: Options(headers: {"Authorization": "Api-Key ${getkey()}"}));
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  static Future update(String extension, {FormData data}) async {
    Dio dio = new Dio();
    Response response;

    response = await dio.patch('https://emenu-service.herokuapp.com/api/$extension',
        options: Options(headers: {"Authorization": "Api-Key ${getkey()}"}),
        data: data);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class RESTCallStripe {
  static Future post(String extension,
      {Map<String, String> headers, @required Map data}) async {
    Response response;
    Dio dio = new Dio();
    response = await dio.post('https://api.stripe.com/' + extension,
        options: Options(
            headers: {"Authorization": "Bearer ${getStripeKey()}"},
            contentType: Headers.formUrlEncodedContentType),
        data: data);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return false;
    }
  }

  static Future get(String extension, {Map<String, String> headers}) async {
    headers.addAll({"Authorization": "Bearer ${getStripeKey()}"});
    Dio dio = new Dio();
    Response response;
    response = await dio.get('https://api.stripe.com/' + extension,
        options: Options(headers: headers));
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return false;
    }
  }
}
