part of 'page_one.dart';


class PageThree extends StatelessWidget {
  Future _uploadFile() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('${Path.basename(newMenuObj.menuFile.path)}');
    UploadTask uploadTask = storageReference.putFile(newMenuObj.menuFile);
    var wait = await uploadTask.whenComplete(() => null);
    return await wait.ref.getDownloadURL();
  }

  Future _upload(BuildContext context) async {
    bool _noFile = false;
    bool _noName = false;
    bool _noItems = false;
    bool _noStripe = false;
    FormState _passForm = newMenuObj.passKey.currentState;
    FormState _taxForm = newMenuObj.taxKey.currentState;
    bool _validatePass = _passForm.validate();
    bool _validateTax = _taxForm.validate();

    if (newMenuObj.menuFile == null) {
      _noFile = true;
    }
    if (newMenuObj.restaurantName.isEmpty) {
      _noName = true;
    }
    if ((context.read<ItemsModel>().getAllItemsAndPricesWidgets().isEmpty) ||
        (context
            .read<ItemsModel>()
            .getMenuItemsAndPricesSetToPost()
            .isEmpty)) {
      _noItems = true;
    }

    if (newMenuObj.stripeID == null) {
      _noStripe = true;
    }

    bool _stripeActive = await RESTCallStripe.get("v1/account",
            headers: {"Stripe-Account": newMenuObj.stripeID})
        .then((value) => value['charges_enabled']);

    if (!_stripeActive) {
      return popUpBasic(context,
          title: "Error!",
          content:
              "Your Stripe account is not properly linked. Try linking again.");
    }

    if (_validatePass &&
        _validateTax &&
        !_noName &&
        !_noFile &&
        !_noItems &&
        !_noStripe) {
      FormData data;

      loading(context).show();

      await FirebaseAuth.instance.signInAnonymously();

      String url = await _uploadFile();

      data = FormData.fromMap({
        'name': newMenuObj.restaurantName,
        'tip': 0.0,
        'tax': double.parse(newMenuObj.textControllerTaxText),
        'stripeid': newMenuObj.stripeID,
        'password': Encode.encode(newMenuObj.textControllerPasswordText),
        'currency': newMenuObj.currency.toLowerCase(),
        'lastTipReset': DateTime.now(),
        'lastTaxedReset': DateTime.now(),
        'taxed': 0.0,
        'menuurl': url,
      });
      await RESTCalls.post('restaurant', data: data);

      for (int i = 0;
          i <
              context
                  .read<ItemsModel>()
                  .getMenuItemsAndPricesSetToPost()
                  .length;
          i++) {
        data = FormData.fromMap({
          'restaurant': newMenuObj.restaurantName,
          'price': context
              .read<ItemsModel>()
              .getMenuItemsAndPricesSetToPost()[i][1]
              .toString(),
          'item': context
              .read<ItemsModel>()
              .getMenuItemsAndPricesSetToPost()[i][0],
          'req': context
              .read<ItemsModel>()
              .getMenuItemsAndPricesSetToPost()[i][2]
              .toString()
        });
        await RESTCalls.post('item', data: data);
      }
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ViewQR(newMenuObj.logo, newMenuObj.restaurantName),
        ),
      );
    } else {
      return popUpBasic(
        context,
        title: "Error!",
        content: "Make sure you filled in all fields",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create eMenu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Transform(
            alignment: FractionalOffset.topRight,
            transform: Matrix4.rotationZ(0.7),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(400), left: Radius.circular(100))),
              width: MediaQuery.of(context).size.width,
              height: 700,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    child: TextFormFieldWidget(
                        globalKey: newMenuObj.taxKey,
                        labelText: "Enter tax multiplier (0.13, 0.15, etc)",
                        validation: (value) {
                          if (value.length == 0) {
                            return "Enter a tax multiplier";
                          }
                          if (!value.startsWith('0')) {
                            return "Enter a decimal value";
                          }
                          return null;
                        },
                        textEditingController:
                            newMenuObj.textControllerTax,
                        textInputType: TextInputType.number),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.w),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                      child: TextFormFieldWidget(
                          globalKey: newMenuObj.passKey,
                          labelText: "Enter password to access control panel",
                          validation: (value) {
                            if (value.length == 0) {
                              return "Enter a password";
                            }
                            return null;
                          },
                          obscure: true,
                          textEditingController:
                              newMenuObj.textControllerPassword,
                          textInputType: TextInputType.text)),
                ),
              ),
              PaymentButton(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Container(
                        width: 150.0,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          elevation: 5.0,
                          color: Color(0xffE8F1D4),
                          icon: Icon(Icons.cloud_upload_outlined),
                          label: Text("Upload Menu"),
                          onPressed: () async {
                            await _upload(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ViewQR extends StatelessWidget {
  final File logo;
  final String data;
  final ScreenshotController screenshotController = ScreenshotController();

  ViewQR(this.logo, this.data);

  Widget build(BuildContext context) {
    FileImage _file;
    if (this.logo == null) {
      _file = null;
    } else {
      _file = FileImage(this.logo);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code',
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
              newMenuObj.reset();
              Provider.of<ItemsModel>(context, listen: false).reset();
              Navigator.popUntil(context, (route) => route.isFirst);
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded, color: Colors.black),
            onPressed: () async {
              screenshotController.capture().then((File image) async {
                final params = SaveFileDialogParams(sourceFilePath: image.path);
                await FlutterFileDialog.saveFile(params: params);
              });
            },
          )
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: Container(
            color: Colors.white,
            child: QrImage(
              data: data,
              version: QrVersions.auto,
              embeddedImage: _file,
              embeddedImageStyle: QrEmbeddedImageStyle(size: Size(60, 60)),
            ),
          ),
        ),
      ),
    );
  }
}
