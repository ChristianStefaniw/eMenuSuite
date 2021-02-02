import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:e_menu/other/util/encode.dart';
import 'package:e_menu/other/util/net/rest_calls.dart';

class OrderRequests {
  final obj;
  OrderRequests(this.obj);

  Stream<Map> get checkOrderStream async* {
    yield await checkOrder;
    yield* Stream.periodic(Duration(seconds: 30), (_) {
      return checkOrder;
    }).asyncMap(
      (event) async => await event,
    );
  }

  Future get checkOrder async {
    List _orders =
        await RESTCalls.get('order/?restaurant=${obj.getCameraScanResults()}');
    int _numOrders = 0;
    bool _contains = false;

    Map all = {};

    if (_orders.isNotEmpty) {
      for (int i = 0; i < _orders.length; i++) {
        if (Encode.decodePhone(_orders[i]['phonenum']) == obj.getPhoneNum()) {
          _contains = true;
          break;
        }
        _numOrders++;
      }
    }

    !_contains ? _numOrders = 0 : _numOrders = _numOrders;

    all['numOrders'] = _numOrders;
    all['putStatus'] = putStatus(await checkStatus);

    return all;
  }

  Future get checkStatus async {
    List _order = await RESTCalls.get(
        'order/?restaurant=${obj.getCameraScanResults()}&phonenum=${Encode.encodePhone(obj.getPhoneNum())}');
    if (_order.isNotEmpty) {
      if (_order[0]['chosen']) {
        return _Status.preparing;
      } else {
        return _Status.none;
      }
    } else {
      return _Status.prepared;
    }
  }

  Widget putStatus(_Status status) {
    if (status == _Status.preparing) {
      return Container(
        child: Text(
          'Your order is being prepared',
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceSansPro(
            textStyle: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      );
    } else if (status == _Status.prepared) {
      return Container(
        child: Text(
          'Your order is on the way',
          textAlign: TextAlign.center,
          style: GoogleFonts.sourceSansPro(
            textStyle: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      );
    } else if (status == _Status.none) {
      return SizedBox();
    }
    return Container();
  }
}

enum _Status {
  preparing,
  prepared,
  none,
}
