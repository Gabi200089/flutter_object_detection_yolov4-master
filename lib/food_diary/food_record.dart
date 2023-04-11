import 'dart:async';
import 'dart:io';
import 'package:object_detection/body_shape/download.dart';
import 'package:object_detection/food_diary/courses.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:object_detection/report/report.dart';
import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/food_diary/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';


//Future main() async {
// WidgetsFlutterBinding.ensureInitialized();
//await SystemChrome.setPreferredOrientations([
//  DeviceOrientation.portraitUp,
//  DeviceOrientation.portraitDown,
// ]);

// await Firebase.initializeApp();

// runApp(MyApp());
//}
List<CameraDescription> cameras;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(food_record());
}

class food_record extends StatelessWidget {
  static final String title = '飲食紀錄';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    // title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List time_all;
  int _currentIndex = 0;
  int currentTab = 1;
  Timer timer,timer2;
  DateTime _dateTime;
  File file;
  String temp,temp1;
  String Today;

  bool datagot = false;

  int kcal_total=0;
  double pro_total=0;
  double fat_total=0;
  double car_total=0;

  final refrecord = FirebaseFirestore.instance.collection('food-diary');
  final profilelist = FirebaseFirestore.instance.collection('flutter-user');
  final report = FirebaseFirestore.instance.collection('report_diary');
  final reftime = FirebaseFirestore.instance.collection('report_diary').doc(user_email);
  int index = 0;

  List values=[] ;

  Future<String>getData() async {

    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userPlans');
    await documentReference.get().then((DocumentSnapshot doc) async{
      tdee = doc['changed_tdee'];
      dailyKcal=tdee.round();
    });

    QuerySnapshot querySnapshot = await refrecord.doc(user_email).collection(Today).get();//只顯示當天的飲食記錄
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    food_name=name_Data;
    final time_Data = querySnapshot.docs
        .map((doc) => temp = doc['time'])
        .toList();
    food_time=time_Data;
    final img_Data = querySnapshot.docs
        .map((doc) => temp = doc['image'])
        .toList();
    food_img=img_Data;
    final kcal_Data = querySnapshot.docs
        .map((doc) => temp = doc['calorie'])
        .toList();
    food_kcal=kcal_Data;
    if(kcal_total!=null)
      kcal_total=0;
    for(var i = 0; i < kcal_Data.length; i++){kcal_total+=int.parse(kcal_Data[i]);}

    //protein
    final pro_Data = querySnapshot.docs
        .map((doc) => temp = doc['protein'])
        .toList();
    food_pro=pro_Data;
    if(pro_total!=null)
      pro_total=0;
    for(var i = 0; i < kcal_Data.length; i++){pro_total+=double.parse(pro_Data[i]);}

    //fat
    final fat_Data = querySnapshot.docs
        .map((doc) => temp = doc['fat'])
        .toList();
    food_fat=fat_Data;
    if(fat_total!=null)
      fat_total=0;
    for(var i = 0; i < fat_Data.length; i++){fat_total+=double.parse(fat_Data[i]);}

    //carbon
    final car_Data = querySnapshot.docs
        .map((doc) => temp = doc['carbohydrate'])
        .toList();
    food_car=car_Data;
    if(car_total!=null)
      car_total=0;
    for(var i = 0; i < fat_Data.length; i++){car_total+=double.parse(car_Data[i]);}

    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'].toString())
        .toList();
    food_num=num_Data;

    final type_Data = querySnapshot.docs
        .map((doc) => temp = doc['type'])
        .toList();
    food_type=type_Data;

    // int b=0,l=0,d=0,o=0;
    food_breakfast.clear();
    food_lunch.clear();
    food_dinner.clear();
    food_other.clear();

    for(var i=0;i<type_Data.length;i++){
      if(type_Data[i]=="早餐") food_breakfast.add(food_name[i]);
      else if(type_Data[i]=="午餐") food_lunch.add(food_name[i]);
      else if(type_Data[i]=="晚餐") food_dinner.add(food_name[i]);
      else if(type_Data[i]=="其他") food_other.add(food_name[i]);
    }
    if(datagot==false)
    {
      if((dailyKcal-kcal_total)<0)
        _showDialog(this.context, "超過"+(dailyKcal-kcal_total).toString().substring(1,)+"大卡!!!");
      else if((dailyKcal-kcal_total)<300)
        _showDialog(this.context, "還剩"+(dailyKcal-kcal_total).toString()+"大卡");
    }
    datagot = true;
    print((dailyKcal-kcal_total).toString());
    return Future.value("Data download successfully");
  }

//每日總營養上傳(報表用)
  Future<String> setreport() async {
    // _dateTime = DateTime.now();
    // var Today= DateFormat('yyyy-MM-dd').format(_dateTime);
    print("set:$Today");

    await report.doc(user_email).collection(Today).doc("food_diary").set({
      'calorie':kcal_total,
      "protein":double.parse(pro_total.toStringAsFixed(2)),
      "fat":double.parse(fat_total.toStringAsFixed(2)),
      "carbohydrate":double.parse(car_total.toStringAsFixed(2)),
    }
    );
  }

