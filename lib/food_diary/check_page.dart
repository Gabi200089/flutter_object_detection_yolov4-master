import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../global.dart' as globals;
import '../global.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import 'package:sizer/sizer.dart';

import 'food_record.dart';


class check_page extends StatefulWidget{

  String  pro,car,fat,cal,name,pack,total;
  check_page({this.name,this.pack,this.total,this.cal,this.pro,this.fat,this.car});

  @override
  _check_page createState() => _check_page(this.name,this.pack,this.total,this.cal,this.pro,this.fat,this.car);//_ScanResultState(this.value);
}

class _check_page extends State<check_page> {

  Timer timer;
  UploadTask task;
  String  pro,car,fat,cal,name,pack,total;
  _check_page(this.name,this.pack,this.total,this.cal,this.pro,this.fat,this.car);

  String who="user";

  final ref = FirebaseFirestore.instance.collection('barcode');
  final refFood = FirebaseFirestore.instance.collection('food');
  final refDiary = FirebaseFirestore.instance.collection('food-diary');


  int caln,pron,fatn;
  bool _PlussEnabled,_MinusEnabled;
  int num=1;
  String valueSub;
  String dropdownValue='早餐';

  DateTime _dateTime;
  TimeOfDay _time;
  var picked_date,picked_time,Time;
  String Pmin,Phour;//minutes hours的全域變數




  // Future<void> setData() async {
  //   await ref.doc(value).get().then((DocumentSnapshot doc) async{
  //     String _name = doc.data()['name'];
  //     String _cal = doc.data()['calorie'];
  //     String _pro = doc.data()['protein'];
  //     String _fat = doc.data()['fat'];
  //     String _car = doc.data()['carbohydrate'];
  //     String _pack = doc.data()['perpack'];
  //     String _total = doc.data()['packnum'];
  //
  //     await setState(() {
  //       name=_name;
  //       cal=_cal;
  //       pro=_pro;
  //       fat=_fat;
  //       car=_car;
  //       pack=_pack;
  //       total=_total;
  //     });
  //   });
  //   globals.food_url ="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/food_diary%2Fuser%2Fbarcode-food.png?alt=media&token=06a7adcc-441d-4c79-bd94-46a15bde97e7";
  // }

  // Future<void> setDataFood(valueSub) async {
  //   await refFood.doc(valueSub).get().then((DocumentSnapshot doc) async{
  //     String _name = doc.data()['name'];
  //     String _cal = doc.data()['calorie'];
  //     String _pro = doc.data()['protein'];
  //     String _fat = doc.data()['fat'];
  //     String _car = doc.data()['carbohydrate'];
  //     String _pack = doc.data()['perpack'];
  //     String _total = doc.data()['packnum'];
  //
  //     await setState(() {
  //       name=_name;
  //       cal=_cal;
  //       pro=_pro;
  //       fat=_fat;
  //       car=_car;
  //       pack=_pack;
  //       total=_total;
  //     });
  //   });
  // }

  Future<void> setDiary() async {
    //globals.food_url ="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/food_diary%2Fuser%2Fbarcode-food.png?alt=media&token=06a7adcc-441d-4c79-bd94-46a15bde97e7";
    print(globals.food_url);
    Alert(context: context, title: "資料上傳中....", desc: "請稍候😃",buttons: []).show();
    await refDiary.doc(user_email).collection(picked_date).doc(picked_time).set({
      'name':name,
      'calorie':((double.parse(cal)*num.toDouble()).toInt()).toString(),
      "protein":(double.parse(pro)*num.toDouble()).toString(),
      "fat":(double.parse(fat)*num.toDouble()).toString(),
      "carbohydrate":(double.parse(car)*num.toDouble()).toString(),
      "perpack":pack,
      "num":num,
      "image":globals.food_url,
      "time":Time,
      "total":total,
      "type":dropdownValue,
    }
    );
    await refDiary.doc(user_email).collection("time").doc(picked_date).set({
      "time":picked_date,
    });
    Alert(context: context, title: "資料上傳中....", desc: "請稍候😃",buttons: []).dismiss();
  }


