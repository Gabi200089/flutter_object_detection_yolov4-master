import 'dart:async';
import 'dart:io';

import 'package:object_detection/Stripe/constants.dart';
import 'package:object_detection/global.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:sizer/sizer.dart';

import 'package:object_detection/Stripe/checkout/stripe_checkout.dart';
import 'package:object_detection/Stripe/pay.dart';
import 'mall.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(mall_Shopping());
}

class mall_Shopping extends StatelessWidget {
  static final String title = '素食';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: mall_Shopping(),
  );
}

class mallShopping extends StatefulWidget {
  int value;

  mallShopping({this.value});

  @override
  _mallShoppingState createState() => _mallShoppingState(this.value);
}

class _mallShoppingState extends State<mallShopping> {
  String temp;
  int value;

  int index;
  int new_num = 1;

  bool datagot = false;

  int total = 0;

  Future plus() async{
    if(datagot==false)
    {
      total = 0;
      int n = amount0.length - 1;
      for (int j = 0; j <= n; j++) total += int.parse(amount0[j]);
      print(amount0);
      return total;
    }
  }
  plus_after_delete(){
    total = 0;
    int n = amount0.length - 1;
    for (int j = 0; j <= n; j++) total += int.parse(amount0[j]);
    print(amount0);
    setState(() {
      total=total;
    });
  }
  @override
  final refshopping = FirebaseFirestore.instance.collection('shopping_cart');

  Future<String> getData0() async {
    QuerySnapshot querySnapshot =
    await refshopping.doc('userdata').collection(user_email).get();
    final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
    id0 = id_Data;
    final amount_Data =
    querySnapshot.docs.map((doc) => temp = doc['amount']).toList();
    amount0 = amount_Data;

    final pic_Data =
    querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
    picture0 = pic_Data;

    final num_Data =
    querySnapshot.docs.map((doc) => temp = doc['num']).toList();
    num0 = num_Data;

    final name_Data =
    querySnapshot.docs.map((doc) => temp = doc['name']).toList();
    name0 = name_Data;

    final price_Data =
    querySnapshot.docs.map((doc) => temp = doc['price']).toList();
    prices0 = price_Data;

    plus().then((value) => datagot = true);
    print(total);
  }

  deleteshop(item) {
    DocumentReference documentReference= refshopping.doc('userdata').collection(user_email).doc(item) ;
    return documentReference.delete();
  }

  // deleteshop(item) {
  //   refshopping.doc('userdata').collection(user_email).doc(item).delete();
  //   getData0();
  //   // return documentReference.delete();
  // }
  // deleteshop(item) {
  //  refshopping.doc('userdata').collection(user_email).doc(item).delete();
  //
  // }

  void initState() {
    // TODO: implement initState

    datagot = false;
    super.initState();
  }

  _mallShoppingState(this.value);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    plus();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    return FutureBuilder<String>(
      future: getData0(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
        if (datagot == false) {
          return Scaffold(
            body: Center(
              child: Container(
                  height: height,
                  width: width,
                  color: Color(0xFF9575CD),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150/h1*height,
                      ),
                      Image.asset(
                        "assets/loading5.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      SizedBox(
                        height: 30/h1*height,
                      ),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  )),
            ),
          );
        } else {
          return Scaffold(
              backgroundColor: Color(0xFFDADEF2),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10/h1*height,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(4),
                          icon: Icon(Icons.arrow_back_ios_outlined),
                          color: Colors.black,
                          iconSize: 40/h1*height,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => mall(),
                                    maintainState: false));
                          },
                        ),
                        SizedBox(
                          width: 10/w1*width,
                        ),
                        Center(
                          child: Text(
                            '購物車',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10/h1*height,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: height * 0.58,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(
                              left: width * 0.06,
                              right: width * 0.06,
                              top: width * 0.06),
                          padding: EdgeInsets.only(
                              left: 2/w1*width,
                              right: 2/w1*width,
                              top: width * 0.06,
                              bottom: width * 0.03),
                          child: StreamBuilder(
                              stream: refshopping
                                  .doc('userdata')
                                  .collection(user_email)
                                  .snapshots(),
                              builder: (context, snapshots) {
                                return Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: id0.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        key: UniqueKey(),
                                        background: Container(
                                          padding: EdgeInsets.only(right: 20/w1*width),
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          color: Colors.red,
                                        ),
                                        direction: DismissDirection.endToStart,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.06),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minWidth: 44 / w1 * width,
                                                minHeight: 44 / h1 * height,
                                                maxWidth: 80 / w1 * width,
                                                maxHeight: 80 / h1 * height,
                                              ),
                                              child: Image.network(
                                                  picture0[index],
                                                  fit: BoxFit.cover),
                                            ),
                                            title: Text(
                                              name0[index],
                                              style: TextStyle(
                                                  fontSize: 13.sp,
                                                  letterSpacing: 1),
                                            ),
                                            subtitle: Row(
                                              children: <Widget>[
                                                Text(
                                                  "\$ " + prices0[index],
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                                SizedBox(width: 110/w1*width,),
                                                Text(
                                                  "x " + num0[index],
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // ignore: missing_return
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          return await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("刪除警告"),
                                                  content: Text('你確定要刪除' +
                                                      name0[index] +
                                                      '嗎?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text("否"),
                                                    ),
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                context)
                                                                .pop(true),
                                                        child: const Text("刪除",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent))),
                                                  ],
                                                );
                                              });
                                        },
                                        onDismissed:
                                            (DismissDirection direction) async {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            deleteshop(id0[index]);
                                            getData0().then((value) => plus_after_delete());
                                            setState(()async{
                                              await id0.removeAt(index);
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: width * 0.08),
                              child: Text(
                                '左滑以刪除',
                                style: TextStyle(
                                  color: Color(0xFF4472C4),
                                  fontSize: 18,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10/h1*height,
                    ),
                    Text(
                      "付款明細",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10/h1*height,
                    ),
                    Text(
                      "總金額：\$ " + total.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4472C4),
                        fontSize: 18.sp,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10/h1*height,
                    ),
                    Container(
                      height: 55 / h1 * height,
                      width: 130 / w1 * width,
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.circular(18),
                          color: Color(0xFF4472C4),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3.0, //影子圓周
                                offset: Offset(3, 3) //影子位移
                            )
                          ]),
                      child: FlatButton(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "\$ 結帳",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                letterSpacing: 5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          totalPrice=total*100;
                          redirectToCheckout(context);
                        },
                      ),
                    ),
                  ],
                ),
              ));
        }
      },
    );
  }
}