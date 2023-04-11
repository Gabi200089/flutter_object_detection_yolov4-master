import 'dart:async';
import 'dart:io';

import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/ingredient/recipe_courses.dart';
import 'package:object_detection/ingredient/recipe_inside.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'ingredient_courses.dart';
import 'ingredient_inside_edit.dart';
import 'package:object_detection/global.dart';

import 'package:sizer/sizer.dart';


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
  runApp(ingredient_inside());
}

class ingredient_inside extends StatelessWidget {
  static final String title = '食材管理';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: ingredient_inside(),
  );
}

class ingredientInside extends StatefulWidget {
  int value;

  ingredientInside({this.value});
  @override
  _ingredientInsideState createState() => _ingredientInsideState(this.value);
}

class _ingredientInsideState extends State<ingredientInside> {

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String today ;
  String temp;
  int value;
  List name=[];
  List exp=[];
  List num=[];
  List image=[];
  List time=[];
  List type=[];
  List sorted=[];
  List id=[];
  int index;



  //食譜變數
  String word = '';

  int recipe_index = 0;
  bool has=false;
  final refrecipe= FirebaseFirestore.instance.collection('recipes');
  //食譜函式
  fetchFileData() async {
    //確認食材名稱
    for(int i=0;i<order_gredients.length;i++)
      {

        if(order_gredients[i].contains(name[sorted[index]]))
          {
            has_foods.add(order_foods[i]);
            has_gredients.add(order_gredients[i]);
            has_link.add(order_link[i]);
            has_pic.add(order_pic[i]);
            // print(foods[i]);
            // print(gredients[i]);
            // print(link[i]);
            // print(pic[i]);
          }
      }
  }
  //每次更新時自動重抓資料
  @override
  void initState() {
    // TODO: implement initState
    foods = [];
    gredients = [];
    has_foods = [];
    has_gredients = [];
    has_link = [];
    has_pic = [];
    check();
    fetchFileData();
    super.initState();
  }

  _ingredientInsideState(this.value);

  String time_short;

  void check(){
    if(value==0){
      name = ingredient_name;
      exp =  ingredient_exp;
      num =  ingredient_num;
      index =  ingredient_index;
      image = ingredient_image;
      time = ingredient_time;
      type = ingredient_class;
      id = ingredient_id;
      sorted=sorted_id;
    }
    else if(value==1) {
      name = ingredient_name_1;
      exp =  ingredient_exp_1;
      num =  ingredient_num_1;
      index =  ingredient1_index;
      image = ingredient_image_1;
      time = ingredient_time_1;
      type = ingredient_class_1;
      id = ingredient_id_1;
      sorted=sorted_id1;
    }
    else if(value==2) {
      name = ingredient_name_2;
      exp =  ingredient_exp_2;
      num =  ingredient_num_2;
      index =  ingredient2_index;
      image = ingredient_image_2;
      time = ingredient_time_2;
      type = ingredient_class_2;
      id = ingredient_id_2;
      sorted=sorted_id2;
    }
    else if(value==3) {
      name = ingredient_name_3;
      exp =  ingredient_exp_3;
      num =  ingredient_num_3;
      index =  ingredient3_index;
      image = ingredient_image_3;
      time = ingredient_time_3;
      type = ingredient_class_3;
      id = ingredient_id_3;
      sorted=sorted_id3;
    }
    else if(value==4) {
      name = ingredient_name_4;
      exp =  ingredient_exp_4;
      num =  ingredient_num_4;
      index =  ingredient4_index;
      image = ingredient_image_4;
      time = ingredient_time_4;
      type = ingredient_class_4;
      id = ingredient_id_4;
      sorted=sorted_id4;
    }
  }

  final refrecord = FirebaseFirestore.instance.collection('ingredient');

  // Future<void> delete() async {
  //   refrecord.doc('userdata').collection(user_email).doc(id[index]).delete() ;
  // }
  Future<void> getData() async {

    var difference;

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
      //print("第$i筆:${exp_Data[i]}");
    }
    ingredient_exp= exp_Data;
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
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body:
            Container(
              color: Color(0xFFFAEDCB),
              child:
              Column(
                children:[
                  Container(
                      height: height*0.4,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 2),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(55),
                          bottomLeft: Radius.circular(55),
                        ),
                        color: Color(0xFFBCD4E6),
                      ),
                      child:  Column(
                        children: [
                          Container(
                            alignment:Alignment.topLeft,
                            height: size.height * 0.09,
                            child:
                            Row(
                                children:[
                                  Container(
                                    child: IconButton(
                                      padding: const EdgeInsets.all(4),
                                      iconSize: 40/h*height,
                                      icon: Icon(Icons.arrow_back_ios_outlined),
                                      color: Colors.black,
                                      onPressed: (){
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ingredientManagement()),);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: width*0.4,
                                    child:
                                    Text(
                                      name[sorted[index]],
                                      // food_time[fd_index],
                                      style : TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(
                                    left: 130.0/w*width,
                                  )),
                                  Container(
                                    height: 45/h*height,
                                    width: 45/w*width,
                                    child: IconButton(
                                      padding: const EdgeInsets.all(4),
                                      iconSize: 40/h*height,
                                      icon: Image.asset('assets/edit.png'),
                                      color: Colors.black,
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ingredientInsideEdit(value:value)),);
                                      },
                                    ),
                                  ),
                                ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.only(
                                left: 20.0/w*width,
                              )),
                              Container(
                                width: size.width * 0.4,
                                height: size.height * 0.225,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image(
                                    image: NetworkImage(image[sorted[index]]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.5,
                                alignment:Alignment.center,
                                child:
                                    Column(children: [
                                      Text(time[sorted[index]].toString(),
                                        style: TextStyle(
                                          color:Color(0xFF48406C),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24.sp,
                                        ) ,
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(padding: EdgeInsets.only(
                                        top: 25.0/h*height,
                                      )),
                                      Row(children: [
                                        Padding(padding: EdgeInsets.only(
                                          left: 20.0/w*width,
                                        )),
                                        Container(
                                          height: 50/h*height,
                                          width: 50/w*width,
                                          child:
                                          Image(image: AssetImage('assets/${type[sorted[index]].toString()}.png')),
                                        ),
                                        Padding(padding: EdgeInsets.only(
                                          left: 23.0/w*width,
                                        )),
                                        Text(num[sorted[index]].toString()+"份",
                                          style: TextStyle(
                                            color:Color(0xFF48406C),
                                            fontWeight: FontWeight.w700,
                                            fontSize:24.sp,
                                          ) ,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],),
                                    ],),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(
                            top: 20.0/h*height,
                          )),
                        ],
                      )
                  ),
                  Padding(padding: EdgeInsets.only(
                    top: 10.0/h*height,
                  )),
                  Container(
                    alignment: Alignment.topLeft,
                    child:
                    Row(children: [
                      Padding(padding: EdgeInsets.only(
                        left: 30.0/w*width,
                      )),
                      Text("食譜推薦",
                        style: TextStyle(
                          color:Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ) ,
                        textAlign: TextAlign.start,
                      ),
                    ],),
                  ),
                  Padding(padding: EdgeInsets.only(
                    top: 10.0/h*height,
                  )),
                  Container(
                    height: height*0.50,
                    color: Color(0xFFFAEDCB),
                    child:has_foods!=null? recipe_courses(value: value,):Text(""),
                  ),
                ],
              ),
            ),
    );
  }
}

