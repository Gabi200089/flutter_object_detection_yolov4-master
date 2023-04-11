import 'dart:async';

import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'discount1.dart';
import 'discount2.dart';
import 'discount3.dart';
import 'discount4.dart';
import 'package:object_detection/global.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(discount());
}

class discount extends StatelessWidget {
  static final String title = '撿便宜專區';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: disCount(),
  );
}

class disCount extends StatefulWidget {
  int value;
  disCount({this.value});
  @override
  _disCountState createState() => _disCountState(this.value);
}

class _disCountState extends State<disCount> {
  String temp;
  int value;

  bool datagot1 = false;
  bool datagot2 = false;
  bool datagot3 = false;
  bool datagot4 = false;
  // bool datagot5 = false;

  String word = '';

  Timer timer;
  bool refresh=false;

  int _select = 0;
  //
  final  List<Widget> _Options = <Widget>[
    discount1(),
    discount2(),
    discount3(),
    discount4(),
    // discount5(),
  ];

  // selectchanged(){
  //   if(refresh==false) {
  //     setState(() {
  //       _select = 0;
  //       refresh=true;
  //       build(this.context);
  //     });
  //   }
  //   else
  //     timer.cancel();
  // }

  //bool has=false;
  final refdiscount = FirebaseFirestore.instance.collection('discount_products');

  Future<String> getData1() async {
    QuerySnapshot querySnapshot =
    await refdiscount.doc('Store').collection('simple_mart').get();

    final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
    product1 = id_Data;

    // final price_Data =
    // querySnapshot.docs.map((doc) => temp = doc['price']).toList();
    // prices1 = price_Data;

    final pic_Data =
    querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
    picture1 = pic_Data;

    final link_Data =
    querySnapshot.docs.map((doc) => temp = doc['link']).toList();
    links1 = link_Data;

    // final original_Data =
    // querySnapshot.docs.map((doc) => temp = doc['original_price']).toList();
    // original1 = original_Data;

    QuerySnapshot querySnapshot1 =
    await refdiscount.doc('Store').collection('Carrefour').get();

    final id_Data1 = querySnapshot1.docs.map((doc) => temp = doc.id).toList();
    product1 += id_Data1;

    final price_Data1 =
    querySnapshot1.docs.map((doc) => temp = doc['price']).toList();
    prices1 += price_Data1;

    final pic_Data1 =
    querySnapshot1.docs.map((doc) => temp = doc['picture']).toList();
    picture1 += pic_Data1;

    final link_Data1 =
    querySnapshot1.docs.map((doc) => temp = doc['link']).toList();
    links1 += link_Data1;

    final original_Data1 =
    querySnapshot1.docs.map((doc) => temp = doc['original_price']).toList();
    original1 += original_Data1;

    QuerySnapshot querySnapshot2 =
    await refdiscount.doc('Store').collection('PX_Mart').get();

    final id_Data2 = querySnapshot2.docs.map((doc) => temp = doc.id).toList();
    product1 += id_Data2;

    final price_Data2 =
    querySnapshot2.docs.map((doc) => temp = doc['price']).toList();
    prices1 += price_Data2;

    final pic_Data2 =
    querySnapshot2.docs.map((doc) => temp = doc['picture']).toList();
    picture1 += pic_Data2;

    final link_Data2 =
    querySnapshot2.docs.map((doc) => temp = doc['link']).toList();
    links1 += link_Data2;

    final original_Data2 =
    querySnapshot2.docs.map((doc) => temp = doc['original_price']).toList();
    original1 += original_Data2;


    datagot1 = true;
  } //全部

  Future<String> getData2() async {
    QuerySnapshot querySnapshot =
    await refdiscount.doc('Store').collection('Carrefour').get();
    final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
    product2 = id_Data;

    final price_Data =
    querySnapshot.docs.map((doc) => temp = doc['price']).toList();
    prices2 = price_Data;

    final pic_Data =
    querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
    picture2 = pic_Data;

    final link_Data =
    querySnapshot.docs.map((doc) => temp = doc['link']).toList();
    links2= link_Data;

    final original_Data =
    querySnapshot.docs.map((doc) => temp = doc['original_price']).toList();
    original2 = original_Data;

    datagot2 = true;

    // print(product2[0]);
    // print(prices2[0]);
    // print(picture2[0]);
    // print(links2[0]);
    // print(original2[0]);
  } //家樂福