  void _Check(){
    (num>=int.parse(total)) ? _PlussEnabled=false : _PlussEnabled=true;
    (num<=1) ? _MinusEnabled=false : _MinusEnabled=true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar

    // if(value.contains("food")) {
    //   valueSub = value.substring(4);
    //   setDataFood(valueSub);
    // }
    // else
    //   setData();

    (num<int.parse(total))? _PlussEnabled=true : _PlussEnabled=false ;
    (num==1)? _MinusEnabled=false : _MinusEnabled=true ;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white ,
      body: Stack(
        children: [
          Container(
            height: 50/h*height,
            width: 50/w*width,
            child: IconButton(
              padding: const EdgeInsets.all(4),
              iconSize: 40,
              icon: Icon(Icons.arrow_back_ios_outlined),
              color: Colors.black,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => food_record()),);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 70.0/h*height,left: 10/w*width,right: 10/w*width),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                    letterSpacing: 3,
                    color: Color(0xFF48406C),
                  ),),
                SizedBox(height: 15/h*height,),
                Text("每一份量含 "+pack.toString()+" 公克",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    letterSpacing: 5,
                    color: Color(0xFF48406C),
                  ),),
              ],
            ),
          ),
          Stack(
            children: <Widget>[
              Positioned(
                top: height*0.3,
                height: height*0.8,
                left: 0/w*width,
                right: 0/w*width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(35),
                  ),
                  child: Container(
                    color: Color(0xffb2cfdd),
                    padding:  EdgeInsets.only(top: 15/h*height, left: 18/w*width, right: 8/w*width, bottom: 10/h*height),
                    child: Column(
                      children:<Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("類別 : ",
                              style: TextStyle(
                                color:Color(0xFF48406C),
                                fontWeight: FontWeight.w700,
                                fontSize: 22.sp,
                              ) ,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(width: 5/w*width,),
                            Container(
                              padding: EdgeInsets.only(left: 10/w*width),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide( color: Color(0xFF48406C), width: 3/w*width),
                                ),
                              ),
                              child: DropdownButton(
                                value: dropdownValue,
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>['早餐', '午餐', '晚餐', '其他']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                      style: TextStyle(
                                        color:Color(0xFF48406C),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22.sp,
                                      ) ,
                                      textAlign: TextAlign.center,),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25/h*height,),
                        Row(
                          crossAxisAlignment:CrossAxisAlignment.center,
                          children: <Widget>[
                            _RadialProgress(
                              width: width * 0.29,
                              height: width * 0.3,
                              progress: double.parse(cal)/1000*num,
                              cal: double.parse(cal)*num,
                            ),
                            SizedBox(width: 14/w*width,),
                            Container(
                              padding: EdgeInsets.only(top:5/h*height,bottom: 8/h*height,left: 10/w*width,right: 10/w*width),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _IngredientProgress(
                                    ingredient: "蛋白質",
                                    progress: double.parse(pro)/15*num,
                                    progressColor: Colors.green,
                                    leftAmount: double.parse(pro)*num,
                                    width: width*0.4,
                                  ),
                                  SizedBox(height: 5/h*height,),
                                  _IngredientProgress(
                                    ingredient: "脂肪",
                                    progress: double.parse(fat)/30*num,
                                    progressColor: Colors.red,
                                    leftAmount: double.parse(fat)*num,
                                    width: width*0.4,
                                  ),
                                  SizedBox(height: 5/h*height,),
                                  _IngredientProgress(
                                    ingredient: "碳水化合物",
                                    progress: double.parse(car)/60*num,
                                    progressColor: Colors.yellow,
                                    leftAmount: double.parse(car)*num,
                                    width: width*0.4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:width*0.05,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed:(){
                                if(_MinusEnabled){
                                  setState(() {
                                    num-=1;
                                  });
                                  _Check();
                                }
                                else null ;
                              },
                              child: Icon(FontAwesomeIcons.minus,color: Color(0xff220055),
                                size: 30/h*height,),
                              shape: CircleBorder(),
                              elevation:5.0,
                              fillColor: Color(0xffFAF4F2),
                              padding: const EdgeInsets.all(10.0),
                            ),
                            Text(
                              '$num份',
                              style: TextStyle(fontSize: 38.sp,color:Color(0xFF48406C),fontWeight: FontWeight.w600,),
                            ),
                            RawMaterialButton(
                              onPressed:(){
                                if(_PlussEnabled){
                                  setState(() {
                                    num+=1;
                                  });
                                  _Check();
                                }
                                else null ;
                              },
                              //_PlussEnabled ? () =>plus : null ,
                              child: Icon(FontAwesomeIcons.plus,color: Color(0xFF092A44),
                                size: 30/h*height,),
                              shape: CircleBorder(),
                              elevation: 5.0,
                              fillColor: Color(0xffFAF4F2),
                              padding: const EdgeInsets.all(10.0),
                            ),
                          ],
                        ),
                        SizedBox(height: width*0.05,),
                        Text(picked_time == null ? '尚未選擇時間喔!' : picked_time.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),),
                        SizedBox(height: width*0.03,),
                        FlatButton(
                          child: Text(
                            "選擇時間".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19.sp,
                              color: Colors.white,
                              letterSpacing: 3,
                            ),
                          ),
                          height: 45/h*height,
                          minWidth: 250/w*width,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          color: Color(0xff7E7F9A),
                          onPressed: () {
                            showTimePicker(//選擇時間
                              context: context,
                              initialTime: _time == null ? TimeOfDay.now() : _time,
                            ).then((time) {
                              setState(() {
                                _time = time;
                                final hours = time.hour.toString().padLeft(2, '0');
                                final minutes = time.minute.toString().padLeft(2, '0');
                                Phour=hours;
                                Pmin=minutes;
                                picked_date=DateFormat('yyyy-MM-dd').format(_dateTime);
                                picked_time="${picked_date}-$hours:$minutes";
                                Time="${picked_date}-$hours:$minutes";
                              });
                            });
                            showDatePicker(//選擇日期
                                context: context,
                                initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                firstDate: DateTime(2001),
                                lastDate: DateTime.now()
                            ).then((date) {
                              setState(() {
                                _dateTime = date;
                              });
                            });
                          },
                        ),
                        SizedBox(height: width*0.02,),
                        FlatButton(
                          height: 45/h*height,
                          minWidth: 250/w*width,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          color: Color(0xFF3D82AE),
                          onPressed: () {
                            setDiary().then((_){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));
                            });


                          },
                          child: Text(
                            "完成".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 19.sp,
                              color: Colors.white,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class _RadialProgress extends StatelessWidget{

  final double height,width,progress,cal;

  const _RadialProgress({Key key, this.height, this.width, this.progress, this.cal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: progress>1 ? 1 : progress, //0.7    //跟上面有連接
      ),
      child: Container(
          height: height,
          width: width,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(text: cal.toStringAsFixed(1),style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF200087)
                    ),),
                    TextSpan(text: "\n"),
                    TextSpan(text: "kcal",style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF200087)
                    ),),
                  ]
              ),
            ),
          )
      ),
    );
  }

}

