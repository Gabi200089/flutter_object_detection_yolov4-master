import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:object_detection/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'food_inside_edit.dart';
import 'food_record.dart';

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
  runApp(food_inside());
}

class food_inside extends StatelessWidget {
  static final String title = '飲食紀錄';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: food_inside(),
  );
}

class foodInside extends StatefulWidget {
  int value;
  foodInside({this.value});
  @override
  _foodInsideState createState() => _foodInsideState(this.value);
}

class _foodInsideState extends State<foodInside> {
  int value;
  _foodInsideState(this.value);

  String time_short;

  final refDiary = FirebaseFirestore.instance.collection('food-diary');

  Future<void> delete() async {
    time_short=food_time[fd_index].toString().substring(0,food_time[fd_index].toString().length-6);

    refDiary.doc(user_email).collection(time_short).doc(food_time[fd_index]).delete() ;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    fd_index=value;

    return Scaffold(
      body: Container(
        color: Color(0x80BCD4E6),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: FractionalOffset.topCenter,
                child: Container(
                  width: size.width * 1.0,
                  height: size.height * 0.38,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: const Radius.circular(40),
                    ),
                    child: Image(
                      image: NetworkImage(food_img[fd_index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(4),
                iconSize: 40/h*height,
                icon: Icon(Icons.arrow_back_ios_outlined),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => food_record()),
                  );
                },
              ),
              Positioned(
                right: 15/w*width,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 5/h*height),
                  child: Row(children: [
                    Container(
                      height: 50/h*height,
                      width: 50/w*width,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40/h*height,
                        icon: Image.asset('assets/delete.png'),
                        color: Colors.black,
                        onPressed: () {
                          delete();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => food_record()),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 50/h*height,
                      width: 50/w*width,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40/h*height,
                        icon: Image.asset('assets/edit.png'),
                        color: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => foodInsideEdit()),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ),
              Positioned(
                top: height*0.29,
                right: 0/w*width,
                child: Container(
                  width: size.width * 0.65,
                  height: size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: const Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:Offset(-4,3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: const Radius.circular(40),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 2/h*height),
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 8/h*height,),
                          Text(
                            food_type[fd_index],
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Color(0xFF48406C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5/h*height,),
                          Text(
                            food_time[fd_index],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xFF48406C),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                margin: EdgeInsets.only(top:300/h*height),
                padding: EdgeInsets.only(left: 10/w*width,bottom: 20/h*height),
                child: Column(
                  children: [
                    Text(
                      food_name[fd_index] ,
                      style: TextStyle(
                        color: Color(0xFF48406C),
                        fontWeight: FontWeight.w700,
                        fontSize: (food_name[fd_index].length<=11)?22.sp:18.sp,
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10/h*height,),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Center(
                          child: Container(
                            // margin: EdgeInsets.only(left: width*0.2),
                            width: size.width * 0.4,
                            alignment: Alignment.topCenter,
                            child: CircularPercentIndicator(
                              radius: 155.0,
                              lineWidth: 15.0/w*width,
                              percent: (double.parse(food_kcal[fd_index]) / dailyKcal),
                              progressColor: Color(0xFF48406C),
                              backgroundColor: Colors.white,
                              circularStrokeCap: CircularStrokeCap.butt,
                              animation: true,
                              center: Text(
                                    double.parse(food_kcal[fd_index]).toInt().toString() +
                                    "\n" +
                                    "kcal",
                                style: TextStyle(
                                  color: Color(0xFF48406C),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 45/w*width,
                          child: Container(
                            padding: EdgeInsets.only(right: 5/w*width),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                               food_num[fd_index] + "份",
                              style: TextStyle(
                                color: Color(0xFF48406C),
                                fontWeight: FontWeight.w700,
                                fontSize: 30.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 5/w*width,right: 15/w*width,top: 10/h*height),
                      padding: EdgeInsets.only(top:10/h*height,bottom: 10/h*height),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _IngredientProgress(
                            ingredient: "蛋白質",
                            progress: double.parse(food_pro[fd_index]) /
                                (15 * double.parse(food_num[fd_index])),
                            progressColor: Colors.green,
                            leftAmount: double.parse(food_pro[fd_index]),
                            width: width * 0.5,
                          ),
                          SizedBox(
                            height: 15/h*height,
                          ),
                          _IngredientProgress(
                            ingredient: "脂肪",
                            progress: double.parse(food_fat[fd_index]) /
                                (30 * double.parse(food_num[fd_index])),
                            progressColor: Colors.red,
                            leftAmount: double.parse(food_fat[fd_index]),
                            width: width * 0.5,
                          ),
                          SizedBox(
                            height: 15/h*height,
                          ),
                          _IngredientProgress(
                            ingredient: "碳水化合物",
                            progress: double.parse(food_car[fd_index]) /
                                (60 * double.parse(food_num[fd_index])),
                            progressColor: Colors.yellow,
                            leftAmount: double.parse(food_car[fd_index]),
                            width: width * 0.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IngredientProgress extends StatelessWidget {

  final String  ingredient;
  final double leftAmount;
  final double progress,width;
  final Color progressColor;

  const _IngredientProgress({Key key, this.ingredient, this.leftAmount, this.progress, this.progressColor, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Padding(padding: EdgeInsets.only(
          left: 20.0,
        )),
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(
        )),
        Text(
          ingredient,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF48406C),
            letterSpacing: 4,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height:13,
                  width:width*1.2 ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height:13,
                  width: progress>1.0 ? width*1.0 : width*progress ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10/w*width,),
            Text(leftAmount.toStringAsFixed(1)+" g",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF48406C),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    ),
    ],);
  }
}