  Future<String> getData3() async {
    QuerySnapshot querySnapshot =
    await refdiscount.doc('Store').collection('PX_Mart').get();
    final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
    product3 = id_Data;

    final price_Data =
    querySnapshot.docs.map((doc) => temp = doc['price']).toList();
    prices3 = price_Data;

    final pic_Data =
    querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
    picture3 = pic_Data;

    final link_Data =
    querySnapshot.docs.map((doc) => temp = doc['link']).toList();
    links3 = link_Data;

    final original_Data =
    querySnapshot.docs.map((doc) => temp = doc['original_price']).toList();
    original3 = original_Data;

    datagot3 = true;

    // print(product[0]);
    // print(prices[0]);
    // print(picture[0]);
    // print(links[0]);
    // print(original[0]);
  } //全聯

  Future<String> getData4() async {
    QuerySnapshot querySnapshot =
    await refdiscount.doc('Store').collection('simple_mart').get();
    final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
    product4 = id_Data;

    final price_Data =
    querySnapshot.docs.map((doc) => temp = doc['price']).toList();
    prices4 = price_Data;

    final pic_Data =
    querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
    picture4 = pic_Data;

    final link_Data =
    querySnapshot.docs.map((doc) => temp = doc['link']).toList();
    links4 = link_Data;

    final original_Data =
    querySnapshot.docs.map((doc) => temp = doc['original_price']).toList();
    original4 = original_Data;

    datagot4 = true;

    // print(product[0]);
    // print(prices[0]);
    // print(picture[0]);
    // print(links[0]);
    // print(original[0]);
  } //美廉社


  // Future<String> getData5() async {
  //   QuerySnapshot querySnapshot =
  //   await refdiscount.doc('Store').collection('FoundJung').get();
  //   final id_Data = querySnapshot.docs.map((doc) => temp = doc.id).toList();
  //   product5 = id_Data;
  //
  //   // final price_Data =
  //   // querySnapshot.docs.map((doc) => temp = doc['price']).toList();
  //   // prices5 = price_Data;
  //
  //   final pic_Data =
  //   querySnapshot.docs.map((doc) => temp = doc['picture']).toList();
  //   picture5 = pic_Data;
  //
  //   final link_Data =
  //   querySnapshot.docs.map((doc) => temp = doc['link']).toList();
  //   links5 = link_Data;
  //
  //   // final original_Data =
  //   // querySnapshot.docs.map((doc) => temp = doc['original_price']).toList();
  //   // original5 = original_Data;
  //
  //   datagot5 = true;
  //
  //   print(product5[0]);
  //   // print(prices5[0]);
  //   print(picture5[0]);
  //   print(links5[0]);
  //   // print(original5[0]);
  // } //素食

