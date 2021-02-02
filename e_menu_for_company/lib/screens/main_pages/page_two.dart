part of 'page_one.dart';

class PageTwo extends StatelessWidget {
  Future _getFile(BuildContext context, PageTwoModel model) async {
    var filePicked = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    model.setMenuFile(File(filePicked.files.single.path));
  }

  Future _getLogo(BuildContext context, PageTwoModel model) async {
    var filePicked = await FilePicker.platform.pickFiles(type: FileType.image);
    model.setLogo(File(filePicked.files.single.path));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(360, 692));

    final _model = Provider.of<PageTwoModel>(context);

    Image _defaultImage;
    if (newMenuObj.menuFile == null) {
      _defaultImage = null;
    } else {
      _defaultImage = Image.asset(
        "assets/images/pdf.jpg",
        width: 100.w,
        height: 175.h,
      );
    }
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
      body: Center(
        child: Stack(
          children: [
            Transform(
              alignment: FractionalOffset.topRight,
              transform: Matrix4.rotationZ(0.9),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(400),
                        left: Radius.circular(100))),
                width: MediaQuery.of(context).size.width,
                height: 600,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Currency: "),
                        DropdownButton(
                            value: newMenuObj.currency,
                            items: ['CAD', 'USD']
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String newValue) {
                              _model.setSelectedCurrency(newValue);
                            }),
                      ],
                    ),
                  ),
                ),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
                  elevation: 5.0,
                  color: Color(0xffEE8833),
                  icon: Icon(Icons.attach_file),
                  label: Text("Choose Your Menu"),
                  onPressed: () {
                    _getFile(context, _model);
                  },
                ),
                Container(
                  child: Material(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LargeImage(newMenuObj.menuFile)));
                      },
                      child: Container(
                        width: 100.w,
                        height: 150.h,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: _defaultImage),
                      ),
                    ),
                  ),
                ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          elevation: 5.0,
                          color: Color(0xffEE8833),
                          icon: Icon(FontAwesomeIcons.file),
                          label: Text("Choose Your Logo"),
                          onPressed: () {
                            _getLogo(context, _model);
                          },
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: newMenuObj.logo != null
                            ? Image.file(newMenuObj.logo)
                            : SizedBox(),
                      )
                    ],
                  ),
                ),
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
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Container(
                          width: 150.0,
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7.0))),
                            elevation: 5.0,
                            icon: Icon(CupertinoIcons.right_chevron),
                            label: Text("Next"),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageThree()),
                            ),
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
      ),
    );
  }
}

class LargeImage extends StatefulWidget {
  final File file;

  LargeImage(this.file);

  @override
  _LargeImageState createState() => _LargeImageState();
}

class _LargeImageState extends State<LargeImage> {
  bool _loading = true;
  PDFDocument _document;

  _getPDF() async {
    setState(() {
      _loading = true;
    });
    _document = await PDFDocument.fromFile(widget.file);
    setState(() {
      _loading = false;
    });
  }

  void initState() {
    super.initState();
    _getPDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selected PDF',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: _document,
            ),
    );
  }
}
