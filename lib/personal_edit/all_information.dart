import 'dart:convert';
import 'dart:io';
import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_picker/flutter_picker.dart';
import '../global.dart';
import 'jhPickerTool.dart';


class all_information extends StatefulWidget {
  @override
  _all_informationState createState() => _all_informationState();
}

class _all_informationState extends State<all_information> {

  //改照片用
  File file;
  UploadTask task;
  String urlDownload="";

  String sex,habit,name,object,w_object;
  int age=0;
  double kilo=0,centimeter=0;
  double bmr=0,tdee=0,protein=0,carb=0,fat=0,changed_tdee=0;

  final userref = FirebaseFirestore.instance.collection('flutter-user').doc(user_email);
  bool _loading = true;

  var habit_option =  ["沒有運動習慣","運動1-2天/週","運動3-5天/週","運動6-7天/週","每天運動2次"];
  var object_option= ["減重","減脂","增重","增肌","維持"];
  var loseweight=["最少減重:0.2公斤",'正常減重:0.5公斤','重度減重:0.8公斤','瘋狂減重:1公斤'];
  var losefat=['最少減脂: 10%','正常減脂: 15%','瘋狂減脂: 20%'];
  var gainweight=['最少增重:0.2公斤','正常增重:0.5公斤','重度增重:0.8公斤','瘋狂增重:1公斤'];
  var gainfat=['最少增肌: 5%','正常增肌: 10%','瘋狂增肌: 15%'];
  var maintain=['維持體重'];

  ////計算公式///
  Future<void> compute_bmr() async {
    if(sex=='男')
      bmr=10*kilo+6.25*centimeter-5*age+5;
    else
      bmr=10*kilo+6.25*centimeter-5*age-161;

    await userref.collection('infos').doc('userInfo').update(
        {
          'weight': double.parse(kilo.toStringAsFixed(1)),
          'height':double.parse(centimeter.toStringAsFixed(1)),
          "age":age,
        }) ;
    await userref.collection('infos').doc('userbmr').update(
        {
          'bmr': bmr,
        }) ;
  }
  Future<void> compute_nutrients() async {
    switch (habit) {
      case '沒有運動習慣':
        tdee = bmr * 1.2;
        protein=kilo*0.8;
        break;
      case '運動1-2天/週':
        tdee = bmr * 1.375;
        protein=kilo*1.2;
        break;
      case '運動3-5天/週':
        tdee = bmr * 1.55;
        protein=kilo*1.2;
        break;
      case '運動6-7天/週':
        tdee = bmr * 1.725;
        protein=kilo*1.2;
        break;
      case '每天運動2次':
        tdee = bmr * 1.9;
        protein=kilo*2;
        break;
    }
    fat=tdee*0.2/9;
    carb=(tdee-(protein*4+fat*9))/4;
    await userref.collection('infos').doc('habits').update({'habit': habit,});
    await userref.collection('infos').doc('nutrients').update({
      'carb': carb,
      'fat': fat,
      'protein': protein,
    });
    await userref.collection('infos').doc('usertdee').update({'tdee': tdee,});
  }
  Future<void> compute_changed_tdee() async {
    switch (w_object) {
      ////減重////
      case '最少減重:0.2公斤':
        changed_tdee=tdee-200;
        break;
      case '正常減重:0.5公斤':
        changed_tdee=tdee-500;
        break;
      case '重度減重:0.8公斤':
        changed_tdee=tdee-800;
        break;
      case '瘋狂減重:1公斤':
        changed_tdee=tdee-1000;
        break;
       ////增重////
      case '最少增重:0.2公斤':
        changed_tdee=tdee+200;
        break;
      case '正常增重:0.5公斤':
        changed_tdee=tdee+500;
        break;
      case '重度增重:0.8公斤':
        changed_tdee=tdee+800;
        break;
      case '瘋狂增重:1公斤':
        changed_tdee=tdee+1000;
        break;
        ////減脂////
      case '最少減脂: 10%':
        changed_tdee=tdee*0.9;
        break;
      case '最少減脂: 15%':
        changed_tdee=tdee*0.85;
        break;
      case '最少減脂: 20%':
        changed_tdee=tdee*0.8;
        break;
        ////增肌////
      case '最少增肌: 5%':
        changed_tdee=tdee*1.05;
        break;
      case '最少增肌: 10%':
        changed_tdee=tdee*1.1;
        break;
      case '最少增肌: 15%':
        changed_tdee=tdee*1.15;
        break;
       ////維持////
      case '維持體重':
        changed_tdee=tdee;
        break;
    }
    String selectedPlan='';
    switch(object){
      case '減重':
        selectedPlan='lose weight';
        break;
      case '減脂':
        selectedPlan='lose fat';
        break;
      case '增重':
        selectedPlan='gain weight';
        break;
      case '增肌':
        selectedPlan='gain mustle';
        break;
      case '維持':
        selectedPlan='maintain';
        break;
    }
    await userref.collection('infos').doc('userPlans').update({
      'changed_tdee': changed_tdee,
      'decided': w_object,
      'selectedPlan': selectedPlan,
    });
  }

