// import 'package:barcode_scanner/Stripe/checkout_page.dart';
// import 'package:barcode_scanner/Stripe/server_stub.dart';
// import 'package:flutter/material.dart';
//
// import 'checkout/server_stub.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Stripe Checkout Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HomePage(),
//       // routes: {
//       //   '/': (_) => HomePage(),
//       //   '/success': (_) => SuccessPage(),
//       // },
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Builder(
//         builder: (context) {
//           return Center(
//             child: RaisedButton(
//               onPressed: ()async {
//                 final sessionId=await Server1().createCheckout();
//                 await Navigator.of(context).push(MaterialPageRoute(
//                     builder: (_)=>CheckoutPage(
//                       sessionId: sessionId,
//                     )));
//                 final snackbar=SnackBar(content: Text('SessionId: $sessionId'));
//               Scaffold.of(context).showSnackBar(snackbar);
//                 },
//               // onPressed: () => redirectToCheckout(context),
//               child: Text('Stripe Checkout in Flutter!'),
//             ),
//           );
//         }
//       ),
//     );
//   }
// }
//
// class SuccessPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           'Success',
//           style: Theme.of(context).textTheme.headline1,
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/global.dart';

import 'package:object_detection/mall/mall.dart';
import 'checkout/stripe_checkout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe Checkout Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (_) => HomePage(),
        '/success': (_) => SuccessPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([]);//隱藏status bar
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            redirectToCheckout(context);
            // final snackbar=SnackBar(content: Text('交易成功'));
            // Scaffold.of(context).showSnackBar(snackbar);
          } ,
          child: Text('付款'),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([]);//隱藏status bar
    return Scaffold(
      backgroundColor: Color(0xFFF3F4FB),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/30.png",
                width: width*0.75,
                // width: 125.0,
              ),
              Text(
                '交易成功',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing:10,
                ),
              ),
              SizedBox(height: width*0.03,),
              Text(
                '請至信箱確認訂單',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing:8,
                ),
              ),
              SizedBox(height: width*0.1,),
              Container(
                height: w*0.13,
                width: w*0.26,
                child: RaisedButton(
                  elevation: 3,
                  color: Color(0xff4472C4),
                  onPressed: () {
                    delshop().then((_) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => mall(),
                              maintainState: false));
                    });

                  } ,
                  child: Text('完成',style: TextStyle(color: Colors.white,fontSize: 26,letterSpacing: 4),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future delshop()async{
    final refshop = FirebaseFirestore.instance.collection('shopping_cart').doc('userdata').collection(user_email);
    var snapshots = await refshop.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }
}