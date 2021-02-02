import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:e_menu/screens/main_screens/main_page.dart';
import 'package:e_menu/Other/Util/Constants.dart';
import 'package:e_menu/models/order_model.dart';
import 'package:e_menu/widgets/text_form_field.dart';

class SideNavDrawer extends StatefulWidget {
  final List total;

  SideNavDrawer({this.total});

  @override
  SideNavDrawerState createState() => SideNavDrawerState();
}

class SideNavDrawerState extends State<SideNavDrawer> {
  final TextEditingController _textControllerNote = new TextEditingController();
  final GlobalKey _noteKey = new GlobalKey<FormState>();
  Map _selected;

  void initState(){

    super.initState();
  }

  void dispose(){
    super.dispose();
  }


  _addToOrder(OrderModel model) {
    String note;


    if (_selected == null) {
      return;
    }

    FormState _noteFormState = _noteKey.currentState;
    if (!_noteFormState.validate()) {
      return;
    }

    if (_textControllerNote.text.isEmpty) {
      note = '';
    } else {
      note = _textControllerNote.text;
    }

    model.addToOrder(item: _selected['item'], note: note, price: _selected['price']);


    _textControllerNote.text = '';

    return popUpBasic(
      context,
      title: "Added",
      content: "${_selected['item']} was added to your order",
    );
  }



  @override
  Widget build(BuildContext context) {

    final _model = Provider.of<OrderModel>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Add to Order',
              style: TextStyle(color: Colors.black, fontSize: 25.h),
            ),
          ),
          SearchableDropdown.single(
            isExpanded: true,
            items: widget.total.map(
              (e) {
                return DropdownMenuItem(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          "Item: ${e['item']}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "    Price: \$${e['price']}",
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  value: e,
                );
              },
            ).toList(),
            value: _selected,
            hint: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Text("Select any"),
            ),
            searchHint: "Select any",
            onChanged: (value) {
              setState(() {
                _selected = value;
              });
            },
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 30.h, bottom: 40.h, left: 5.w, right: 5.w),
            child: TextFormFieldWidget(
                globalKey: _noteKey,
                labelText: "Enter your note (size, toppings, etc)",
                validation: (value) {
                  if (value.contains('*')) {
                    return "This character is not allowed!";
                  }
                  int _selectedIndex = menuObj
                      .getFullQuery()
                      .indexWhere((f) => f['item'] == _selected['item']);
                  if (menuObj.getFullQuery()[_selectedIndex]['req'] &&
                      value.isEmpty) {
                    return "A note is required";
                  }
                  return null;
                },
                textEditingController: _textControllerNote,
                textInputType: TextInputType.text),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
            child: RaisedButton.icon(
                icon: Icon(Icons.add),
                elevation: 5.0,
                color: Color(0xffB0E0E6),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                label: Text('Add to Order'),
                onPressed: () => _addToOrder(_model)),
          ),
        ],
      ),
    );
  }
}