  ////抓資料///
  setData() async {
    setState(() {
      _loading = true;
    });

    await userref.collection('infos').doc('habits').get().then((DocumentSnapshot doc) {
      habit=doc['habit'];
    });
    await userref.collection('infos').doc('nutrients').get().then((DocumentSnapshot doc) {
      carb=doc['carb'];
      fat=doc['fat'];
      protein=doc['protein'];
    });
    await userref.collection('infos').doc('userInfo').get().then((DocumentSnapshot doc) {
      age=doc['age'];
      centimeter=doc['height'].toDouble();
      name=doc['name'];
      sex=doc['sexual'];
      kilo=doc['weight'].toDouble();
    });
    await userref.collection('infos').doc('userPlans').get().then((DocumentSnapshot doc) {
      changed_tdee=doc['changed_tdee'];
      w_object=doc['decided'];
      switch(doc['selectedPlan']){
        case 'lose weight':
          object='減重';
          break;
        case 'lose fat':
          object='減脂';
          break;
        case 'gain weight':
          object='增重';
          break;
        case 'gain mustle':
          object='增肌';
          break;
        case 'maintain':
          object='維持';
          break;
      }
    });
    await userref.collection('infos').doc('userbmr').get().then((DocumentSnapshot doc) {
      bmr=doc['bmr'];
    });
    await userref.collection('infos').doc('usertdee').get().then((DocumentSnapshot doc) {
      tdee=doc['tdee'];
    });
    setState(() {
      _loading = false;
    });
  }