  _disCountState(this.value);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData1();
    getData2();
    getData3();
    getData4();
    // getData5();
    datagot1 = false;
    datagot2 = false;
    datagot3 = false;
    datagot4 = false;
    // datagot5 = false;
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => selectchanged());
    // fetchFileData();
  }
  void _onItemTapped(int index) { //onTap換index
    setState(() {
      _select = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    // search="雞腿";
    Size size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom]); //隱藏status bar
    return FutureBuilder<List<String>>(
      future: Future.wait([
        getData1(),
        getData2(),
        getData3(),
        getData4(),
        // getData5(),
      ]),// function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot1 == false||datagot2 == false||datagot3 == false||datagot4 == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFF9575CD),
                  child:
                  Column(
                    children: [
                      SizedBox(height:height * 0.17,),
                      Image.asset(
                        "assets/loading5.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          letterSpacing: 4,
                        ) ,
                      ),
                    ],
                  )
              ),
            ),
          );
        }else{
          return Scaffold(
            body:
                SingleChildScrollView(
            child:Container(
              color: Color(0xFFDADEF2),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  child: Row(children: [
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 40,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.black,
                      onPressed: () {
                        search="";
                        Navigator.push(context,MaterialPageRoute(builder: (context) => SettingScreen()),);
                      },
                    ),
                    Text(
                      "撿便宜專區",
                      style: TextStyle(
                        letterSpacing: 7,
                        height: height*0.0013,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: width*0.32)),
                    GestureDetector(
                      onTap: (){
                        _showPickOptionDialog(context);
                      },
                      child: Container(
                        child: Icon(Icons.search,size: 30/h*height,color: Color(0xFF5C1A89),),
                      ),
                    )
                  ]),
                ),

                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(left: width*0.0382)),
                        Container(
                          height: height*0.25,
                          width: width*0.433,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/money1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Text("The\nCheapest!",
                          style: TextStyle(
                            letterSpacing: 6,
                            height: height*0.0022,
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                ),


                Padding(padding: EdgeInsets.only(top: height*0.0208)),
                CurvedNavigationBar(
                  // color: Colors.white,
                  color:Color(0xFFFAEDCB),
                  backgroundColor: Color(0xFFDADEF2),
                  height: height*0.0598,
                  items: [
                    Container(
                      width:width*0.153,
                      height:height*0.083,
                      child: Image(image: AssetImage('assets/all.png'),),
                    ),
                    Container(
                      width:width*0.165,
                      height:height*0.0904,
                      child: Image(image: AssetImage('assets/Carrefour.png'),),
                    ),
                    Container(
                      width:width*0.153,
                      height:height*0.083,
                      child: Image(image: AssetImage('assets/PXMart.png'),),
                    ),
                    Container(
                      width:width*0.153,
                      height:height*0.083,
                      child: Image(image: AssetImage('assets/SimpleMart.png'),),
                    ),
                    // Container(
                    //   width:width*0.153,
                    //   height:height*0.083,
                    //   child: Image(image: AssetImage('assets/4.png'),),
                    // ),

                    // Icon(Icons.list,size: 25,color:Colors.black),
                    // Icon(Icons.filter_1,size: 25,color:Colors.black),
                    // Icon(Icons.filter_2,size: 25,color:Colors.black),
                    // Icon(Icons.filter_3,size: 25,color:Colors.black),
                    // Icon(Icons.filter_4,size: 25,color:Colors.black)個
                  ],
                  animationDuration: Duration(milliseconds: 600),//4個
                 //animationCurve: Curves.fastOutSlowIn,
                  index: _select, //一開始顯示的頁面
                  onTap: _onItemTapped,
                ),
                _Options.elementAt(_select),
                // selectchanged(),
              ],),

            ),
                ),
          );
        }
      },
    );

  }
  void _showPickOptionDialog(BuildContext context) {
    final TextEditingController _txtsearch = new TextEditingController();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    _txtsearch.text="";
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: width,
                height: height*0.32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xff434352),
                ),
              ),
              Container(
                width: width,
                height: height*0.3,
                child: Column(
                  children: [

                    SizedBox(height: height*0.007,),
                    Text(
                      '好康查詢',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: height*0.007,),
                    Text(
                      '請在下面輸入相關的關鍵字',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: height*0.007,),
                    Container(
                      width: width,
                      child:  TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                        controller: _txtsearch,
                        // validator: (val)=>val.isEmpty?"搜尋不得空白喔~":null,
                        decoration: InputDecoration(
                            contentPadding:EdgeInsets.symmetric(horizontal: width*0.1018),
                            fillColor: Colors.transparent,
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:width*0.005)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:width*0.005)),
                            hintText: "EX.雞腿、魚、披薩",
                            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                            // labelText: "名稱",
                            // labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                            border:  UnderlineInputBorder(),
                            filled: true),
                        maxLength: 15,
                      ),
                    ),
                    SizedBox(
                      width: width*0.178,
                      height: height*0.1,
                      child:
                      FlatButton(
                        onPressed: (){
                          search=_txtsearch.text;
                          // Navigator.pop(this.context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => discount()),);
                        },
                        child:Container(
                          alignment: Alignment.center,
                          height: height*0.056,
                          width: width*0.102,
                          decoration: BoxDecoration(
                            color: Color(0xff434352),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white,
                                width: width*0.005,
                                style: BorderStyle.solid
                            ),
                          ),
                          child:
                          Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
