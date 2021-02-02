import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:loading_button/loading_button.dart';

import 'package:e_menu_for_company/other/util/rest_calls.dart';
import 'package:e_menu_for_company/screens/main_pages/page_one.dart';

class PaymentButton extends StatefulWidget {
  @override
  _PaymentButtonState createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  bool _isLoading = false;

  Future _accountOnboarding() async {
    setState(() {
      _isLoading = true;
    });
    var createAccount =
        await RESTCallStripe.post('v1/accounts', data: {'type': 'standard'});
    String accountID = createAccount['id'];
    Map dataToPost = {
      'account': createAccount['id'],
      'refresh_url': 'https://emenu-service.herokuapp.com/',
      'return_url': 'https://emenu-service.herokuapp.com/',
      'type': 'account_onboarding'
    };
    var createAccountLink =
        await RESTCallStripe.post('v1/account_links', data: dataToPost);
    String accountLink = createAccountLink['url'];
    newMenuObj.setStripeID(accountID);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PaymentWebView(accountLink)));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingButton(
        backgroundColor:
            newMenuObj.stripeID == null ? Colors.blueAccent : Colors.green,
        isLoading: _isLoading,
        child: Text(
          "Link Stripe",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await _accountOnboarding();
        });
  }
}

class PaymentWebView extends StatefulWidget {
  final String accountLink;
  PaymentWebView(this.accountLink);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Get Paid",
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebView(
        initialUrl: widget.accountLink,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
