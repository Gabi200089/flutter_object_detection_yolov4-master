

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:object_detection/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DailyMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DailyMenu extends StatefulWidget {
  @override
  _DailyMenuState createState() => _DailyMenuState();
}

class _DailyMenuState extends State<DailyMenu> {
  int i = 1;
  bool datagot = false, datagot2 = false;
  List dailymenu = [];
  List dailylink = [];
  List dailypicture = [];
  List dailynogredient = [];
  List ingredients = [];
  List checkboxgredient = [];
  List dailymeal = [];
  List dailydate = [];
  List withTree = []; // 复选框选中状态
  bool read = false, read2 = false;
  bool has = false;
  String name = '',
      link = '',
      picture = '',
      nogredient = '',
      meal = '',
      time = "",
      date = "";

  final ref = FirebaseFirestore.instance.collection('dailymenu');

  Future<String> _getData() async {
    print(read.toString());
    if (read == false) {
      dailymenu.clear();
      dailylink.clear();
      dailymeal.clear();
      dailypicture.clear();
      dailynogredient.clear();
      ingredients.clear();
      checkboxgredient.clear();
      withTree.clear();

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('dailymenu')
          .doc('UserEmail')
          .collection(user_email)
          .doc("date").collection(time);
      await collectionReference.get().then((QuerySnapshot snapshot) async {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          name = doc['name'];
          dailymenu.add(name);
          link = doc['link'];
          dailylink.add(link);
          picture = doc['picture'];
          dailypicture.add(picture);
          nogredient = doc['nogredient'];
          dailynogredient.add(nogredient);
          meal = doc['meal'];
          dailymeal.add(meal);
          date = doc['date'];
          dailydate.add(date);
          print(i);
          i++;
          print(dailymenu);

          // print(storage);
          // print(price);
        });
      });
      i = 1;
      print('dailynogredient:');
      print(dailynogredient);
      setState(() {
        read = true;
        print('hi');
        datagot = true;
      });
      print("下" + read.toString());
    }
    // else
    //   return "0";
  }
  Future<String> _getData_1() async {
    print(read.toString());
      dailymenu.clear();
      dailylink.clear();
      dailypicture.clear();
      dailynogredient.clear();
      dailymeal.clear();
      ingredients.clear();
      checkboxgredient.clear();
      withTree.clear();

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('dailymenu')
          .doc('UserEmail')
          .collection(user_email)
          .doc("date").collection(time);
      await collectionReference.get().then((QuerySnapshot snapshot) async {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          setState(() {
            name = doc['name'];
            dailymenu.add(name);
            link = doc['link'];
            dailylink.add(link);
            picture = doc['picture'];
            dailypicture.add(picture);
            nogredient = doc['nogredient'];
            dailynogredient.add(nogredient);
            meal = doc['meal'];
            dailymeal.add(meal);
            date = doc['date'];
            dailydate.add(date);
            print(i);
            i++;
            print(dailymenu);
          });
        });
      });
      i = 1;
  }
  final refrecord = FirebaseFirestore.instance.collection('ingredient');

  Future<String> getData2() async {
    String temp;
    // int same=0;
    // int n=0;
    if (read2 == false) {
      print("getData2()");
      // read2=true;
      checkboxgredient.clear();
      for (int i = 0; i < dailynogredient.length; i++) {
        checkboxgredient.add("");
      }
      QuerySnapshot querySnapshot = await refrecord
          .doc('userdata')
          .collection(user_email)
          .get(); //只顯示該用戶的食材記錄
      final name_Data =
      querySnapshot.docs.map((doc) => temp = doc['name']).toList();
      ingredient_name = name_Data;

      for (int a = 0; a < dailynogredient.length; a++) {
        yesno = dailynogredient[a]
            .toString()
            .substring(0, dailynogredient[a].length - 1)
            .split("、");
        for (int i = 0; i < yesno.length; i++) {
          for (int j = 0; j < ingredient_name.length; j++) {
            if (yesno[i].contains(ingredient_name[j])) {
              // setState(() {
              // yesno.add("1");

              yesno[i] = "1" + yesno[i];
              j = ingredient_name.length;
              print("1" + yesno[i]);
              // });
            }
          }
        }
        print("check:" + checkboxgredient.length.toString());
        for (int k = 0; k < yesno.length; k++) {
          // checkboxgredient.add("");
          if (!yesno[k].contains("1") &&
              !checkboxgredient[a].contains( yesno[k].toString())) {
            setState(() {
              checkboxgredient[a] += yesno[k].toString() + "、";
              withTree.add(false);
            });
          }
        }
      }
      for (int a = 0; a < checkboxgredient.length; a++) {
        print("checkbox" + checkboxgredient[a] + "\n");
      }
      read2 = true;
      datagot2 = true;
      print("getData2()out");
    }
  }
  Future<String> getData2_1() async {
    String temp;
      checkboxgredient.clear();
      for (int i = 0; i < dailynogredient.length; i++) {
        checkboxgredient.add("");
      }

      QuerySnapshot querySnapshot = await refrecord
          .doc('userdata')
          .collection(user_email)
          .get(); //只顯示該用戶的食材記錄
      final name_Data =
      querySnapshot.docs.map((doc) => temp = doc['name']).toList();
      ingredient_name = name_Data;

      for (int a = 0; a < dailynogredient.length; a++) {
        yesno = dailynogredient[a]
            .toString()
            .substring(0, dailynogredient[a].length - 1)
            .split("、");
        print("dailynogredient:"+dailynogredient[a]);
        for (int i = 0; i < yesno.length; i++) {
          for (int j = 0; j < ingredient_name.length; j++) {
            if (yesno[i].contains(ingredient_name[j])) {
              // setState(() {
              // yesno.add("1");

              yesno[i] = "1" + yesno[i];
              j = ingredient_name.length;
              print("1" + yesno[i]);
              // });
            }
          }
        }
        print("check:" + checkboxgredient.length.toString());
        for (int k = 0; k < yesno.length; k++) {
          // checkboxgredient.add("");
          if (!yesno[k].contains("1") &&
              !checkboxgredient[a].contains(yesno[yesno.length - 1])) {
            checkboxgredient[a] += yesno[k].toString() + "、";
            withTree.add(false);
          }
        }
      }
      for (int a = 0; a < checkboxgredient.length; a++) {
        print("checkbox" + checkboxgredient[a] + "\n");
      }
      setState(() {
        checkboxgredient=checkboxgredient;
        withTree=withTree;
      });
  }
  void Today() {
    var now = DateTime.now();
    setState(() {
      time = DateFormat('yyyy-MM-dd').format(now).toString();
    });
  }

  void Tomorrow() {
    var now = DateTime.now();
    setState(() {
      time = DateFormat('yyyy-MM-dd').format(now.add(new Duration(days: 1)));
    });
  }

  deletedata(item) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('dailymenu')
        .doc('UserEmail')
        .collection(user_email)
        .doc("date")
        .collection(time)
        .doc(item);
    return documentReference.delete();
  }

  splitIngredient(item) {
    List result = [];
    List temp = [];
    ingredients.clear();
    for (int i = 0; i < checkboxgredient.length; i++) {
      result = checkboxgredient[i].split("、");
      print('result = ' + result.toString());
      for (int j = 0; j < result.length; j++) {
        if (result[j] != '') {
          temp.add(result[j]);
          ingredients = temp.toSet().toList();
          print('ingredients = ' + ingredients.toString());
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    var now = DateTime.now();
    time = DateFormat('yyyy-MM-dd').format(now).toString();
    splitIngredient(dailynogredient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    return FutureBuilder<List<String>>(
        future: Future.wait([
          _getData(),
          // _getData().then((value) => getData2()),
        ]), // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          // AsyncSnapshot<Your object type>
          if (datagot == false) {
            return Scaffold(
              body: Center(
                child: Container(
                    height: height,
                    width: width,
                    color: Color(0xFFEDC58A),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 170 / h * height,
                        ),
                        Image.asset(
                          "assets/loading4.gif",
                          width: width,
                          // width: 125.0,
                        ),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color: Color(0xff51381c),
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    )),
              ),
            );
          } else {
            getData2();
            return Scaffold(
              backgroundColor: Color(0xFFFAEDCB),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child:
                      Row(
                        children: [
                          IconButton(
                            // padding: const EdgeInsets.all(4),
                            iconSize: 40/h*height,
                            icon: Icon(Icons.arrow_back_ios_outlined),
                            color: Colors.black,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
                            },
                          ),
                          Text("每日菜單",
                            style : TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),),
                          Padding(padding: EdgeInsets.only(left: 150/w*width,)),
                          IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: 45/h*height,
                            icon: Image.asset('assets/foodpanda.png'),
                            color: Colors.black,
                            onPressed: (){
                              launch("https://www.foodpanda.com.tw/contents/pandamart-grocery-delivery-taiwan");
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: height * 0.17,
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 20 / w * width,
                                  )),
                              Container(
                                height: 65 / h * height,
                                width: 200 / w * width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.transparent,
                                        width: 0),
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xFFFBD580),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                          Colors.black.withOpacity(0.3),
                                          blurRadius: 3.0, //影子圓周
                                          offset: Offset(3, 3) //影子位移
                                      )
                                    ]),
                                child: FlatButton(
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          "assets/shopping_cart.png",
                                          height: 50 / h * height,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                            right: 10,
                                          )),
                                      Text(
                                        "加入清單",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  // color: Color(0xFF49416D),
                                  onPressed: () {
                                    datagot2 = false;
                                    splitIngredient(dailynogredient);
                                    print('split ingredients: ' +
                                        ingredients.toString());
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                            ingredients: ingredients,
                                            withTree: withTree);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                          height: 60 / h * height,
                          width: 60 / w * width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.transparent, width: 0),
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFFBD580),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 3.0, //影子圓周
                                    offset: Offset(3, 3) //影子位移
                                )
                              ]),
                          child: FlatButton(
                              onPressed: () {
                                Today();
                                _getData_1().then((_){
                                  getData2_1().then((_){
                                    splitIngredient(dailynogredient);
                                  });
                                });
                              },
                              child: Text(
                                "今天",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )),
                        ),
                        SizedBox(
                          width: width * 0.03,
                        ),
                        Container(
                            height: 60 / h * height,
                            width: 60 / w * width,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.transparent, width: 0),
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFBD580),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 3.0, //影子圓周
                                      offset: Offset(3, 3) //影子位移
                                  )
                                ]),
                            child: FlatButton(
                                onPressed: () {
                                  Tomorrow();
                                  _getData_1().then((_){
                                    getData2_1().then((_){
                                      splitIngredient(dailynogredient);
                                    });
                                  });
                                },
                                child: Text(
                                  "明天",
                                  style: TextStyle(
                                    color:Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ) ,
                                  textAlign: TextAlign.center,
                                ))),
                      ],
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                "早餐",
                                style: TextStyle(
                                    color: Color(0xff323000),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            child: ListView.builder(
                              physics:
                              NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dailymenu.length,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return dailymeal[index] == "早餐"
                                    ? Dismissible(
                                  key: Key(dailymenu[index]
                                      .toString()),
                                  background: Container(
                                    height: 100 / h * height,
                                    padding: EdgeInsets.only(
                                        right:
                                        20 / w * width),
                                    alignment:
                                    Alignment.centerRight,
                                    child: Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                  child: InkWell(
                                    onTap: () => {
                                      launch(dailylink[index])
                                    },
                                    child: Card(
                                      elevation: 10,
                                      margin:
                                      EdgeInsets.all(9),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)),
                                      child: ListTile(
                                        leading:
                                        ConstrainedBox(
                                          constraints:
                                          BoxConstraints(
                                            minWidth: 44 /
                                                w *
                                                width,
                                            minHeight: 44 /
                                                h *
                                                height,
                                            maxWidth: 80 /
                                                w *
                                                width,
                                            maxHeight: 80 /
                                                h *
                                                height,
                                          ),
                                          child: Image.network(
                                              dailypicture[
                                              index],
                                              fit: BoxFit
                                                  .cover),
                                        ),
                                        title: Text(
                                          dailymenu[index] ??
                                              'null',
                                          style: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 12.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                        subtitle:
                                        checkboxgredient[
                                        index] !=
                                            ""
                                            ? Text(
                                          "缺少食材：" +
                                              checkboxgredient[index],
                                          style: TextStyle(
                                              color: Colors
                                                  .red,
                                              fontSize: 12
                                                  .sp,
                                              fontWeight:
                                              FontWeight.w600),
                                        )
                                            : Text(""),
                                        // trailing: IconButton(
                                        //     onPressed: (){
                                        //       launch(dailylink[index]);
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.link_rounded,
                                        //       color: Colors.blue,
                                        //     )
                                        // ),
                                      ),
                                    ),
                                  ),
                                  onDismissed:
                                      (direction) async {
                                    deletedata(
                                        dailymenu[index]);
                                    setState(() async {
                                      await dailymenu
                                          .removeAt(index);
                                    });
                                  },
                                )
                                    : Container();
                              },
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                "午餐",
                                style: TextStyle(
                                    color: Color(0xff323000),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            child: ListView.builder(
                              physics:
                              NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dailymenu.length,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return dailymeal[index] == "午餐"
                                    ? Dismissible(
                                  key: Key(dailymenu[index]
                                      .toString()),
                                  background: Container(
                                    height: 100 / h * height,
                                    padding: EdgeInsets.only(
                                        right:
                                        20 / w * width),
                                    alignment:
                                    Alignment.centerRight,
                                    child: Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                  child: InkWell(
                                    onTap: () => {
                                      launch(dailylink[index])
                                    },
                                    child: Card(
                                      elevation: 10,
                                      margin:
                                      EdgeInsets.all(9),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)),
                                      child: ListTile(
                                        leading:
                                        ConstrainedBox(
                                          constraints:
                                          BoxConstraints(
                                            minWidth: 44 /
                                                w *
                                                width,
                                            minHeight: 44 /
                                                h *
                                                height,
                                            maxWidth: 80 /
                                                w *
                                                width,
                                            maxHeight: 80 /
                                                h *
                                                height,
                                          ),
                                          child: Image.network(
                                              dailypicture[
                                              index],
                                              fit: BoxFit
                                                  .cover),
                                        ),
                                        title: Text(
                                          dailymenu[index] ??
                                              'null',
                                          style: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 12.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                        subtitle:
                                        checkboxgredient[
                                        index] !=
                                            ""
                                            ? Text(
                                          "缺少食材：" +
                                              checkboxgredient[
                                              index],
                                          style: TextStyle(
                                              color: Colors
                                                  .red,
                                              fontSize: 12
                                                  .sp,
                                              fontWeight:
                                              FontWeight.w600),
                                        )
                                            : Text(""),
                                        // trailing: IconButton(
                                        //     onPressed: (){
                                        //       launch(dailylink[index]);
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.link_rounded,
                                        //       color: Colors.blue,
                                        //     )
                                        // ),
                                      ),
                                    ),
                                  ),
                                  onDismissed:
                                      (direction) async {
                                    deletedata(
                                        dailymenu[index]);
                                    setState(() async {
                                      await dailymenu
                                          .removeAt(index);
                                    });
                                  },
                                )
                                    : Container();
                              },
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                "晚餐",
                                style: TextStyle(
                                    color: Color(0xff323000),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            child: ListView.builder(
                              physics:
                              NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dailymenu.length,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return dailymeal[index] == "晚餐"
                                    ? Dismissible(
                                  key: Key(dailymenu[index]
                                      .toString()),
                                  background: Container(
                                    height: 100 / h * height,
                                    padding: EdgeInsets.only(
                                        right:
                                        20 / w * width),
                                    alignment:
                                    Alignment.centerRight,
                                    child: Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                  child: InkWell(
                                    onTap: () => {
                                      launch(dailylink[index])
                                    },
                                    child: Card(
                                      elevation: 10,
                                      margin:
                                      EdgeInsets.all(9),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)),
                                      child: ListTile(
                                        leading:
                                        ConstrainedBox(
                                          constraints:
                                          BoxConstraints(
                                            minWidth: 44 /
                                                w *
                                                width,
                                            minHeight: 44 /
                                                h *
                                                height,
                                            maxWidth: 80 /
                                                w *
                                                width,
                                            maxHeight: 80 /
                                                h *
                                                height,
                                          ),
                                          child: Image.network(
                                              dailypicture[
                                              index],
                                              fit: BoxFit
                                                  .cover),
                                        ),
                                        title: Text(
                                          dailymenu[index] ??
                                              'null',
                                          style: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 12.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                        subtitle:
                                        checkboxgredient[
                                        index] !=
                                            ""
                                            ? Text(
                                          "缺少食材：" +
                                              checkboxgredient[
                                              index],
                                          style: TextStyle(
                                              color: Colors
                                                  .red,
                                              fontSize: 12
                                                  .sp,
                                              fontWeight:
                                              FontWeight.w600),
                                        )
                                            : Text(""),
                                        // trailing: IconButton(
                                        //     onPressed: (){
                                        //       launch(dailylink[index]);
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.link_rounded,
                                        //       color: Colors.blue,
                                        //     )
                                        // ),
                                      ),
                                    ),
                                  ),
                                  onDismissed:
                                      (direction) async {
                                    deletedata(
                                        dailymenu[index]);
                                    setState(() async {
                                      await dailymenu
                                          .removeAt(index);
                                    });
                                  },
                                )
                                    : Container();
                              },
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Text(
                                "其他",
                                style: TextStyle(
                                    color: Color(0xff323000),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            child: ListView.builder(
                              physics:
                              NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: dailymenu.length,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return dailymeal[index] == "其他"
                                    ? Dismissible(
                                  key: Key(dailymenu[index]
                                      .toString()),
                                  background: Container(
                                    height: 100 / h * height,
                                    padding: EdgeInsets.only(
                                        right:
                                        20 / w * width),
                                    alignment:
                                    Alignment.centerRight,
                                    child: Icon(Icons.delete),
                                    color: Colors.red,
                                  ),
                                  child: InkWell(
                                    onTap: () => {
                                      launch(dailylink[index])
                                    },
                                    child: Card(
                                      elevation: 10,
                                      margin:
                                      EdgeInsets.all(9),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              10)),
                                      child: ListTile(
                                        leading:
                                        ConstrainedBox(
                                          constraints:
                                          BoxConstraints(
                                            minWidth: 44 /
                                                w *
                                                width,
                                            minHeight: 44 /
                                                h *
                                                height,
                                            maxWidth: 80 /
                                                w *
                                                width,
                                            maxHeight: 80 /
                                                h *
                                                height,
                                          ),
                                          child: Image.network(
                                              dailypicture[
                                              index],
                                              fit: BoxFit
                                                  .cover),
                                        ),
                                        title: Text(
                                          dailymenu[index] ??
                                              'null',
                                          style: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 12.sp,
                                              fontWeight:
                                              FontWeight
                                                  .w600),
                                        ),
                                        subtitle:
                                        checkboxgredient[
                                        index] !=
                                            ""
                                            ? Text(
                                          "缺少食材：" +
                                              checkboxgredient[
                                              index],
                                          style: TextStyle(
                                              color: Colors
                                                  .red,
                                              fontSize: 12
                                                  .sp,
                                              fontWeight:
                                              FontWeight.w600),
                                        )
                                            : Text(""),
                                        // trailing: IconButton(
                                        //     onPressed: (){
                                        //       launch(dailylink[index]);
                                        //     },
                                        //     icon: Icon(
                                        //       Icons.link_rounded,
                                        //       color: Colors.blue,
                                        //     )
                                        // ),
                                      ),
                                    ),
                                  ),
                                  onDismissed:
                                      (direction) async {
                                    deletedata(
                                        dailymenu[index]);
                                    setState(() async {
                                      await dailymenu
                                          .removeAt(index);
                                    });
                                  },
                                )
                                    : Container();
                              },
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
        });
  }

  Container statusWidget(String status, bool isActive, bool isToday) {
    return Container(
      //margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isActive) ? Colors.orange : Colors.white,
              border: Border.all(
                  color: (isActive) ? Colors.transparent : Colors.orange,
                  width: 3),
            ),
            child: (isActive)
                ? Icon(
              Icons.check,
              size: 21,
              color: Colors.white,
            )
                : Icon(
              Icons.brightness_1,
              size: 20,
              color: (isToday) ? Colors.orange : Colors.transparent,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(status,
              style: TextStyle(
                  fontSize: 12,
                  color: (isActive) ? Colors.orange : Colors.black)),
        ],
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  List ingredients, withTree;

  CustomDialog({this.ingredients, this.withTree});

  @override
  _CustomDialogState createState() =>
      _CustomDialogState(this.ingredients, this.withTree);
}

