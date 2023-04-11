import 'dart:async';
import 'package:object_detection/food_diary/Ocr.dart';
import 'package:object_detection/food_diary/food_camera.dart';
import 'package:object_detection/food_diary/food_hand.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/food_diary/food_search.dart';

import 'ScanResult.dart';
// import 'addData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';//安裝package在pubspace.yaml
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:sizer/sizer.dart';
import 'package:object_detection/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Addrecord());
}

class Addrecord extends StatefulWidget {
  @override
  _barcodeState createState() => _barcodeState();
}

class _barcodeState extends State<Addrecord> {

  final ref = FirebaseFirestore.instance.collection('barcode');
  String _scanBarcode = '';
  String _name="";
  String _calorie="",_pro="",_fat="",_carb="";
  bool _exist=false;

  @override
  Future initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    Widget swapWidget;
    Widget contentWidget;

    if (_exist==false) {
      contentWidget=new Text("");
    } else {
      contentWidget=new Text("條碼 :"+_scanBarcode+"\n"
          +"品名 :"+_name+"\n"
          +"熱量 :"+_calorie+"\n"
          +"蛋白質 :"+_pro+"\n"
          +"脂肪 :"+_fat+"\n"
          +"碳水化合物 :"+_carb+"\n",

          style: TextStyle(fontSize: 14.sp));
    }
    return Scaffold(
        body:Stack(
            children: <Widget>[
              Positioned(
                top: -250/h*_height,
                left: -10/w*_width,
                child: Container(
                  height: 600/h*_height,
                  width: 600/w*_width,
                  decoration: BoxDecoration(
                    color: Color(0xffBCD4E6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -90/h*_height,
                left: -30/w*_width,
                child: Container(
                  height: 350/h*_height,
                  width: 350/w*_width,
                  decoration: BoxDecoration(
                    color: Color(0x80BCD4E6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -10/h*_height,
                right: -150/w*_width,
                child: Container(
                  height: 350/h*_height,
                  width: 350/w*_width,
                  decoration: BoxDecoration(
                    color: Color(0x99BCD4E6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: _width*0.02,),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          padding: const EdgeInsets.all(4),
                          iconSize: 40,
                          icon: Icon(Icons.arrow_back_ios_outlined),
                          color: Colors.black,
                          onPressed: (){
                            Navigator.pop(context,);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => food_record()),);
                          },
                        ),
                      ),
                      Text(
                        "食物辨識",
                        style: TextStyle(
                          color:Color(0xFF48406C),
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          letterSpacing: 5,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.only(top:_width*0.2,bottom: _width*0.1),
                    child: Text(
                      "請選擇新增方式~",
                      style: TextStyle(
                        color:Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 22.sp,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 100/h*_height,
                                    width: 100/w*_width,
                                    decoration: BoxDecoration(
                                      color: Color(0xffEBF5EE),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(18),
                                      iconSize: 20/h*_height,
                                      icon: Image.asset('assets/photo-camera.png'),
                                      color: Colors.black,
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodCamera(value: "camera",)),);
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => food_detection()));
                                      },
                                    ),
                                  ),
                                  Text("拍照",
                                    style: TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ) ,
                                  )
                                ],
                              ),
                              // SizedBox(width: 40,),
                              Column(
                                children: [
                                  Container(
                                    height: 100/h*_height,
                                    width: 100/w*_width,
                                    decoration: BoxDecoration(
                                      color: Color(0xffEBF5EE),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(20),
                                      icon: Image.asset('assets/landscape.png'),
                                      color: Colors.black,
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  FoodCamera(value: "file")),);
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => food_detection()));
                                      },
                                    ),
                                  ),
                                  Text("從相簿選擇",
                                    style: TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ) ,
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 50/h*_height,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 100/h*_height,
                                    width: 100/w*_width,
                                    decoration: BoxDecoration(
                                      color: Color(0xffEBF5EE),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      padding: const EdgeInsets.all(20),
                                      iconSize: 20/h*_height,
                                      icon: Image.asset('assets/barcode.png'),
                                      color: Colors.black,
                                      onPressed: () async {
                                        await scanBarcodeNormal();
                                        if(_scanBarcode=='-1'){  Navigator.pop(context);
                                        }
                                        // if(_exist==false){  Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => Ocr(value: _scanBarcode)),);
                                        // }
                                        else
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Ocr(value: _scanBarcode,exist: _exist,)),);
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(value: _scanBarcode)),);
                                      },
                                    ),
                                  ),
                                  Text("掃描條碼",
                                    style: TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ) ,
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 100/h*_height,
                                    width: 100/w*_width,
                                    decoration: BoxDecoration(
                                      color: Color(0xffEBF5EE),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.search),
                                      // padding: const EdgeInsets.all(18),
                                      iconSize: 70/h*_height,
                                      color: Colors.black,
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => food_search()),);
                                      },
                                    ),
                                  ),
                                  Text("手動搜尋",
                                    style: TextStyle(
                                      color:Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.sp,
                                    ) ,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //contentWidget,
            ])
    );
  }

  Future<void> scanBarcodeNormal() async {

    String barcodeScanRes;
    bool exist;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return; //判斷頁面是否被釋放


    await ref.doc(barcodeScanRes).get().then((DocumentSnapshot doc) {
      exist=doc.exists;
      print(_exist);
      if(doc.exists==true) {
        _name = doc['name'];
        _calorie = doc['calorie'];
        _pro = doc['protein'];
        _fat = doc['fat'];
        _carb = doc['carbohydrate'];
      }
    });

      setState(() {
        _scanBarcode = barcodeScanRes;
        _exist=exist;
      });
  }



}