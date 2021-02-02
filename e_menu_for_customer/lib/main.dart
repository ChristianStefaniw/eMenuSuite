import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:e_menu/models/order_model.dart';
import 'package:e_menu/screens/main_screens/main_page.dart';

void main() async {
  runApp(ChangeNotifierProvider<OrderModel>(create: (context) => OrderModel(), child: MyApp()));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      home: MainPage(),
    );
  }
}