import 'dart:async';
import 'dart:io';

import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_inside.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/ingredient/recipe_courses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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
  runApp(recipe_inside());
}

class recipe_inside extends StatelessWidget {
  static final String title = '食譜';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    //theme: ThemeData(primarySwatch: Colors.white),
    home: recipe_inside(),
  );
}

class recipeInside extends StatefulWidget {
  int value1;
  String name;
  String recipe_link;
  String pic_link;


  recipeInside({this.value1,this.name,this.recipe_link,this.pic_link});
  @override
  _recipeInsideState createState() => _recipeInsideState(this.value1,this.name,this.recipe_link,this.pic_link);
}

class _recipeInsideState extends State<recipeInside> {
  String user_ingredients;
  int value1;
  String name;
  String recipe_link;
  String nogredient="";
  String pic_link;
  int num=0;


  var now,today,tomorrow;

  _recipeInsideState(this.value1,this.name,this.recipe_link,this.pic_link);




  setDate() async {
    now = DateTime.now();
    today = DateFormat('yyyy-MM-dd').format(now);
    tomorrow = DateFormat('yyyy-MM-dd').format(now.add(new Duration(days: 1)));
    print('tomorrow:'+tomorrow.toString());
    //showDate = today.toString();
  }
  Future check()async{
    num=0;
    for(int i=0;i<look_gredients.length;i++)
    {
      if(look_gredients[i].contains('0'))
      {
        num=num+1;
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    // getData();
    super.initState();
    setDate();

  }
  @override
  Widget build(BuildContext context) {
    // print(look_gredients.length);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: height*0.32,
            child:
            Stack(
              children: [
                Container(
                  height: height*0.25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 2),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                    color: Color(0xFFFAEDCB),
                  ),
                  child:
                  Container(
                    alignment: Alignment.topLeft,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: 40/h*height,
                            icon: Icon(Icons.arrow_back_ios_outlined),
                            color: Colors.black,
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ingredientInside(value: value1,),maintainState: false));
                            },
                          ),

                        ),
                        Container(
                          width: width*0.8,
                          child:
                          Text(name,
                            softWrap: true,
                            style: TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ) ,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],),
                  ),
                ),
                Positioned(
                  top: 100/h*height,
                  left: 30/w*width,
                  child: Container(
                    height: 55/h*height,
                    width: 170/w*width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(18),
                        color: Color(0xFFFBD580),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 3.0,//影子圓周
                              offset: Offset(3, 3)//影子位移
                          )
                        ]
                    ),
                    child: FlatButton(
                      padding: const EdgeInsets.all(4),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Recipe!",
                            style: TextStyle(
                              color:Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 22.sp,
                            ) ,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // color: Color(0xFF49416D),
                      onPressed: (){
                        launch(recipe_link);
                      },
                    ),
                  ),),
                Positioned(
                  top: 80/h*height,
                  right: 20/w*width,
                  child: Container(
                    height: 150/h*height,
                    child: Image.asset("assets/yellow_person.png",fit: BoxFit.fill,),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              // height: height*0.7,
              width: width*1.0,
              // color: Color(0xFFFAEDCB),
              child: Column(
                children: [
                  Container(
                    height: height*0.6-25,
                    width: width*0.9,
                    child:ListView.builder(
                      itemCount: look_gredients.length,
                      itemBuilder: (context, index) {
                        // final file = files[index];
                        // makelist(file);
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  look_gredients[index].substring(1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize:16.sp,
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                  child:
                                  yesno[index].contains("1")
                                      ?Icon(Icons.circle,color: Colors.green,)
                                      :Icon(Icons.circle,color: Colors.red,)
                              ),
                              //   Padding(padding: EdgeInsets.only(
                              //     right: width*0.01,
                              //   )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 55/h*height,
                    width: 180/w*width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 0),
                        borderRadius: BorderRadius.circular(18),
                        color: Color(0xFFFBD580),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 3.0,//影子圓周
                              offset: Offset(3, 3)//影子位移
                          )
                        ]
                    ),
                    child: FlatButton(
                      padding: const EdgeInsets.all(4),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add,size: 40,color: Colors.white,),
                          Padding(padding: EdgeInsets.only(
                            right: 10/w*width,
                          )),
                          Text("加入菜單",
                            style: TextStyle(
                              color:Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ) ,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // color: Color(0xFF49416D),
                      onPressed:(){
                        print(look_gredients.length);
                        check().then((_){
                          if(num>0)
                            {
                              return  showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("食材缺少警告"),
                                      content: Text('你目前還缺少' +num.toString() +'樣材料喔!!\n確定要加入每日菜單嗎?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("否"),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return CustomDialog(today:today,tomorrow:tomorrow,name: name,recipe_link: recipe_link,pic_link: pic_link,);
                                                  });
                                            },
                                            child: const Text("確認",
                                                style: TextStyle(
                                                    color: Colors
                                                        .redAccent))),
                                      ],
                                    );
                                  });
                            }
                          else{
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return CustomDialog(today:today,tomorrow:tomorrow,name: name,recipe_link: recipe_link,pic_link: pic_link,);
                                });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
