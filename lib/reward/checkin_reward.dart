import 'dart:async';
import 'dart:io';

import 'package:numberpicker/numberpicker.dart';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/login/components/background.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:object_detection/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckinReward(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CheckinReward extends StatefulWidget {
  @override
  _CheckinRewardState createState() => _CheckinRewardState();
}

class _CheckinRewardState extends State<CheckinReward> {
  List isActive=[false,false,false,false,false,false,false];
  List isToday=[false,false,false,false,false,false,false];
  List dailyPoint=[10,20,30,40,50,50,100];
  int theDay;
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String today ;
  List rewards = [];
  List storages = [];
  List prices = [];
  String warning = '';
  int userPoint;
  int stage;
  String latest;
  String refreshUserPoint = "";
  String rewardItem = '';
  String updateStorage = '';
  String updatePrice = '';
  bool datagot =false;
  bool datagot2 =false;

  int _currentHeight = 160;

  final ref = FirebaseFirestore.instance.collection('user_point');

  Future<String>getData() async {

    var difference;

    await ref.doc(user_email).get().then((DocumentSnapshot doc) {  //rewrite
      userPoint=doc['point'];
      stage=doc['stage'];
      latest=doc['latest'];
    });

    today = formatter.format(now);
    difference = DateTime.parse(today).difference(DateTime.parse(latest));
    if(difference.inDays==1){
      if(stage==7) {
        isToday[0]=true;
        theDay=0;
      }
      else {
        isToday[stage]=true;
        theDay=stage;
        for(var i = 0; i < stage; i++){
          isActive[i]=true;
        }
      }
    }
    else if(difference.inDays==0){
      for(var i = 0; i < stage; i++){
        isActive[i]=true;
      }
    }
    else {
      isToday[0]=true;
      theDay=0;
    }
    print("天:$theDay");  //這個theDay好像get不到值??(原本就壞掉了) by yc

    refreshUserPoint = "點數:"+userPoint.toString();
    print("22222");

    datagot=true;

  }

  Future<String>getrewards() async{
    String name = '';
    String storage = '';
    String price = '';
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('reward');
    await collectionReference.get().then((QuerySnapshot snapshot) async {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        name = doc['name'];
        rewards.add(name);
        storage = doc['storage'];
        storages.add(storage);
        price = doc['price'];
        prices.add(price);
        // print(name);
        // print(storage);
        // print(price);
      });

    });
    print(user_email);
    datagot2 =true;
  }

  updateReward(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection('reward').doc(rewardItem);
    return documentReference.set({
      'name' : rewardItem,
      'storage' : updateStorage,
      'price' : updatePrice,
    });
  }
  updateUserPoint(){
    ref.doc(user_email).update({'point':userPoint});  //rewrite
  }

  @override
  void initState() {
    // TODO: implement initState
    datagot = false;
    datagot2 = false;
    // getData();

    Text(warning);
    Text(refreshUserPoint);
    print(refreshUserPoint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return FutureBuilder<List<String>>(
      future: Future.wait([
        getData(),
        getrewards(),
      ]),// function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false||datagot2 == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFF60C198),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170/h1*height,),
                      Image.asset(
                        "assets/loading3.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xff229272),
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
            backgroundColor: Color(0xffF3F4FB),
            body:
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        // padding: const EdgeInsets.all(4),
                        iconSize: 40/h1*height,
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        color: Colors.black,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()),);
                        },
                      ),
                       SizedBox(width: 40/w1*width,),
                      Center(
                        child: Text(
                          'hEAlThÿ points',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xff203864),
                              fontSize: 18.sp,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 85/w1*width),
                    child: Image.asset(
                      "assets/reward_photo.png",
                    ),
                  ),
                  Text(refreshUserPoint,
                    style:TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                      letterSpacing: 2,
                    ),),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10/h1*height,left: 20/w1*width,right: 20/w1*width),
                          width: 400/w1*width,
                          height: 4,
                          color: Color(0xff4472C4),
                        ),
                        Row(
                          children: [
                            statusWidget('Day1', isActive[0], isToday[0]),
                            statusWidget('Day2', isActive[1], isToday[1]),
                            statusWidget('Day3', isActive[2], isToday[2]),
                            statusWidget('Day4', isActive[3], isToday[3]),
                            statusWidget('Day5', isActive[4], isToday[4]),
                            statusWidget('Day6', isActive[5], isToday[5]),
                            statusWidget('Day7', isActive[6], isToday[6]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10/h1*height,),
                  FlatButton(
                    height: 45/h1*height,
                    minWidth: 230/w1*width,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Color(0xff4472C4),
                    onPressed: () async {
                      if(isToday[theDay]){
                        userPoint+=dailyPoint[theDay];
                        isToday[theDay]=false;
                        await ref.doc(user_email).set({'stage':theDay+1,'latest':today,'point':userPoint});
                        refreshUserPoint = "點數:"+userPoint.toString();
                        setState(() {
                          isActive[theDay]=true;
                          Text(refreshUserPoint);
                        });
                      }
                    },
                    child: Text(
                      "領取每日獎勵".toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize:18.sp,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                  Text(warning),
                  SizedBox(height: 20/h1*height,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 26/w1*width),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "熱門商品",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize:18.sp,
                            color: Color(0xff203864),
                            letterSpacing: 3,
                          ),
                        ),
                        SizedBox(height: 10/h1*height,),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('reward').snapshots(),
                            builder: (context, snapshots) {
                              return Container(
                                child: ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: rewards.length,
                                  itemBuilder: (BuildContext context,int index){
                                    return Container(
                                      child: Card(
                                        elevation: 4,
                                        margin: EdgeInsets.symmetric(vertical: 9/h1*height),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        child: ListTile(
                                          title: Text(
                                              rewards[index],
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              letterSpacing: 2,
                                              color: Color(0xff203864),
                                              fontWeight: FontWeight.w400
                                            ),
                                          ),
                                          subtitle: Text("點數:"+prices[index]+"  "+"剩餘:"+storages[index]+'份'),
                                          trailing: IconButton(
                                              onPressed: (){
                                                if(int.parse(prices[index])>userPoint){
                                                  warning = '點數不足以兌換';
                                                  _showDialog(context,warning);
                                                }else if(int.parse(storages[index]) == 0){
                                                  warning = '已兌換';
                                                  _showDialog(context,warning);
                                                }else{
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context){
                                                        return AlertDialog(
                                                          title: Text("確定要兌換嗎?"),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text("否" , style: TextStyle(color: Colors.redAccent),),
                                                              onPressed: (){
                                                                Navigator.of(context).pop(context);
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text("是"),
                                                              onPressed: (){
                                                                rewardItem = rewards[index];
                                                                userPoint = userPoint - int.parse(prices[index]);  //update
                                                                storages[index] = (int.parse(storages[index]) - 1).toString();  //update
                                                                updateStorage = storages[index];
                                                                updatePrice = prices[index];
                                                                refreshUserPoint = "點數:"+userPoint.toString();
                                                                setState((){
                                                                  Text(refreshUserPoint);
                                                                });
                                                                updateReward();
                                                                updateUserPoint();
                                                                Navigator.of(context).pop(context);
                                                              },
                                                            ),

                                                          ],

                                                        );
                                                      }
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                Icons.local_mall,
                                                color: Color(0xff6966F6),
                                                size: 30/h1*height,
                                              )
                                          ),
                                        ),
                                      ),
                                    );
                                  },

                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          );
        }
      },
    );

  }

  void _showDialog(BuildContext context, String warning) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: screen_width*0.85,
                height: screen_width*0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:screen_width*0.15),
                      child: Image.asset(
                        "assets/20.png",
                        // width: width*0.85,
                      ),
                    ),
                    SizedBox(height: 8/h1*height,),
                    Text(
                      warning,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 15/h1*height,),
                    Container(
                      width: screen_width*0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff4472C4),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '確認',
                          style: TextStyle(fontSize: 14.sp,letterSpacing: 2),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
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

  Container statusWidget( String status, bool isActive, bool isToday)
  {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      //margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 12/w1*width),
      child: Column(
        children: [
          Container(
            height: 26/h1*height,
            width: 26/w1*width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isActive) ? Color(0xff4472C4) : Colors.white,
              border: Border.all(
                  color: (isActive) ? Colors.transparent : Color(0xff4472C4),
                  width: 3/w1*width
              ),
            ),
            child: (isActive) ?
            Icon(Icons.check,size: 21/h1*height,color: Colors.white,):
            Icon(Icons.brightness_1,size: 20/h1*height,color: (isToday) ?Color(0xff4472C4):Colors.transparent,),
          ),
          SizedBox(height: 10/h1*height,),
          Text(status,
              style: TextStyle(
                  fontSize: 9.sp,
                  color: (isActive) ? Color(0xff4472C4) : Colors.black
              )),
        ],
      ),
    );
  }
}
