import 'dart:async';
import 'dart:io';

import 'package:object_detection/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


import 'package:sizer/sizer.dart';

import 'mall.dart';


//Future main() async {
// WidgetsFlutterBinding.ensureInitialized();
//await SystemChrome.setPreferredOrientations([
//  DeviceOrientation.portraitUp,
//  DeviceOrientation.portraitDown,
// ]);

// await Firebase.initializeApp();

// runApp(MyApp());
//}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(mall_inside());
}

class mall_inside extends StatelessWidget {
  static final String title = '素食';

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        //theme: ThemeData(primarySwatch: Colors.white),
        home: mall_inside(),
      );
}

class mallInside extends StatefulWidget {
  int value;

  mallInside({this.value});

  @override
  _mallInsideState createState() => _mallInsideState(this.value);
}

class _mallInsideState extends State<mallInside> {

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String today;

  String temp;
  int value;

  List id = [];

  int index;
  int new_num = 1;
  bool _PlussEnabled = true;
  bool _MinusEnabled = true;

  //食譜變數
  String word = '';

  int recipe_index = 0;
  bool has = false;

  final refdiscount = FirebaseFirestore.instance.collection(
      'discount_products');
  final refshop = FirebaseFirestore.instance.collection('shopping_cart');


  Future<String> getData1() async {
    QuerySnapshot querySnapshot =
    await refdiscount.doc('Store').collection('FoundJung').get();
    final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
    product5 = id_Data;

    final price_Data =
    querySnapshot.docs.map((doc) => temp = doc['price']).toList();
    prices5 = price_Data;

    final pic_Data =
    querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
    picture5 = pic_Data;

    final link_Data =
    querySnapshot.docs.map((doc) => temp = doc['link']).toList();
    links5 = link_Data;

    final original_Data =
    querySnapshot.docs.map((doc) => temp = doc['original_price']).toList();
    original5 = original_Data;

    // print(product2[0]);
    // print(prices2[0]);
    // print(picture2[0]);
    // print(links2[0]);
    // print(original2[0]);
  } //家樂福


  Future uploadFile() async {
    await refshop.doc('userdata').collection(user_email).add(
        {
          'name': product5[index],
          'num': new_num.toString(),
          'amount': (int.parse(prices5[index]) * new_num).toString(),
          'picture': picture5[index],
          'price': prices5[index]
        })
        .then((value) =>
    {
      // _txtName.clear(),
      new_num = 1,
      // _txtExp.clear()
    });
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => mall(), maintainState: false));
  }


  @override
  void initState() {
    // TODO: implement initState
    getData1();
    check();
    super.initState();
  }

  _mallInsideState(this.value);

  void check() {
    index = foundjung_index;
  }

  String time_short;

  void _plusCheck() {
    (new_num <= 1) ? _MinusEnabled = false : _MinusEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    Size size = MediaQuery
        .of(context)
        .size;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    (new_num == 1) ? _MinusEnabled = false : _MinusEnabled = true;
    return Scaffold(
      backgroundColor: Color(0xFF4472C4),
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: size.height * 0.09,
              child:
              Row(
                  children: [
                    Container(
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40 / h1 * height,
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (
                              context) => mall()),);
                        },
                      ),
                    ),

                  ]
              ),
            ),
            // SizedBox(height: height*0.2),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top:width*0.3),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: const Radius.circular(40),
                    ),
                    child: Container(
                      color: Color(0xFFF3F4FB),
                      padding: EdgeInsets.only(
                          top: width*0.2,left: 40/w1*width, right: 40/w1*width, bottom: 70/h1*height),
                      child: Column(
                          children: [
                            SizedBox(height: 30/h1*height,),

                            Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(20.0),
                              //   border: Border.all(
                              //       color: Color(0xff7E7F9A),
                              //       width: 3,
                              //       style: BorderStyle.solid
                              //   ),
                              // ),
                              height: 104 / h1 * height,
                              alignment: Alignment.center,
                              child: Text(
                                product5[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  fontSize: (product5[index].length <=10 )
                                      ? 18.sp
                                      : 16.sp,
                                ),
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),

                            SizedBox(height: 20/h1*height,),

                            Text(
                              '\$' + prices5[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF0808),
                                fontSize: 24.sp,
                                letterSpacing: 2,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: 30/h1*height,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawMaterialButton(
                                  child: Icon(FontAwesomeIcons.minus,
                                    color: Color(0xFF092A44),
                                    size: 30 / h1 * height,),
                                  shape: CircleBorder(),
                                  elevation: 5.0,
                                  fillColor: Color(0xffFAF4F2),
                                  padding: const EdgeInsets.all(10.0),
                                  // color: Color(0xFF49416D),
                                  onPressed: () {
                                    if (_MinusEnabled) {
                                      setState(() {
                                        new_num -= 1;
                                        print(new_num);
                                      });
                                      _plusCheck();
                                    }
                                    else
                                      null;
                                  },
                                ),

                                Container(
                                  width: size.width * 0.2,
                                  alignment: Alignment.center,
                                  child:
                                  Text(new_num.toString() + "份",
                                    style: TextStyle(
                                      color: Color(0xFF48406C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 28.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                RawMaterialButton(
                                  child: Icon(FontAwesomeIcons.plus,
                                    color: Color(0xFF092A44),
                                    size: 30 / h1 * height,),
                                  shape: CircleBorder(),
                                  elevation: 5.0,
                                  fillColor: Color(0xffFAF4F2),
                                  padding: const EdgeInsets.all(10.0),
                                  onPressed: () {
                                    if (_PlussEnabled) {
                                      setState(() {
                                        new_num += 1;
                                        print(new_num);
                                      });
                                      _plusCheck();
                                    }
                                    else
                                      null;
                                  },
                                ),

                              ],),
                            SizedBox(height: 30/h1*height,),
                            Text(
                              '金額：\$' + (int.parse(prices5[index]) * new_num)
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4472C4),
                                fontSize: 16.sp,
                                letterSpacing: 2,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: 15/h1*height,),
                            Container(
                              height: 55 / h1 * height,
                              width: 200 / w1 * width,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent,
                                      width: 0),
                                  borderRadius: BorderRadius.circular(18),
                                  color: Color(0xFF4472C4),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 3.0, //影子圓周
                                        offset: Offset(3, 3) //影子位移
                                    )
                                  ]
                              ),
                              child: FlatButton(
                                padding: const EdgeInsets.all(4),
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add, size: 40, color: Colors.white,),
                                    Padding(padding: EdgeInsets.only(
                                      right: 10 / w1 * width,
                                    )),
                                    Text("加入購物車",
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
                                // color: Color(0xFF49416D),
                                onPressed: () async {
                                  uploadFile();
                                },
                              ),
                            ),

                          ]),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    width: 220/w1*width,
                    height: 220/h1*height,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image(
                        image: NetworkImage(picture5[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 30/h1*height,),
              ],
            ),

          ],
        ),
      ),
    );
  }


}

