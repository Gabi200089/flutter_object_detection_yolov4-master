import 'package:object_detection/body_shape/download.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/ingredient/dailymenu.dart';
import 'package:object_detection/ingredient/ingredient_detection.dart';
import 'package:object_detection/ingredient/todolist.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:object_detection/report/report.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'ingredient_courses_2.dart';
import 'ingredient_courses_3.dart';
import 'ingredient_courses_4.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:object_detection/global.dart';
import 'ingredient.dart';
import 'ingredient_courses.dart';
import 'ingredient_courses_1.dart';
import 'package:object_detection/api/firebase_apiu.dart';

import 'package:sizer/sizer.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ingredient_management());
}


class ingredient_management extends StatelessWidget {
  static final String title = '食材管理';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: ingredientManagement(),
  );
}

class ingredientManagement extends StatefulWidget {
  @override
  _ingredientManagementState createState() => _ingredientManagementState();
}

class _ingredientManagementState extends State<ingredientManagement> {
  int _currentIndex = 0;
  int currentTab = 0;
  String temp;
  bool refresh=false;

  List now_gredients=[];
  List <int>has_num=[];
  bool has=false;

  int _selectedIndex = 0;
  //DateTime today = DateTime.now();
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String today ;
  bool datagot=false;

  List todos = [];

  @override

  final auth = FirebaseAuth.instance;

  final  List<Widget> _widgetOptions = <Widget>[
    Ingredient_Courses(),
    Ingredient_Courses_1(),
    Ingredient_Courses_2(),
    Ingredient_Courses_3(),
    Ingredient_Courses_4(),
  ];

