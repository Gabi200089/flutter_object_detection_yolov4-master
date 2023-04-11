import 'dart:convert';

import 'package:object_detection/Stripe/checkout/server_stub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';
import '../pay.dart';

void redirectToCheckout(BuildContext context) async {
  final sessionId = await Server().createCheckout();
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckoutPage(sessionId: sessionId),
  ));
}

class CheckoutPage extends StatefulWidget {
  final String sessionId;

  const CheckoutPage({Key key, this.sessionId}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) =>
            _webViewController = webViewController,
        onPageFinished: (String url) {
          if (url == initialUrl) {
            _redirectToStripe(widget.sessionId);
          }
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('http://localhost:8080/#/success')) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SuccessPage()),);
            //Navigator.of(context).pushReplacementNamed('/success');
            // Navigator.of(context).pop('success');
          } else if (request.url.startsWith('http://localhost:8080/#/cancel')) {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()),);
            //Navigator.of(context).pushReplacementNamed('/cancel');
            Navigator.of(context).pop('cancel');
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  //String get initialUrl => 'https://marcinusx.github.io/test1/index.html';
  String get initialUrl =>'data:text/html;base64,${base64Encode(Utf8Encoder().convert(kStripeHtmlPage))}';

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
var stripe = Stripe(\'$apiKey\');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';

    try {
      await _webViewController.evaluateJavascript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }
}

const String kStripeHtmlPage='''
<!DOCTYPE html>
<html>
<script src="https://js.stripe.com/v3/"></script>
<head><title>Stripe checkout</title></head>
<style>
.content{
position: absolute;
top: 40%;
left: 50%;
transform: translateY(-50%);
transform: translateX(-50%);
/* padding: 100px 0; */
}
.content div{
padding-top: 15%;
font-size: 36px;
text-align: center;
}
</style>
<body>
<div class="content">
<div>
<img src="asset:assets/pay_loading.gif" alt="">
</div>
<div>
<b>準備中...</b>
</div>
</div>
</body>
</html>
''';