import 'dart:async';
import 'dart:io';
import 'package:object_detection/api/firebase_apiu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:object_detection/food_diary/courses.dart';
import 'package:object_detection/food_diary/food_camera.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/food_diary/food_inside.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/food_diary/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:sizer/sizer.dart';

import 'food_record.dart';

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
  runApp(food_inside_edit());
}

class food_inside_edit extends StatelessWidget {
  static final String title = '飲食紀錄';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: food_inside_edit(),
  );
}

class foodInsideEdit extends StatefulWidget {

  @override
  _foodInsideEditState createState() => _foodInsideEditState();

}

class _foodInsideEditState extends State<foodInsideEdit> {

  Timer timer;

  String urlDownload="";
  UploadTask task;
  bool _PlussEnabled,_MinusEnabled;
  String total="100";
  String time_short;
  int now_num=int.parse(food_num[fd_index]);
  String fk=food_kcal[fd_index];
  String fp=food_pro[fd_index];
  String ff=food_fat[fd_index];
  String fc=food_car[fd_index];
  String fn=food_num[fd_index];
  String ft=food_type[fd_index];
  String fu=food_img[fd_index];

  File file;
  String dropdownValue=food_type[fd_index];
  DateTime _dateTime;
  TimeOfDay _time;
  var picked_date,picked_time,Time;
  String Pmin,Phour;//minutes hours的全域變數


  final refDiary = FirebaseFirestore.instance.collection('food-diary');

  Future<void> setDataFood() async {
    time_short=food_time[fd_index].toString().substring(0,time_short.length-6);


    await refDiary.doc(user_email).collection(time_short).doc(food_time[fd_index]).get().then((DocumentSnapshot doc) async{
      String _total = doc['packnum'];

      await setState(() {
        total=_total;
      });
    });
  }
  Future<void> update() async {
    time_short=food_time[fd_index].toString().substring(0,food_time[fd_index].toString().length-6);
    print(time_short);

    refDiary.doc(user_email).collection(time_short).doc(food_time[fd_index]).update(
      {
        'calorie':food_kcal[fd_index],
        "protein":food_pro[fd_index],
        "fat":food_fat[fd_index],
        "carbohydrate":food_car[fd_index],
        "num":now_num,
        "type":dropdownValue,
        "image":food_img[fd_index],
      }
    ) ;
    print("okkkk");
    changed();
  }