  final refrecord = FirebaseFirestore.instance.collection('ingredient');
  final refrecipe= FirebaseFirestore.instance.collection('recipes');
  //食譜函式
  fetchFileData() async {
    QuerySnapshot querySnapshot = await refrecipe.get();
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    foods = name_Data;
    final gredients_Data = querySnapshot.docs
        .map((doc) => temp = doc['gredients'])
        .toList();
    gredients = gredients_Data;
    final link_Data = querySnapshot.docs
        .map((doc) => temp = doc['link'])
        .toList();
    link=link_Data;
    final pic_Data = querySnapshot.docs
        .map((doc) => temp = doc['picture'])
        .toList();
    pic=pic_Data;

    setState(() {
      foods = foods; //回傳食譜名稱陣列
      gredients = gredients; //回傳食材名稱陣列
    });

    //確認食材名稱
    for(int i=0;i<gredients.length;i++)
    {
      has_num.add(0);
      now_gredients=gredients[i].split('、');
      for(int m=0;m<now_gredients.length;m++)
      {
        for(int j=0;j<ingredient_name.length;j++)
        {
          if((now_gredients[m].contains(ingredient_name[j])))
          {
            has=true;
          }
        }
        if(has==false)
        {
          has_num[i]+=1;
        }
        else
          has=false;
      }
      // now_gredients=null;
    }
    for(int j=0;j<30;j++){
      for(int i=0;i<has_num.length;i++) {
        if(has_num[i]==j)
        {
          order_foods.add(foods[i]);
          order_gredients.add(gredients[i]);
          order_link.add(link[i]);
          order_pic.add(pic[i]);
        }
      }
    }
    print(gredients[0]);

  }
  Future<String> getData() async {
    if(datagot==false)
    {
      var difference;
      sorted_exp=[];
      sorted_id=[];

      QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(user_email).get();//只顯示該用戶的食材記錄
      final id_Data = querySnapshot.docs
          .map((doc) => temp = doc.id)
          .toList();
      ingredient_id=id_Data;
      final name_Data = querySnapshot.docs
          .map((doc) => temp = doc['name'])
          .toList();
      ingredient_name=name_Data;
      final time_Data = querySnapshot.docs
          .map((doc) => temp = doc['exp'])
          .toList();
      ingredient_time=time_Data;
      final exp_Data = querySnapshot.docs
          .map((doc) => temp = doc['exp'])
          .toList();
      today = formatter.format(now);
      for(var i = 0; i < exp_Data.length; i++){
        difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
        if(difference.inDays<0) exp_Data[i]=-1;
        else  exp_Data[i]=difference.inDays;
        print("第$i筆:${exp_Data[i]}");
        sorted_exp.add(exp_Data[i]);
      }
      setState(() {
        ingredient_exp= exp_Data;

        for(int i=-1;i<90;i++)
        {
          for(int j=0;j<ingredient_exp.length;j++)
          {
            if(ingredient_exp[j]==i)
            {
              sorted_id.add(j);
            }
          }
        }
      });

      final num_Data = querySnapshot.docs
          .map((doc) => temp = doc['num'])
          .toList();
      ingredient_num=num_Data;
      final image_Data = querySnapshot.docs
          .map((doc) => temp = doc['image'])
          .toList();
      ingredient_image=image_Data;
      final type_Data = querySnapshot.docs
          .map((doc) => temp = doc['class'])
          .toList();
      ingredient_class=type_Data;

      datagot=true;
    }
  }
  Future<void> getData_1() async {

    var difference;
    sorted_exp1=[];
    sorted_id1=[];
    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(user_email).where("class", isEqualTo: "1").get();//只顯示該用戶的食材記錄
    final id_Data = querySnapshot.docs
        .map((doc) => temp = doc.id)
        .toList();
    ingredient_id_1=id_Data;
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_1=name_Data;
    final time_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    ingredient_time_1=time_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      sorted_exp1.add(exp_Data[i]);
    }
    setState(() {
      ingredient_exp_1= exp_Data;

      for(int i=-1;i<90;i++)
      {
        for(int j=0;j<ingredient_exp_1.length;j++)
        {
          if(ingredient_exp_1[j]==i)
          {
            sorted_id1.add(j);
          }
        }
      }
    });

    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_1=num_Data;
    final image_Data = querySnapshot.docs
        .map((doc) => temp = doc['image'])
        .toList();
    ingredient_image_1=image_Data;
    final type_Data = querySnapshot.docs
        .map((doc) => temp = doc['class'])
        .toList();
    ingredient_class_1=type_Data;
  }
  Future<void> getData_2() async {


    var difference;
    sorted_exp2=[];
    sorted_id2=[];

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(user_email).where("class", isEqualTo: "2").get();//只顯示該用戶的食材記錄
    final id_Data = querySnapshot.docs
        .map((doc) => temp = doc.id)
        .toList();
    ingredient_id_2=id_Data;
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_2=name_Data;
    final time_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    ingredient_time_2=time_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      sorted_exp2.add(exp_Data[i]);
    }
    setState(() {
      ingredient_exp_2= exp_Data;

      for(int i=-1;i<90;i++)
      {
        for(int j=0;j<ingredient_exp_2.length;j++)
        {
          if(ingredient_exp_2[j]==i)
          {
            sorted_id2.add(j);
            print('sorted_id2:'+j.toString());
          }
        }
      }
    });
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_2=num_Data;
    final image_Data = querySnapshot.docs
        .map((doc) => temp = doc['image'])
        .toList();
    ingredient_image_2=image_Data;
    final type_Data = querySnapshot.docs
        .map((doc) => temp = doc['class'])
        .toList();
    ingredient_class_2=type_Data;
  }
  Future<void> getData_3() async {

    var difference;
    sorted_exp3=[];
    sorted_id3=[];

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(user_email).where("class", isEqualTo: "3").get();//只顯示該用戶的食材記錄
    final id_Data = querySnapshot.docs
        .map((doc) => temp = doc.id)
        .toList();
    ingredient_id_3=id_Data;
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_3=name_Data;
    final time_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    ingredient_time_3=time_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      sorted_exp3.add(exp_Data[i]);
    }
    setState(() {
      ingredient_exp_3= exp_Data;

      for(int i=-1;i<90;i++)
      {
        for(int j=0;j<ingredient_exp_3.length;j++)
        {
          if(ingredient_exp_3[j]==i)
          {
            sorted_id3.add(j);
            print('sorted_id3:'+j.toString());
          }
        }
      }
    });
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_3=num_Data;
    final image_Data = querySnapshot.docs
        .map((doc) => temp = doc['image'])
        .toList();
    ingredient_image_3=image_Data;
    final type_Data = querySnapshot.docs
        .map((doc) => temp = doc['class'])
        .toList();
    ingredient_class_3=type_Data;
  }
  Future<void> getData_4() async {

    var difference;
    sorted_exp4=[];
    sorted_id4=[];

    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(user_email).where("class", isEqualTo: "4").get();//只顯示該用戶的食材記錄
    final id_Data = querySnapshot.docs
        .map((doc) => temp = doc.id)
        .toList();
    ingredient_id_4=id_Data;
    final name_Data = querySnapshot.docs
        .map((doc) => temp = doc['name'])
        .toList();
    ingredient_name_4=name_Data;
    final time_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    ingredient_time_4=time_Data;
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0) exp_Data[i]=-1;
      else  exp_Data[i]=difference.inDays;
      sorted_exp4.add(exp_Data[i]);
    }
    setState(() {
      ingredient_exp_4= exp_Data;

      for(int i=-1;i<90;i++)
      {
        for(int j=0;j<ingredient_exp_4.length;j++)
        {
          if(ingredient_exp_4[j]==i)
          {
            sorted_id4.add(j);
          }
        }
      }
    });
    final num_Data = querySnapshot.docs
        .map((doc) => temp = doc['num'])
        .toList();
    ingredient_num_4=num_Data;
    final image_Data = querySnapshot.docs
        .map((doc) => temp = doc['image'])
        .toList();
    ingredient_image_4=image_Data;
    final type_Data = querySnapshot.docs
        .map((doc) => temp = doc['class'])
        .toList();
    ingredient_class_4=type_Data;
  }

  void initState() {
    super.initState();
    mainpage=true;
    // getData();
    fetchFileData();
    getData_1();
    getData_2();
    getData_3();
    getData_4();
  }

  void _onItemTapped(int index) { //onTap換index
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: getData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFF0EB2BE),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170/h1*height,),
                      Image.asset(
                        "assets/loading2.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xffffffff),
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
            body: Column(
              children:[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                      ),
                      child: Container(
                        color: Color(0xFFFDF1C1),
                        height: 200/h1*height,
                        width: MediaQuery.of(context).size.width,
                        child:
                        ListTile(
                          contentPadding: EdgeInsets.only(top: 35/h1*height,left: 30/w1*width),
                          title: Text("食材管理",
                            style: TextStyle(
                              letterSpacing: 9,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                              fontSize: 28.sp,
                              color: Colors.black,
                            ),),
                          subtitle: Text("Save food glorious, \nshame on wasted food.",
                            style: TextStyle(
                              letterSpacing: 5,
                              height: 1.8,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.black45,
                            ),),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10/h1*height,
                      right: 129/w1*width,
                      child: Container(
                        height: 47/h1*height,
                        width: 47/w1*width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFFCD581),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3.0,//影子圓周
                                  offset: Offset(3, 3)//影子位移
                              )
                            ]
                        ),
                        child:
                        Stack(
                          children: [
                            Positioned(
                              top: 6/h1*height,
                              left: 6/w1*width,
                              child:Icon(
                                Icons.receipt_long_outlined,
                                color: Colors.white,
                                size: 35.0/h1*height,
                              ),
                            ),
                            FlatButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DailyMenu()),);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10/h1*height,
                      right: 73/w1*width,
                      child: Container(
                        height: 47/h1*height,
                        width: 47/w1*width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFFCD581),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3.0,//影子圓周
                                  offset: Offset(3, 3)//影子位移
                              )
                            ]
                        ),
                        child:
                        IconButton(
                          padding: const EdgeInsets.all(5),
                          iconSize: 38/h1*height,
                          icon: Icon(Icons.shopping_bag_outlined),
                          color: Colors.white,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => todolist()),);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10/h1*height,
                      right: 18/w1*width,
                      child: Container(
                        height: 47/h1*height,
                        width: 47/w1*width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(5),
                            color: Color(0xFFFCD581),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3.0,//影子圓周
                                  offset: Offset(3, 3)//影子位移
                              )
                            ]
                        ),
                        child:
                        Stack(
                          children: [
                            Positioned(
                              top: 6/h1*height,
                              left: 6/w1*width,
                              child:Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 35.0/h1*height,
                              ),
                            ),
                            FlatButton(
                              onPressed: (){
                                _showPickOptionDialog(context);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Ingredient()),);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                CurvedNavigationBar(
                  //color: Colors.white,
                  backgroundColor: Color(0xFFFDF1C1),
                  height: 50/h1*height,
                  items: [
                    Container(
                      width:70/w1*width,
                      height:70/h1*height,
                      child: Image(image: AssetImage('assets/all.png'),),
                    ),
                    Container(
                      width:62/w1*width,
                      height:62/h1*height,
                      child: Image(image: AssetImage('assets/1.png'),),
                    ),
                    Container(
                      width:60/w1*width,
                      height:60/h1*height,
                      child: Image(image: AssetImage('assets/2.png'),),
                    ),
                    Container(
                      width:60/w1*width,
                      height:60/h1*height,
                      child: Image(image: AssetImage('assets/3.png'),),
                    ),
                    Container(
                      width:60/w1*width,
                      height:60/h1*height,
                      child: Image(image: AssetImage('assets/4.png'),),
                    ),
                    // Icon(Icons.list,size: 25,color:Colors.black),
                    // Icon(Icons.filter_1,size: 25,color:Colors.black),
                    // Icon(Icons.filter_2,size: 25,color:Colors.black),
                    // Icon(Icons.filter_3,size: 25,color:Colors.black),
                    // Icon(Icons.filter_4,size: 25,color:Colors.black)
                  ],
                  //animationCurve: Curves.fastOutSlowIn,
                  index: _selectedIndex, //一開始顯示的頁面
                  onTap: _onItemTapped,
                ),
                _widgetOptions.elementAt(_selectedIndex),
                // selectchanged(),
              ],),
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
                      child: Image.asset('assets/食材管理(改).png',)),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/飲食紀錄.png')),
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
          );
        }
      },
    );
  }
  void _showPickOptionDialog(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: width*0.6,
                height: height*0.47,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xff434352),
                ),
              ),
              Container(
                width: width*0.5,
                height: height*0.45,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70/h1*height,
                      width: 70/w1*width,
                      decoration: BoxDecoration(
                        color: Color(0xff434352),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 4/w1*width,
                            style: BorderStyle.solid
                        ),
                      ),
                      child: Icon(
                        Icons.fastfood_sharp,
                        size: 33/h1*height,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5/h1*height,),
                    Text(
                      '食材新增',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5/h1*height,),
                    Text(
                      '使用拍照或是裝置的照片辨識',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5/h1*height,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7e7f9a),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '拍照影像辨識',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  IngredientDetection(value: "camera")),);
                        },//按一下相簿選圖片
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7e7f9a),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '照片影像辨識',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  IngredientDetection(value: "file")),);
                        },//按一下相簿選圖片
                      ),
                    ),
                    Text(
                      '純手動輸入',
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7e7f9a),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '手動輸入',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Ingredient(),maintainState: false));//
                          // cameraFile(context);
                        },//按一下相簿選圖片
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

