import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TextFormFieldWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final String labelText;
  final Function validation;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool obscure;

  TextFormFieldWidget({@required this.globalKey, @required this.labelText, @required this.validation, @required this.textEditingController, @required this.textInputType, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(360, 692));
    return Form(
      key: this.globalKey,
      child: TextFormField(
        obscureText: this.obscure,
        decoration: new InputDecoration(
          labelText: this.labelText,
          fillColor: Colors.white,
          contentPadding:
          EdgeInsets.symmetric(vertical:10.h, horizontal: 10.h),
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
          ),
        ),
        validator: this.validation,
        controller: this.textEditingController,
        keyboardType: this.textInputType,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }
}