import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';



loading(BuildContext context){
  return ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false);
}

popUpCustom(BuildContext context,
    {String title,
    List<Widget> actions,
    String content,
    bool barrierDismisable = true}) async{
    
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Text(title),
    content: Text(content),
    actions: actions,
  );

  return await showDialog(
    context: context,
    barrierDismissible: barrierDismisable,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

popUpBasic(BuildContext context,
    {String title,
      String content,
      bool barrierDismisable = true})
async{

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Text(title),
    content: Text(content),
    actions: [FlatButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    ),
  ]
  );

  return await showDialog(
    context: context,
    barrierDismissible: barrierDismisable,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