  void initState() {
    super.initState();
    setData();
  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading==true
          ? Center(
        child:
        Container(
            height: h,
            width: w,
            color: Color(0xFFF27779),
            child:
            Column(
              children: [
                SizedBox(height:170,),
                Image.asset(
                  "assets/loading12.gif",
                  width: w,
                  // width: 125.0,
                ),
                Text('Loading...',
                  style: TextStyle(
                    color:Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    letterSpacing: 4,
                  ) ,
                ),
              ],
            )
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: const Radius.circular(40),
              ),
              child: Container(
                color: Color(0xffD9DEF2),
                padding: EdgeInsets.only(bottom: w*0.05),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          // padding: const EdgeInsets.all(4),
                          iconSize: 40,
                          icon: Icon(Icons.arrow_back_ios_outlined),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SettingScreen()),
                            );
                          },
                        ),
                        SizedBox(
                          width: w*0.01,
                        ),
                        Text(
                          '個人資料',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize:MainAxisSize.min ,
                      children: [
                        Container(
                          height: w*0.26,
                          width: w*0.26,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(photo),
                              ),
                              Positioned(
                                right:-12,
                                bottom: 0,
                                child: SizedBox(
                                  height: 46,
                                  width: 46,
                                  child: TextButton(    //flatbutton
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          side: BorderSide(color: Colors.white),
                                        ),
                                        backgroundColor: Color(0xFFF5F6F9),
                                      ),
                                      onPressed: (){
                                        _showPickOptionDialog(context);
                                      },
                                      child: Icon(Icons.camera_enhance_rounded)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: w*0.06,),
                        GestureDetector(
                          onTap: (){
                            EditNameDialog(context, '編輯名稱', name);
                          },
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right,size: 30,color: Colors.grey[600],),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w*0.06),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '性別',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            sex,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        JhPickerTool.showStringPicker(context,
                            data: ["男","女"],
                            normalIndex: 2,
                            title: "請選擇性別",
                            clickCallBack: (int index,var str){
                              print(index);
                              print(str);
                              setState(() {
                                sex=str;
                                compute_bmr();
                                compute_nutrients();
                                compute_changed_tdee();
                              });
                            }
                        );
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '體重',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                           kilo.toStringAsFixed(1)+'公斤',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: (){
                        EditDialog(context,'編輯體重','公斤',kilo.toString());
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '身高',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            centimeter.toStringAsFixed(1)+'公分',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: (){
                        EditDialog(context,'編輯身高','公分',centimeter.toString());
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '年齡',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            age.toString()+'歲',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: (){
                        JhPickerTool.
                        showNumberPicker(context,
                            min:0,
                            max:100,
                            normalIndex: age,  //預設
                            title: "請選擇年齡",
                            clickCallBack: (var index,var str){
                              print(index);
                              //print(str);
                              setState(() {
                                age=index;
                                compute_bmr();
                                compute_nutrients();
                                compute_changed_tdee();
                              });
                            }
                        );
                      },
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '運動習慣',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            habit,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        JhPickerTool.showStringPicker(context,
                            data: habit_option,
                            normalIndex: 2,
                            title: "選擇運動習慣",
                            clickCallBack: (int index,var str){
                              print(index);
                              print(str);
                              setState(() {
                                habit=str;
                                compute_nutrients();
                                compute_changed_tdee();
                              });
                            }
                        );
                      },
                    ),
                  ],
                ).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: w*0.08,right: w*0.08),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '目標',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:26,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          String ob;
                          JhPickerTool.showStringPicker(context,
                              data: object_option,
                              normalIndex: 0,
                              title: "選擇目標方案",
                              next:"下一步",
                              clickCallBack: (int index,var str){
                                print(index);
                                print(str);
                                ob=str;
                                switch(str){
                                  case '減重':
                                    JhPickerTool.showStringPicker(context,
                                        data: loseweight,
                                        normalIndex: 0,
                                        title: "選擇每週目標",
                                        clickCallBack: (int index,var str){
                                          print(index);
                                          print(str);
                                          setState(() {
                                            object=ob;
                                            w_object=str;
                                          });
                                          compute_changed_tdee();
                                        }
                                    );
                                    break;
                                  case '減脂':
                                    JhPickerTool.showStringPicker(context,
                                        data: losefat,
                                        normalIndex: 0,
                                        title: "選擇每週目標",
                                        clickCallBack: (int index,var str){
                                          print(index);
                                          print(str);
                                          setState(() {
                                            object=ob;
                                            w_object=str;
                                          });
                                          compute_changed_tdee();
                                        }
                                    );
                                    break;
                                  case '增重':
                                    JhPickerTool.showStringPicker(context,
                                        data: gainweight,
                                        normalIndex: 0,
                                        title: "選擇每週目標",
                                        clickCallBack: (int index,var str){
                                          print(index);
                                          print(str);
                                          setState(() {
                                            object=ob;
                                            w_object=str;
                                          });
                                          compute_changed_tdee();
                                        }
                                    );
                                    break;
                                  case '增肌':
                                    JhPickerTool.showStringPicker(context,
                                        data: gainfat,
                                        normalIndex: 0,
                                        title: "選擇每週目標",
                                        clickCallBack: (int index,var str){
                                          print(index);
                                          print(str);
                                          setState(() {
                                            object=ob;
                                            w_object=str;
                                          });
                                          compute_changed_tdee();
                                        }
                                    );
                                    break;
                                  case '維持':
                                    JhPickerTool.showStringPicker(context,
                                        data: maintain,
                                        normalIndex: 0,
                                        title: "選擇每週目標",
                                        clickCallBack: (int index,var str){
                                          print(index);
                                          print(str);
                                          setState(() {
                                            object=ob;
                                            w_object=str;
                                          });
                                          compute_changed_tdee();
                                        }
                                    );
                                    break;
                                }
                              }
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          alignment: Alignment.bottomRight,
                          child: Text(
                              '更改',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: w*0.01),
                    padding: EdgeInsets.all(w*0.01),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400],width: 3)
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '目標方案',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                object,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '每週目標',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                w_object,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 2,
                                ),
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
            SizedBox(height: w*0.07,),
            Container(
              margin: EdgeInsets.only(left: w*0.08,right: w*0.08,bottom: w*0.1),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '每日建議攝取',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize:26,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        width: 35,
                        height: 35,
                        child: IconButton(
                          icon: Icon(Icons.info_outline_rounded),
                          color: Colors.deepPurpleAccent,
                          iconSize: 28,
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
                                        SizedBox(height: h*0.02,),
                                        Text('BMR的中文是「基礎代謝率」，指的是「人類靜臥一天所消耗的熱量」，而TDEE的中文則是「每日消耗熱量」 ， 也就是「每天總消耗的能量」的意思。'),
                                        SizedBox(height: h*0.02,),
                                        Text('如果是選擇減重或是減脂的話，請務必要記得一件事情!如果每日攝取的熱量小於BMR的話，長久下來會對身體造成嚴重的影響喔!'),
                                        SizedBox(height: h*0.02,),
                                        Text('選擇增肌及增重的同學也要記得熱量攝取不要攝取超過TDEE的10%喔😊'),
                                        SizedBox(height: h*0.03,),
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
                                            backgroundColor: Colors.cyan,
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
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: w*0.01),
                    padding: EdgeInsets.all(w*0.04),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400],width: 3)
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('BMR',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                            Text(bmr.toStringAsFixed(1)+'kcal',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TDEE',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                            Text(changed_tdee.toStringAsFixed(1)+'kcal',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('蛋白質',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                            Text(protein.toStringAsFixed(1)+'g',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('碳水化合物',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                            Text(carb.toStringAsFixed(1)+'g',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('脂肪',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                            Text(fat.toStringAsFixed(1)+'g',
                              style:TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                letterSpacing: 2,
                              ),),
                          ],
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
    );
  }

  ////////編輯照片用///////
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
                        Icons.person,
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '上傳頭貼',
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
    final destination = 'user_photo/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);


    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    // globals.food_url=selected_url;
    print('Download-Link: $urlDownload');
    setState(() => photo=urlDownload);

    uploadpic().then((value) {
      Navigator.pop(this.context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => all_information(),maintainState: false));
    } );
  }
  Future<String>uploadpic() async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userInfo');
    await documentReference.update({
      'photo' : photo,
    });

    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
  }
  ////////////////////////

  void EditDialog(BuildContext context, String title,String unit, String origin) {

    double _kilo,_centi;
    bool onchanged=false;

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: w*0.7,
                height: w*0.5,
                padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: w*0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF4C436A),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: w*0.01,bottom: w*0.02),
                      padding:EdgeInsets.only(right: w*0.01),
                      width: w*0.6,
                      height:65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                          border: Border.all(color: Color(0xFF4C436A),width: 2)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: w*0.4,
                            height:65,
                            padding:EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController()..text=origin,
                              textAlign: TextAlign.center,
                              onChanged: (value){
                                onchanged=true;
                                if(unit=='公分')
                                _centi = double.parse(value);
                                else
                                  _kilo= double.parse(value);
                              },
                              style: TextStyle(
                                  fontSize: 20
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                //hintText: 'your name',
                                //border: InputBorder.none,
                              ),
                            ),
                          ),
                          Text(unit,
                            style: TextStyle(
                              color:Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 4,
                            ) ,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: w*0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7E7F9B),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '確認',
                          style: TextStyle(fontSize: 20,letterSpacing: 2),
                        ),
                        onPressed: () async {
                          setState(() {
                            if(unit=='公分')
                              onchanged? centimeter=_centi:centimeter=double.parse(origin);
                            else
                              onchanged? kilo=_kilo:kilo=double.parse(origin);
                            //centimeter=double.parse(double.parse(TextEditingController().text).toStringAsFixed(1));
                          });
                          compute_bmr();
                          compute_nutrients();
                          compute_changed_tdee();
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
  void EditNameDialog(BuildContext context, String title, String origin) {

    String _name;
    bool onchanged=false;

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: w*0.7,
                height: w*0.52,
                padding: EdgeInsets.symmetric(horizontal: w*0.05,vertical: w*0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF4C436A),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: w*0.01,bottom: w*0.02),
                      padding:EdgeInsets.only(right: w*0.01),
                      width: w*0.6,
                      height:65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF4C436A),width: 2)
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: w*0.4,
                            height:65,
                            padding:EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              controller: TextEditingController()..text=origin,
                              textAlign: TextAlign.center,
                              onChanged: (value){
                                onchanged=true;
                                _name=value;
                              },
                              style: TextStyle(
                                  fontSize: 20
                              ),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                //hintText: 'your name',
                                //border: InputBorder.none,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      width: w*0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7E7F9B),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '確認',
                          style: TextStyle(fontSize: 20,letterSpacing: 2),
                        ),
                        onPressed: () async {
                          setState(() {
                              onchanged? name=_name:name=origin;
                            //centimeter=double.parse(double.parse(TextEditingController().text).toStringAsFixed(1));
                          });
                          await userref.collection('infos').doc('userInfo').update(
                              {
                                'name': name,
                              }) ;
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
}