class _RadialPainter extends CustomPainter{

  final double progress;

  _RadialPainter({this.progress});

  void paint(Canvas canvas,Size size){

    Paint bcgpaint =Paint()
      ..strokeWidth=10
      ..color = Colors.white
      ..style=PaintingStyle.fill //中間變空心
      ..strokeCap = StrokeCap.round;

    Paint paint =Paint()
      ..strokeWidth=10
      ..color = Colors.grey[350]//Color(0xFF200087)
      ..style=PaintingStyle.stroke //中間變空心
      ..strokeCap = StrokeCap.round;

    Offset center =Offset(size.width/2,size.height/2);
    canvas.drawCircle(center, size.width/2, bcgpaint);
    canvas.drawCircle(center, size.width/2, paint);

    Paint progressPaint =Paint()
      ..strokeWidth=10
      ..color = Colors.blue
      ..shader = LinearGradient(
          colors: [Color(0xFF005C97),Color(0xff363795),])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style=PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;



    double relativeProgress=360*progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90), //改變方向從12點鐘方向往左走
      math.radians(-relativeProgress),  //改變百分比
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF48406C),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height:13/h*height,
                  width:width ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  height:13/h*height,
                  width: progress>1.0 ? width*1.0 : width*progress ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8/h*height,),
            Text(
              leftAmount.toStringAsFixed(1) + "g",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF48406C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}