class _CustomDialogState extends State<CustomDialog> {
  List ingredients, withTree;

  _CustomDialogState(this.ingredients, this.withTree);

  List addtodo = [];

  createtodos() {
    for (int i = 0; i < addtodo.length; i++) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('TODOs')
          .doc(user_email)
          .collection('todolist')
          .doc(addtodo[i]);
      documentReference.set({
        //'$_dateTime': input,
        'title': addtodo[i],
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(withTree.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("勾選食材加入購物清單"),
      content: SingleChildScrollView(
        child: Container(
          height: 500,
          width: 500,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: withTree[index],
                  onChanged: (bool value) {
                    //复选框选中状态发生变化时重新构建UI
                    setState(() {
                      //更新复选框状态
                      withTree[index] = value;
                    });
                  },
                  title: Text(ingredients[index]),
                );
              }),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("取消"),
          onPressed: () => Navigator.of(context).pop(context),
        ),
        TextButton(
          child: Text("確定"),
          onPressed: () {
            //加入購物車
            for (int i = 0; i < ingredients.length; i++) {
              if (withTree[i] == true) {
                addtodo.add(ingredients[i]);
              }
            }
            print('addtodo:' + addtodo.toString());
            createtodos();
            Navigator.of(context).pop(context);
          },
        ),
      ],
    );
  }
}