  void initState() {
    //頁面重整
    super.initState();
    _dateTime = DateTime.now();
    Today=DateFormat('yyyy-MM-dd').format(_dateTime);
    print("Today:$Today");
    datagot = false;
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: getData().then((_) => setreport()), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFFB5FFF5),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170/h1*height,),
                      Image.asset(
                        "assets/loading.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xFF4e416d),
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
                child:
                Container(
                  child:Column(
                    children:[
                      Positioned(
                        top: height*0.35,
                        height: height*0.8,
                        left: 0/w1*width,
                        right: 0/w1*width,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: const Radius.circular(40),
                          ),
                          child: Container(
                            color: Color(0xffBCD4E6),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: width*0.83,top: 10 /h1*height),
                                  height: 50/h1*height,
                                  width: 50/w1*width,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4e416d),
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
                                    padding: const EdgeInsets.all(4),
                                    iconSize: 40/h1*height,
                                    icon: Icon(Icons.add,color: Colors.white,),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Addrecord()),);
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => addRecord()),);
                                    },
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          showDatePicker(//選擇日期
                                            context: context,
                                            initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                            firstDate: DateTime(2001),
                                            lastDate: DateTime.now(),
                                            // selectableDayPredicate: (DateTime val) =>
                                            //   val.weekday==1 && val.month==7 && val.year==2021? false:true,
                                          ).then((date) {
                                            setState(() {
                                              _dateTime = date;
                                              _dateTime!=null?Today=DateFormat('yyyy-MM-dd').format(_dateTime):Today=Today;
                                              timer2 = Timer.periodic(Duration(seconds: 1), (Timer t) {
                                                build(this.context);
                                                if((dailyKcal-kcal_total)<0)
                                                  _showDialog(this.context, "超過"+(dailyKcal-kcal_total).toString().substring(1,)+"大卡!!!");
                                                else if((dailyKcal-kcal_total)<300)
                                                  _showDialog(this.context, "還剩"+(dailyKcal-kcal_total).toString()+"大卡");
                                                timer2.cancel();
                                              }
                                              );
                                            });
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right:180/w1*width),
                                          child:
                                          Text(Today.toString(),
                                            style: TextStyle(
                                              color:Color(0xFF4e416d),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                              letterSpacing: 4,
                                            ) ,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 113/h1*height,
                                            width: 150/w1*width,
                                            alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide( color: Color(0xFF4e416d), width: 5/w1*width,),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Eaten",
                                                  style: TextStyle(
                                                    color:Color(0xFF646178),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18.sp,
                                                    letterSpacing: 4,
                                                  ) ,
                                                ),
                                                SizedBox(height: 13/h1*height,),
                                                Text((kcal_total).toString()+" kcal",
                                                  style: TextStyle(
                                                    color:Color(0xFF4e416d),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.sp,
                                                    letterSpacing: 3,
                                                  ) ,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              child:
                                              (dailyKcal-kcal_total)<300
                                                  ?CircularPercentIndicator(
                                                  radius:150.0,
                                                  lineWidth: 10.5,
                                                  percent:(dailyKcal-kcal_total)/dailyKcal>0
                                                      ?(dailyKcal-kcal_total)/dailyKcal
                                                      :-(dailyKcal-kcal_total)/dailyKcal>1.0
                                                      ?1.0
                                                      :-(dailyKcal-kcal_total)/dailyKcal,
                                                  progressColor: (dailyKcal-kcal_total)>0?Color(
                                                      0xFFF84E4E):Color(0xFFEFBFB1),
                                                  backgroundColor: Colors.white,
                                                  circularStrokeCap: CircularStrokeCap.butt,
                                                  animation: true,
                                                  center:
                                                  (dailyKcal-kcal_total)>0
                                                      ?Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text((dailyKcal-kcal_total).toString(),
                                                        style: TextStyle(
                                                          color:(dailyKcal-kcal_total)>300?Color(0xFF4e416d):Colors.deepOrangeAccent,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 34.sp,
                                                          letterSpacing: 4,
                                                        ) ,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      Text("kcal left",
                                                        style: TextStyle(
                                                          color:Color(0xFF4e416d),
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 16.sp,
                                                        ) ,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                                      :Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text((dailyKcal-kcal_total).toString().substring(1,),
                                                        style: TextStyle(
                                                          color:Colors.red,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 34.sp,
                                                          letterSpacing: 4,
                                                        ) ,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      Text("kcal over",
                                                        style: TextStyle(
                                                          color:Colors.pinkAccent,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 16.sp,
                                                        ) ,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                              )
                                                  :CircularPercentIndicator(
                                                  radius:150.0,
                                                  lineWidth: 10.5,
                                                  percent:(dailyKcal-kcal_total)/dailyKcal,
                                                  progressColor: Color(0xFF4e416d),
                                                  backgroundColor: Colors.white,
                                                  circularStrokeCap: CircularStrokeCap.butt,
                                                  animation: true,
                                                  center:
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text((dailyKcal-kcal_total).toString(),
                                                        style: TextStyle(
                                                          color:Color(0xFF4e416d),
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 34.sp,
                                                          letterSpacing: 4,
                                                        ) ,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      Text("kcal left",
                                                        style: TextStyle(
                                                          color:Color(0xFF4e416d),
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 16.sp,
                                                        ) ,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                              )
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(padding: EdgeInsets.only(
                                            top: 110.0/h1*height,
                                          )),
                                          Column(
                                            children: [
                                              Container(
                                                  height: 40/h1*height,
                                                  width: 90/w1*width,
                                                  decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide( color: Color(0xFF455B99), width: 2/w1*width),
                                                    ),
                                                  ),
                                                  child: Text("蛋白質",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:Color(0xFF48406C),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.sp,
                                                      letterSpacing: 2,),
                                                    softWrap: true,
                                                  )
                                              ),
                                              SizedBox(height: 5/h1*height,),
                                              Text(pro_total.toStringAsFixed(2)+" g",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:Color(0xFF48406C),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp,),
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                          Padding(padding: EdgeInsets.only(
                                            right: 23.0/w1*width,
                                          )),
                                          Column(
                                            children: [
                                              Container(
                                                  height: 40/h1*height,
                                                  width: 135/w1*width,
                                                  decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide( color: Color(0xFF455B99), width: 2/w1*width),
                                                    ),
                                                  ),
                                                  child: Text("碳水化合物",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:Color(0xFF48406C),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.sp,
                                                      letterSpacing: 2,),
                                                    softWrap: true,
                                                  )
                                              ),
                                              SizedBox(height: 5/h1*height,),
                                              Text(car_total.toStringAsFixed(2)+" g",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:Color(0xFF48406C),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp,),
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                          Padding(padding: EdgeInsets.only(
                                            right: 23.0/w1*width,
                                          )),
                                          Column(
                                            children: [
                                              Container(
                                                  height: 40/h1*height,
                                                  width: 70/w1*width,
                                                  decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide( color: Color(0xFF455B99), width: 2/w1*width),
                                                    ),
                                                  ),
                                                  child: Text("脂肪",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color:Color(0xFF48406C),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18.sp,
                                                      letterSpacing: 2,),
                                                    softWrap: true,
                                                  )
                                              ),
                                              SizedBox(height: 5/h1*height,),
                                              Text(fat_total.toStringAsFixed(2)+" g",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color:Color(0xFF48406C),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp,),
                                                softWrap: true,
                                              )
                                            ],
                                          ),
                                        ],),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top:10/h1*height,bottom: 10/h1*height),
                        height:height*1.22,
                        child: Column(
                          children: [
                            Courses(),
                          ],
                        ),
                      )
                    ],),
                )
            ),

            bottomNavigationBar: CustomNavigationBar(
              iconSize: 40.0,
              selectedColor: Color(0xff040307),
              strokeColor: Color(0x30040307),
              unSelectedColor: Color(0xffacacac),
              backgroundColor: Colors.white,
              scaleFactor: 	0.5,
              items: [
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/食材管理.png',)),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      child: Image.asset('assets/飲食紀錄(改).png')),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/身形管理.png')),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/數據分析.png')),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/設定.png')),
                ),
              ],
              currentIndex: currentTab,
              onTap: (index) {
                switch(index){
                  case 0:
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
                    break;
                  case 1:
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));
                    break;
                  case 2:
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => download(),maintainState: false));
                    break;
                  case 3:
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),maintainState: false));
                    break;
                  case 4:
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false));
                    break;
                }

                // setState(() {
                //   _currentIndex = index;
                //   print(_currentIndex);
                // });
              },
            ),

            // BottomAppBar(
            //   shape: CircularNotchedRectangle(),
            //   notchMargin: 10,
            //   child: Container(
            //     height:60,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             MaterialButton(      //button1
            //               minWidth: 75/w1*width,
            //               onPressed: (){
            //                 Navigator.pop(context);
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
            //                 currentTab = 0;
            //               },
            //               child:  Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(
            //                     Icons.manage_search,   //dining_rounded
            //                     color: currentTab == 0 ? Colors.blue : Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             MaterialButton(      //button2
            //               minWidth: 75/w1*width,
            //               onPressed: (){
            //                 Navigator.pop(context);
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));//change
            //                 currentTab = 1;
            //               },
            //               child:  Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(
            //                     Icons.fastfood_rounded,  //emoji_food_beverage_rounded   //add_reaction_rounded,
            //                     color: currentTab == 1 ? Colors.blue : Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             MaterialButton(      //button3
            //               minWidth: 75/w1*width,
            //               onPressed: (){
            //                 Navigator.pop(context);
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => download(),maintainState: false));//ch//change
            //                 currentTab = 2;
            //               },
            //               child:  Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(
            //                     Icons.local_fire_department_outlined,   //dining_rounded
            //                     color: currentTab == 2 ? Colors.blue : Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             MaterialButton(      //button4
            //               minWidth: 75/w1*width,
            //               onPressed: (){
            //                 Navigator.pop(context);
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),maintainState: false)); //change
            //                 currentTab = 3;
            //               },
            //               child:  Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(
            //                     Icons.bar_chart_rounded,   //dining_rounded
            //                     color: currentTab == 3 ? Colors.blue : Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             MaterialButton(      //button5
            //               minWidth: 75/w1*width,
            //               onPressed: (){
            //                 Navigator.pop(context);
            //                 Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false));//
            //                 currentTab = 4;
            //               },
            //               child:  Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(
            //                     Icons.person,   //dining_rounded
            //                     color: currentTab == 4 ? Colors.blue : Colors.grey,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          );
        }
      },
    );

  }
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  Widget buildCustomPicker() => SizedBox(
    height: 300/height*height,
    child: CupertinoPicker(
      itemExtent: 64,
      diameterRatio: 0.7,
      looping: true,
      onSelectedItemChanged: (index) => setState(() => this.index = index),
      // selectionOverlay: Container(),
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: Colors.blue.withOpacity(0.12),
      ),
      children: Utils.modelBuilder<String>(
        values,
            (index, value) {
          final isSelected = this.index == index;
          final color = isSelected ? Colors.blue : Colors.black;

          return Center(
            child: Text(
              value,
              style: TextStyle(color: color, fontSize: 24),
            ),
          );
        },
      ),
    ),
  );

}

class Utils {
  static List<Widget> modelBuilder<M>(
      List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  /// Alternativaly: You can display an Android Styled Bottom Sheet instead of an iOS styled bottom Sheet
  // static void showSheet(
  //   BuildContext context, {
  //   required Widget child,
  // }) =>
  //     showModalBottomSheet(
  //       context: context,
  //       builder: (context) => child,
  //     );

  static void showSheet(
      BuildContext context, {
        Widget child,
        VoidCallback onClicked,
      }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: onClicked,
          ),
        ),
      );

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: TextStyle(fontSize: 24)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
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
                  SizedBox(height: 8,),
                  Text(
                    warning,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 15,),
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
                        '確定',
                        style: TextStyle(fontSize: 20,letterSpacing: 2),
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