  void _Check(){
    (now_num>=int.parse(total)) ? _PlussEnabled=false : _PlussEnabled=true;
    (now_num<=1) ? _MinusEnabled=false : _MinusEnabled=true;

    food_kcal[fd_index]=(double.parse(food_kcal[fd_index])/double.parse(food_num[fd_index])*now_num).toStringAsFixed(0);
    food_pro[fd_index]=(double.parse(food_pro[fd_index])/double.parse(food_num[fd_index])*now_num).toString();
    food_fat[fd_index]=(double.parse(food_fat[fd_index])/double.parse(food_num[fd_index])*now_num).toString();
    food_car[fd_index]=(double.parse(food_car[fd_index])/double.parse(food_num[fd_index])*now_num).toString();
    food_num[fd_index]=now_num.toString();
    food_type[fd_index]=dropdownValue;
    print(food_num[fd_index]);
    print(food_kcal[fd_index]);
    print(food_pro[fd_index]);
    print(food_fat[fd_index]);
    print(food_car[fd_index]);
    build(this.context);
  }
  void changed(){

    fk=food_kcal[fd_index];
    fp=food_pro[fd_index];
    ff=food_fat[fd_index];
    fc=food_car[fd_index];
    fn=food_num[fd_index];
    ft=food_type[fd_index];
    fu=food_img[fd_index];
  }
  void back_check(){
    food_kcal[fd_index]=fk;
    food_pro[fd_index]=fp;
    food_fat[fd_index]=ff;
    food_car[fd_index]=fc;
    food_num[fd_index]=fn;
    food_type[fd_index]=ft;
    food_img[fd_index]=fu;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    // setDataFood();

    (now_num<int.parse(total))? _PlussEnabled=true : _PlussEnabled=false ;
    (now_num==1)? _MinusEnabled=false : _MinusEnabled=true ;

    return Scaffold(
      body: Container(
        color: Color(0x80BCD4E6),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              GestureDetector(
                onTap: (){
                  _showPickOptionDialog(context);
                },
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Container(
                    width: size.width * 1.0,
                    height: size.height * 0.38,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: const Radius.circular(40),
                      ),
                      child:file!=null
                      ?Image.file( file,fit: BoxFit.cover,)
                      :Image(
                        image: NetworkImage(food_img[fd_index]),
                        fit: BoxFit.cover,
                      ),
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
                  back_check();
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => foodInside(value: fd_index)),
                  // );
                },
              ),
              Positioned(
                top: 5/h*height,
                right: 15/w*width,
                child: IconButton(
                  padding: const EdgeInsets.all(4),
                  iconSize: 40/h*height,
                  icon: Image.asset('assets/ok.png'),
                  color: Colors.black,
                  onPressed: () {
                    update().then((_) {
                      food_type[fd_index]=dropdownValue;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => foodInside(value: fd_index)),
                      );
                    });
                  },
                ),
              ),
              Positioned(
                top: height*0.27,
                right: 0/w*width,
                child: Container(
                  width: size.width * 0.62,
                  height: size.width * 0.277,
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
                      left: const Radius.circular(30),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 0/h*height),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10/w*width),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide( color: Color(0xFF48406C), width: 2/w*width),
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
                                      fontSize: 20.sp,
                                    ) ,
                                    textAlign: TextAlign.center,),
                                );
                              }).toList(),
                            ),
                          ),

                          // Text(
                          //   food_type[fd_index],
                          //   style: TextStyle(
                          //     fontSize: 26,
                          //     color: Color(0xFF48406C),
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                picked_time == null ? food_time[fd_index] : picked_time.toString(),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Color(0xFF48406C),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.date_range_outlined,color: Color(
                                      0xFFFFFFFF),size: 28/h*height,),
                                  // onPressed: (){
                                  //   showTimePicker(//選擇時間
                                  //     context: context,
                                  //     initialTime: _time == null ? TimeOfDay.now() : _time,
                                  //   ).then((time) {
                                  //     setState(() {
                                  //       _time = time;
                                  //       final hours = time.hour.toString().padLeft(2, '0');
                                  //       final minutes = time.minute.toString().padLeft(2, '0');
                                  //       Phour=hours;
                                  //       Pmin=minutes;
                                  //       picked_date=DateFormat('yyyy-MM-dd').format(_dateTime);
                                  //       picked_time="${picked_date}-$hours:$minutes";
                                  //       Time="${picked_date}-$hours:$minutes";
                                  //     });
                                  //   });
                                  //   showDatePicker(//選擇日期
                                  //       context: context,
                                  //       initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                  //       firstDate: DateTime(2001),
                                  //       lastDate: DateTime.now()
                                  //   ).then((date) {
                                  //     setState(() {
                                  //       _dateTime = date;
                                  //     });
                                  //   });
                                  // }
                                  ),
                            ],
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
                    SizedBox(height: 10,),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          left: 25/w*width,
                          bottom: 60/h*height,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (_MinusEnabled) {
                                setState(() {
                                  now_num -= 1;
                                  print(now_num);
                                });
                                _Check();
                              } else
                                null;
                            },
                            child: Icon(
                              FontAwesomeIcons.minus,
                              color: Color(0xff220055),
                              size: 20/h*height,
                            ),
                            shape: CircleBorder(),
                            elevation: 5.0,
                            fillColor: Color(0xffFAF4F2),
                            padding: const EdgeInsets.all(0.0),
                          ),
                        ),
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
                          right: 25/w*width,
                          bottom: 60/h*height,
                          child: RawMaterialButton(
                            onPressed: () {
                              if (_PlussEnabled) {
                                setState(() {
                                  now_num += 1;
                                  print(now_num);
                                });
                                _Check();
                              } else
                                null;
                            },
                            //_PlussEnabled ? () =>plus : null ,
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: Color(0xFF092A44),
                              size: 20/h*height,
                            ),
                            shape: CircleBorder(),
                            elevation: 5.0,
                            fillColor: Color(0xffFAF4F2),
                            padding: const EdgeInsets.all(0.0),
                          ),
                        ),
                        Positioned(
                          right: 45/w*width,
                          child: Container(
                            padding: EdgeInsets.only(right: 5/w*width),
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "${now_num}份",
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
                                (15 * now_num),
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
                                (30 * now_num),
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
                                (60 * now_num),
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

  Future selectFile(BuildContext context) async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    uploadFile();
  }

  Future cameraFile(BuildContext context) async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.camera);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    uploadFile();
  }
  Future uploadFile() async {
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).show();
    if (file == null)
    {
      Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
      return;
    }
    var now = DateTime.now();
    final destination = 'food_diary/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);


    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    food_img[fd_index]=urlDownload;
    // globals.food_url=selected_url;
    print('Download-Link: $urlDownload');
    setState(() => food_img[fd_index]=urlDownload);
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
    // Navigator.pop(this.context);
  }

  void _showPickOptionDialog(BuildContext context) {
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 250,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xff434352),
                ),
              ),
              Container(
                width: 200,
                height: 250,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color(0xff434352),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 4,
                            style: BorderStyle.solid
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '紀錄圖片',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '選擇一張圖片或是拍張照',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5,),
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
                          '圖片',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          selectFile(context);
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
                          '拍照',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          cameraFile(context);
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
          left: 20.0/w*width,
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
                  width: progress>1.0 ? width*1.2 : width*progress ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8,),
            Text(leftAmount.toStringAsFixed(1)+" g",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF48406C),
              ),
            ),
          ],
        ),
      ],
    ),
    ],);
  }
}
