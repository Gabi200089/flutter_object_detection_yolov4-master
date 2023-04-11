import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/leadingScreens/plansForWeightScreen.dart';
import 'package:object_detection/login_register/screens/signup/signup.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

class showInfoScreen extends StatefulWidget {
  const showInfoScreen({ Key key }) : super(key: key);

  @override
  _showInfoScreenState createState() => _showInfoScreenState();
}

class _showInfoScreenState extends State<showInfoScreen> {
  void getbmr() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('userbmr');
    await documentReference.get().then((DocumentSnapshot doc) async{
      
      bmr = doc['bmr'];
      
    });
  }

   void gettdee() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('usertdee');
    await documentReference.get().then((DocumentSnapshot doc) async{
      tdee = doc['tdee'];
    });
  }

   void getuserPlans() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('userPlans');
    await documentReference.get().then((DocumentSnapshot doc) async{
      selectedPlan = doc['selectedPlan'];
      decided = doc['decided'];
      changed_tdee = doc['changed_tdee'];
    });
  }

  void getnutrients() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('nutrients');
    await documentReference.get().then((DocumentSnapshot doc) async{
      protein = doc['protein'];
      fat = doc['fat'];
      carb = doc['carb'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbmr();
    gettdee();
    getuserPlans();
  }

  @override

  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10/h1*screen_height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => plansForWeightScreen(),
                            maintainState: false));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.grey[600],
                    size: 40/h1*height,
                  ),
                ),
              ],
            ),
            Container(
              width: screen_width,
              height: screen_height*0.05,
              child:Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    child:Container(
                      height:13/h1*screen_height,
                      width:screen_width*0.45 ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height:13/h1*screen_height,
                      width: screen_width*0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color:Color(0xffBAE0F4),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -(screen_height*0.026),
                    right:screen_width*0.03,
                    child:Container(
                      height: screen_width*0.2,
                      width: screen_width*0.2,
                      child: IconButton(
                        icon: Icon(Icons.info_outline_rounded),
                        color: Color(0xff9AD3F1),
                        iconSize: screen_width*0.1,
                        onPressed: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('知識小補充'),
                                  content:  Column(
                                    children: [
                                      Text('BMR跟TDEE是什麼呢?',style: TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,),),
                                      SizedBox(height: screen_height*0.02,),
                                      Text('BMR的中文是「基礎代謝率」，指的是「人類靜臥一天所消耗的熱量」，而TDEE的中文則是「每日消耗熱量」 ， 也就是「每天總消耗的能量」的意思。'),
                                      SizedBox(height: screen_height*0.02,),
                                      Text('如果是選擇減重或是減脂的話，請務必要記得一件事情!如果每日攝取的熱量小於BMR的話，長久下來會對身體造成嚴重的影響喔!'),
                                      SizedBox(height: screen_height*0.02,),
                                      Text('選擇增肌及增重的同學也要記得熱量攝取不要攝取超過TDEE的10%喔😊'),
                                      SizedBox(height: screen_height*0.03,),
                                      Text('重點提醒:APP裡的TDEE已經都自動根據選擇的方案轉換成應攝取的TDEE摟!',style: TextStyle(color:Color(0xFFCD3B3B),)),
                                      Text('ex.選擇一周減重0.2公斤的話，TDEE會自動幫你減少200大卡，也就是應攝取的熱量總和。',style: TextStyle(color:Color(0xFFCD3B3B))),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          padding:  EdgeInsets.all(10),
                                          shape:
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                          backgroundColor: Color(0xff9AD3F1),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('我知道了!',style: TextStyle(color:Colors.white,))
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5/h1*screen_height,),
            Text('step 7/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: screen_height*0.01,),
            Text(
              decided,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: decided.length>7?16.sp:22.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                height: 1.5/h1*screen_height,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 15/h1*screen_height,),
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screen_width*0.25,
                    width: screen_width*0.27,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400])
                    ),
                    child: Text(
                      'BMR\n' + bmr.toStringAsFixed(1)+' kcal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        height: 1.5/h1*screen_height,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: screen_width*0.06,),
                  Container(
                    height: screen_width*0.25,
                    width: screen_width*0.27,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400])
                    ),
                    child: Text(
                      'TDEE\n' + changed_tdee.toStringAsFixed(1)+' kcal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        height: 1.5/h1*screen_height,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screen_width*0.02,),
              Container(
                height: screen_width*0.3,
                width: screen_width*0.6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400])
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '蛋白質',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            // letterSpacing: 1,
                          ),
                        ),
                        SizedBox(width: screen_width*0.05,),
                        Text(
                          protein.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            //letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'g',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            // letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '碳水化合物',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            //letterSpacing: 1,
                          ),
                        ),
                        SizedBox(width: screen_width*0.01,),
                        Text(
                          carb.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            //letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'g',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            //letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '脂肪',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            //letterSpacing: 1,
                          ),
                        ),
                        SizedBox(width: screen_width*0.1,),
                        Text(
                          fat.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'g',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5/h1*screen_height,
                            //letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(height: screen_width*0.06,),
            Text(
              '我會替你加油的!\n我們一起堅持下去吧!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
                height: 1.5/h1*screen_height,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: screen_width*0.02,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.22),
              child: Image.asset(
                "assets/Winner _Isometric.png",
                // width: width*0.85,
              ),
            ),
            SizedBox(
              width: screen_width*0.6,
              height: screen_width*0.14,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    primary: Color(0xff9AD3F1),
                    textStyle:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600,letterSpacing: 6),
                  ),
                  child: Text('完成'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }),
            ),
          ],
        ),
      ),
      
    );
  }
}