import 'dart:async';
import 'dart:io';

import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'ingredient_courses.dart';
import 'ingredient_inside.dart';
import 'ingredient_inside_edit.dart';

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
  runApp(ingredient_inside_edit());
}

class ingredient_inside_edit extends StatelessWidget {
  static final String title = '食材管理';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: ingredient_inside_edit(),
  );
}

class ingredientInsideEdit extends StatefulWidget {
  int value;

  ingredientInsideEdit({this.value});
  @override
  _ingredientInsideEditState createState() => _ingredientInsideEditState(this.value);
}

class _ingredientInsideEditState extends State<ingredientInsideEdit> {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  bool _PlussEnabled=true;
  bool _MinusEnabled=true;
  int now_num;
  String today ;
  String temp;
  DateTime _dateTime;
  String _pickedTime;
  int value;
  String dropdownValue;
  List name=[];
  List exp=[];
  List num=[];
  List image=[];
  List time=[];
  List type=[];
  List sorted=[];
  List id=[];
  int index;
  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtNum = new TextEditingController();
  final TextEditingController _txtExp = new TextEditingController();
  final TextEditingController _txtClass = new TextEditingController();

  _ingredientInsideEditState(this.value);

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
    now_num=int.parse(num[sorted[index]]);
    _pickedTime=time[sorted[index]];
  }

  final refrecord = FirebaseFirestore.instance.collection('ingredient');

  Future<void> delete() async {
    refrecord.doc('userdata').collection(user_email).doc(id[sorted[index]]).delete() ;
  }
  //取得陣列
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
//檢查資料是否有變動
  void changed(){
    num[sorted[index]] =  now_num.toString();
    time[sorted[index]] = _pickedTime;
    type[sorted[index]] = dropdownValue;
    name[sorted[index]] = _txtName.text;
  }
  void back_check(){
    if(value==0){
      ingredient_num = num;
      ingredient_time = time;
      ingredient_class = type;
      ingredient_name = name;
    }
    else if(value==1) {
      ingredient_num_1 = num;
      ingredient_time_1 = time;
      ingredient_class_1 = type;
      ingredient_name_1 = name;
    }
    else if(value==2) {
      ingredient_num_2 = num;
      ingredient_time_2 = time;
      ingredient_class_2 = type;
      ingredient_name_2 = name;
    }
    else if(value==3) {
      ingredient_num_3 = num;
      ingredient_time_3 = time;
      ingredient_class_3 = type;
      ingredient_name_3 = name;
    }
    else if(value==4) {
      ingredient_num_4 = num;
      ingredient_time_4 = time;
      ingredient_class_4 = type;
      ingredient_name_4 = name;
    }
  }

  Future<void> update() async {
    refrecord.doc('userdata').collection(user_email).doc(id[sorted[index]]).update(
        {
          'name': _txtName.text,
          'num':now_num.toString(),
          "exp":_pickedTime,
          "class":dropdownValue,
          // "image":value,
        }
    ) ;
    print("okkkk");
    changed();
  }
  void _plusCheck(){
    (now_num<=1) ? _MinusEnabled=false : _MinusEnabled=true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
    dropdownValue=type[sorted[index]].toString();
    _txtName.text=name[sorted[index]];
    _txtExp.text=time[sorted[index]].toString();
  }
  @override
  Widget build(BuildContext context) {
    // check();
    (now_num==1)? _MinusEnabled=false : _MinusEnabled=true ;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body: Container(
        color: Color(0xFFFAEDCB),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40/h*height,
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        color: Colors.black,
                        onPressed: (){
                          back_check();
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ingredientInside(value:value)),);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(
                      left: 285.0/w*width,
                    )),
                    Container(
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40/h*height,
                        icon: Image.asset('assets/delete.png'),
                        color: Colors.black,
                        onPressed: (){
                          delete();
                          getData();
                          Ingredient_Courses();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
                        },
                      ),
                    ),
                ],),
                Padding(padding: EdgeInsets.only(
                  top: 10.0/h*height,
                )),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        '修改\n食材',
                        style: TextStyle(
                          color:Color(0xFF49416D),
                          fontWeight: FontWeight.w600,
                          fontSize: 39.sp,
                          letterSpacing: 3,
                        ) ,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.22,
                      width: MediaQuery.of(context).size.height*0.22,
                        // decoration: BoxDecoration(
                        //   border: Border.all(),
                        // ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                          image: NetworkImage(image[sorted[index]]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 460/h*height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 400/h*height,
                        width: 320/w*width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(45),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 3.0,//影子圓周
                                  offset: Offset(3, 3)//影子位移
                              )
                            ]
                        ),
                        child:Form(
                          // key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(padding: EdgeInsets.only(
                                  top: 40.0/h*height,
                                )),
                                Container(
                                  width: 260/w*width,
                                  child:  TextFormField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 35.0, color: Colors.black,fontWeight: FontWeight.w600,),
                                    controller: _txtName,
                                    validator: (val)=>val.isEmpty?"名稱不得空白":null,
                                    decoration: InputDecoration(
                                        contentPadding:  EdgeInsets.symmetric(horizontal: 40.0/w*width),
                                        fillColor: Colors.transparent,
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                        // hintText: name[index],
                                        // hintStyle: TextStyle(fontSize: 35.0, color: Colors.black,fontWeight: FontWeight.w600,),
                                        // labelText: "名稱",
                                        // labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                                        border:  UnderlineInputBorder(),
                                        filled: true),
                                    maxLength: 15,
                                  ),
                                ),
                                Container(
                                  width: 260/w*width,
                                  child:Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "類別",
                                            style: TextStyle(
                                              color:Color(0xFF49416D),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 19.sp,
                                            ) ,
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(padding: EdgeInsets.only(
                                            left: 20.0/w*width,
                                          )),
                                          DropdownButton(
                                            value: dropdownValue,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                dropdownValue = newValue;
                                              });
                                            },
                                            items: <String>['1', '2', '3', '4']
                                                .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Image(image: AssetImage('assets/$value.png')),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                      Divider(color:Color(0xFF49416D),thickness:2),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 260/w*width,
                                  child:
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "有效期限",
                                            style: TextStyle(
                                              color:Color(0xFF49416D),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 19.sp,
                                            ) ,
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(padding: EdgeInsets.only(
                                            left: 15.0,
                                          )),
                                          Container(
                                            width:43/w*width,
                                            height:43/h*height,
                                            child: Image(image: AssetImage('assets/calender.png'),),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _txtExp,
                                        readOnly: true,
                                        validator: (val)=>val.isEmpty?"有效日期不得空白":null,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 19.0.sp, color: Colors.black,fontWeight: FontWeight.w600,),
                                        decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                            // hintText: _pickedTime.toString(),
                                            // hintStyle: TextStyle(fontSize: 25.0, color: Colors.black,fontWeight: FontWeight.w600,),
                                            border:  UnderlineInputBorder(),
                                            filled: true),
                                        onTap: (){
                                          showDatePicker(//選擇日期
                                              context: context,
                                              initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2100)
                                          ).then((date) {
                                            setState(() {
                                              _dateTime = date;
                                              _pickedTime= DateFormat('yyyy-MM-dd').format(_dateTime);
                                              _txtExp.text=_pickedTime;
                                            });
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(
                                  top: 20.0/h*height,
                                )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Container(
                                      height: 40/h*height,
                                      width: 50/w*width,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFF49416D), width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.transparent,
                                      ),
                                      child: FlatButton(
                                        padding: const EdgeInsets.all(4),
                                        child: Text("–",
                                          style: TextStyle(
                                            color:Color(0xFF48406C),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22.sp,
                                          ) ,
                                          textAlign: TextAlign.center,
                                        ),
                                        // color: Color(0xFF49416D),
                                        onPressed:(){
                                          if(_MinusEnabled){
                                            setState(() {
                                              now_num-=1;
                                              print(now_num);
                                            });
                                            _plusCheck();
                                          }
                                          else null ;
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.2,
                                      alignment:Alignment.center,
                                      child:
                                      Text(now_num.toString()+"份",
                                        style: TextStyle(
                                          color:Color(0xFF48406C),
                                          fontWeight: FontWeight.w700,
                                          fontSize:26.sp,
                                        ) ,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      height: 40/h*height,
                                      width: 50/w*width,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFF49416D), width: 2),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.transparent,
                                      ),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(4),
                                        iconSize: 30/h*height,
                                        icon: Icon(Icons.add),
                                        color: Color(0xFF49416D),
                                        onPressed:(){
                                          if(_PlussEnabled){
                                            setState(() {
                                              now_num+=1;
                                              print(now_num);
                                            });
                                            _plusCheck();
                                          }
                                          else null ;
                                        },
                                      ),
                                    ),
                                  ], ),
                              ]),
                        ),
                      ),
                      Positioned(
                        top: 400/h*height,
                        child:Container(
                          height: 60/h*height,
                          width: 60/w*width,
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: 40/h*height,
                            icon: Image.asset('assets/ok.png'),
                            onPressed: (){
                              update().then((_) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ingredientInside(value:value)),);
                              });
                            },
                          ),
                        ),
                      ),
                    ],),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

