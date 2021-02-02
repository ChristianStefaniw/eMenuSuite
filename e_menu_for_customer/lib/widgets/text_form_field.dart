import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final String labelText;
  final Function validation;
  final TextEditingController textEditingController;
  final TextInputType textInputType;

  TextFormFieldWidget(
      {@required this.globalKey,
      @required this.labelText,
      @required this.validation,
      @required this.textEditingController,
      @required this.textInputType});

  @override
  Widget build(BuildContext context) {


    return Form(
      key: this.globalKey,
      child: TextFormField(
        decoration: new InputDecoration(
          labelText: this.labelText,
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
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
