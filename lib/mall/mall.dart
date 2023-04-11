import 'dart:async';

import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:object_detection/mall/shopping.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'package:object_detection/global.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mall_inside.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(mall());
}

class mall extends StatelessWidget {
  static final String title = '素食商城';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: mallPage(),
  );
}

class mallPage extends StatefulWidget {
  int value;
  mallPage({this.value});
  @override
  _mallPageState createState() => _mallPageState(this.value);
}

class _mallPageState extends State<mallPage> {
  String temp;
  int value;

  bool datagot1 = false;
  // bool datagot5 = false;

  String word = '';

  Timer timer;
  bool refresh=false;

  // int _select = 0;
  // //
  // final  List<Widget> _Options = <Widget>[
  //   discount1(),
  //   discount2(),
  //   discount3(),
  //   discount4(),
  //   // discount5(),
  // ];

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
    links5= link_Data;

    datagot1 = true;

    // print(product2[0]);
    // print(prices2[0]);
    // print(picture2[0]);
    // print(links2[0]);
    // print(original2[0]);
  } //家樂福


  _mallPageState(this.value);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData1();

    // getData5();
    datagot1 = false;

    // datagot5 = false;
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => selectchanged());
    // fetchFileData();
  }
  // void _onItemTapped(int index) { //onTap換index
  //   setState(() {
  //     _select = index;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    // search="雞腿";
    Size size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    return FutureBuilder<List<String>>(
      future: Future.wait([
        getData1(),
        // getData5(),
      ]),// function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot1 == false){
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
                      SizedBox(height:height * 0.236,),
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
                    child: Stack(
                      children: [
                        Row(children: [
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: 40/h*height,
                            icon: Icon(Icons.arrow_back_ios_outlined),
                            color: Colors.black,
                            onPressed: () {
                              search="";
                              Navigator.push(context,MaterialPageRoute(builder: (context) => SettingScreen()),);
                            },
                          ),
                          Text(
                            "素食商城",
                            style: TextStyle(
                              letterSpacing: 7,
                              height: height*0.0013,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                              color: Colors.black,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: width*0.4)),
                        ]),
                        Positioned(
                          top:0,
                          right: 3,
                          child: IconButton(
                            onPressed: (){
                              _showPickOptionDialog(context);
                            },
                            icon: Icon(Icons.search,size: 30/h*height,color: Color(0xFF5C1A89),),),
                        )
                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(left: width*0.3)),
                          Container(
                            height: height*0.2,
                            width: width*0.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/Dream_Two Color.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Text("峰成素食",
                          //   style: TextStyle(
                          //     letterSpacing: 6,
                          //     height: height*0.0022,
                          //     fontWeight: FontWeight.w700,
                          //     fontSize: 22.sp,
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ]),
                  ),

                  Row(children: [
                    Padding(padding: EdgeInsets.only(left: 30/w1*width)),


                    Container(
                      alignment: Alignment.center,
                      height: 45/h1*height,
                      width: 45/w1*width,
                      decoration: BoxDecoration(
                          color: Color(0xFF4472C4),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3.0,//影子圓周
                                offset: Offset(3, 3)//影子位移
                            )
                          ]
                      ),
                      child: IconButton(
                        iconSize: 30/h1*height,
                        icon: Icon(Icons.shopping_cart_outlined,color: Colors.white,),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => mallShopping()),);
                        },
                      ),
                    ),


                    // IconButton(
                    //   padding: EdgeInsets.only(left: 30.0/w*width),
                    //   iconSize: 40/h1*height,
                    //   icon: Image.asset('assets/shoppingcart.png'),
                    //   color: Colors.black,
                    //   onPressed: (){
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => mallShopping()),);
                    //   },
                    // ),

                    SizedBox(width: 10/w1*width,),
                    Text("峰成素食",
                      style: TextStyle(
                        // color:Colors.black87,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ) ,
                      textAlign: TextAlign.start,
                    ),

                  ],),
                  // Padding(padding: EdgeInsets.only(top: height*0.0208)),

                  Container(
                    // color: Color(0xFFFAEDCB),
                    //color: Color(0xFFDADEF2),//淺藍色
                    height: height*0.7,
                    width:width,
                    child: ListView.builder(
                      itemCount: product5.length,
                      itemBuilder: (context, index) {
                        return
                          product5[index].contains(search)
                              ?Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width*0.0636, vertical: height*0.0111), //方塊的間距(左右、上下)
                              child:
                              new GestureDetector(
                                // onTap: () {
                                //   //getData();
                                //   launch(links5[index]); //目前沒資料之後改成商品連結~~~
                                // },
                                onTap: (){
                                  foundjung_index=index;
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => mallInside(value: 0,),maintainState: false));
                                },
                                child: new Container(
                                  height: size.height * 0.20,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(20.0), //圓角
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 5.0, //影子圓周
                                            offset: Offset(5, 5) //影子位移
                                        )
                                      ]),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: height*0.034, left: width*0.0458, right: width*0.0458, bottom: height*0.0209),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: size.width * 0.3,
                                              height: size.height * 0.2,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20.0),
                                                child: Image(
                                                  image: NetworkImage(picture5[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: size.width * 0.48,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width*0.0509 / 2, top: height*0.0278 / 2.5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      product5[index],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black.withOpacity(0.9),
                                                        fontWeight: FontWeight.w600,
                                                        letterSpacing: 2,
                                                        fontSize: (product5[index].length <= 5)
                                                            ? 18.sp
                                                            : 14.sp,
                                                      ),
                                                      maxLines: 2,
                                                      softWrap: true,
                                                    ),
                                                    SizedBox(
                                                      height: size.height * 0.01,
                                                    ),
                                                    // Row(
                                                    //   children: [
                                                    // Icon(Icons.folder_open_rounded,color: Colors.black.withOpacity(0.3),),
                                                    SizedBox(
                                                      width: size.width * 0.01,
                                                    ),
                                                    Container(
                                                      // width: size.width * 0.48,
                                                      child: Row(children: [
                                                        SizedBox(
                                                          width: size.width * 0.04,
                                                        ), //空格!
                                                        Text(
                                                          "\$"+prices5[index],
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFFFF0808),
                                                            fontSize: 18.sp,
                                                            letterSpacing: 2,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ]),
                                                    ),
                                                  ], //Column children
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          )
                              :Container(height: height*0,);
                      },
                    ),
                  ),

                  // _Options.elementAt(_select),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => mall()),);
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