class CustomDialog extends StatefulWidget {
  var today,tomorrow,name,recipe_link,pic_link;
  CustomDialog({this.today,this.tomorrow,this.name,this.recipe_link,this.pic_link});

  @override
  _CustomDialogState createState() => _CustomDialogState(this.today,this.tomorrow,this.name,this.recipe_link,this.pic_link);
}

class _CustomDialogState extends State<CustomDialog> {
  String name;
  String recipe_link;
  String nogredient="";
  String pic_link;
  var today,tomorrow;
  _CustomDialogState(this.today,this.tomorrow,this.name,this.recipe_link,this.pic_link);
  String showDate = '',showDatetext = '';
  String selectedMeal = '早餐';
  List<String> meals = <String>[
    '早餐',
    '午餐',
    '晚餐',
    '其他',
  ];

  final ref = FirebaseFirestore.instance.collection('dailymenu');
  Future<void>dailymenu()async{
    for(int i=0;i<yesno.length;i++)
    {
      nogredient +="${look_gredients[i].substring(1)}"+"、";
    }
    print(nogredient);
    await ref.doc("UserEmail").collection(user_email).doc("date").collection(showDate).doc(name).set({
      "name":name,
      "link":recipe_link,
      "picture":pic_link,
      "nogredient":nogredient,
      "meal":selectedMeal,
      "date":showDate,
    });
  }
  changeDate() async{
    if(showDate == today.toString()){
      setState(() {
        showDate = tomorrow.toString();
        print('showdate:'+showDate);
        showDatetext="明天";
        build(this.context);
      });
    }else{
      setState(() {
        showDate = today.toString();
        print('showdate:'+showDate);
        showDatetext="今天";
        build(this.context);
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDate=today;
    showDatetext="今天";
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text('選擇要加入的每日菜單',style: TextStyle(fontWeight: FontWeight.w600),),
      content:  Container(
        width: width*0.85,
        height: width*0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: (){
                      setState(() {
                        changeDate();
                        //Text(today);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded)
                ),
                Text(showDatetext,style: TextStyle(fontSize: 18),),
                IconButton(
                    onPressed: (){
                      setState(() {
                        changeDate();
                        // Text(tomorrow);
                      });
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded)
                ),
              ],
            ),
            // SizedBox(height: height*0.01,),
            Container(
              //padding: EdgeInsets.only(right: 20,left: 20),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(7),
              //   border: Border.all(color: Colors.grey ,width: 2),

              // ),
              width: width*0.2,
              height: height*0.05,
              child: Center(
                child: DropdownButton<String>(
                  //hint: Text('選擇方案'),
                  value: selectedMeal,
                  onChanged: (String value){
                    setState(() {
                      selectedMeal = value;
                      print(value);
                      print(selectedMeal);
                    });
                    build(this.context);
                  },
                  items: meals.map((value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 20),),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
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
              dailymenu();
              Navigator.pop(context);
            },
            child: Text('確定',style: TextStyle(color:Colors.white,fontSize: 18))
        ),
      ],
    );
  }
}



