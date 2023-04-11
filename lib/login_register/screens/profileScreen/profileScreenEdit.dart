import 'dart:async';
import 'package:object_detection/leadingScreens/heightScreen.dart';
// import 'package:object_detection/leadingScreens/heightScreen2.dart';
import 'package:object_detection/login_register/screens/profileScreen/editPlans.dart';
import 'package:object_detection/login_register/screens/setting/components/body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/databaseManager.dart';
import 'package:object_detection/login_register/screens/home_screen.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:numberpicker/numberpicker.dart';
class ProfileScreenEdit extends StatefulWidget {
  @override
  _ProfileScreenEditState createState() => _ProfileScreenEditState();
}

class _ProfileScreenEditState extends State<ProfileScreenEdit> {
  int _currentWeight = 50;
  int _currentHeight = 150;
  int _currentAge = 20;
  List<String> list = ['男','女'];
  //List<IconData> iconlist = [Icons.male, Icons.female];
  int selectedIndex = 0;
  String input_sex = sexual;
  int checkM=0;//確定一開始選男
  int checkF=0;//確定一開始選女
  String uid = '';
  int height2;
  TextEditingController input_name = new TextEditingController();
  TextEditingController input_weight = new TextEditingController();
  TextEditingController input_height = new TextEditingController();
  TextEditingController input_age = new TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool datagot1=false,datagot2=false,datagot3=false,datagot4=false,datagot5=false,datagot6=false;
  bool show1 = false;
  bool show2 = false;
  bool show3 = false;
  var carb,fat,protein,changed_tdee,decided,selectedPlan,bmr,tdee,habit;

  String mail ='';
  // String mail = '';
  Timer timer;
  Future<String>getData_nutrients() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('nutrients');
    await documentReference.get().then((DocumentSnapshot doc) async{

      carb = doc['carb'];
      fat = doc['fat'];
      protein = doc['protein'];
      //print(name+height+weight+age+sexual);
    });
    datagot1=true;
  }
  Future<String>getData_userInfo() async {
      DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userInfo');
      await documentReference.get().then((DocumentSnapshot doc) async{

        name = doc['name'];
        height = doc['height'];
        weight = doc['weight'];
        age = doc['age'];
        sexual = doc['sexual'];
        print(height.toString());
      });
      datagot2=true;
  }
  Future<String>getData_userPlans() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userPlans');
    await documentReference.get().then((DocumentSnapshot doc) async{

      changed_tdee = doc['changed_tdee'];
      decided = doc['decided'];
      selectedPlan = doc['selectedPlan'];
      //print(name+height+weight+age+sexual);
    });
    datagot3=true;
  }
  Future<String>getData_userbmr() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userbmr');
    await documentReference.get().then((DocumentSnapshot doc) async{
      bmr = doc['bmr'];
      //print(name+height+weight+age+sexual);
    });
    datagot4=true;
  }
  Future<String>getData_usertdee() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('usertdee');
    await documentReference.get().then((DocumentSnapshot doc) async{
      tdee = doc['tdee'];
      //print(name+height+weight+age+sexual);
    });
    datagot5=true;
  }
  Future<String> gethabits() async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('habits');
    await documentReference.get().then((DocumentSnapshot doc) async{
      habit = doc['habit'];
    });
    datagot6=true;
  }
  void uploadInfos() async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userInfo');
    return documentReference.update({
      'name' : input_name.text,
      'age':_currentAge,
      'height':_currentHeight,
      'weight':_currentWeight,
      'sexual':sexual,
      'photo':photo,
    });
  }
  void change(){
    age =  _currentAge;
  }

  void initState(){
    //頁面重整

    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => build(this.context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    if(input_sex=="男")
    {
      checkM=0;
      checkF=1;
    }
    else{
      checkM=1;
      checkF=0;
    }
    void showWidget1(){
      setState(() {
        show1 = true;
        show2 = false;
        show3 = false;
      });
    }
    void hideWidget1(){
      setState(() {
        show1 = false;
      });
    }
    void showWidget2(){
      setState(() {
        show2 = true;
        show1 = false;
        show3 = false;
      });
    }
    void hideWidget2(){
      setState(() {
        show2 = false;
      });
    }
    void showWidget3(){
      setState(() {
        show3 = true;
        show1 = false;
        show2 = false;
      });
    }
    void hideWidget3(){
      setState(() {
        show3 = false;
      });
    }

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    return FutureBuilder<List<String>>(
      future: Future.wait([
        getData_nutrients(),
        getData_userPlans(),
        getData_userbmr(),
        getData_usertdee(),
        getData_userInfo(),
        gethabits(),
      ]),// function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot1 == false||datagot2 == false||datagot3 == false||datagot4 == false||datagot5 == false||datagot6 == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: _height,
                  width: _width,
                  color: Color(0xFF73BCD5),
                  child:
                  Column(
                    children: [
                      SizedBox(height:130,),
                      Image.asset(
                        "assets/loading9.gif",
                        width: _width,
                        // width: 125.0,
                      ),
                      SizedBox(height:80,),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
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
              body: Container(
                height: 1000,
                width: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      child: Column( //防呆之後做
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                SizedBox(width: 5,),
                                IconButton(
                                  padding: const EdgeInsets.all(4),
                                  iconSize: 40,
                                  icon: Icon(Icons.arrow_back_ios_outlined),
                                  color: Colors.black,
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen()),);
                                  },
                                ),
                                SizedBox(width: 12,),
                                Text('個人資料',style: TextStyle(fontSize: 32),),
                              ],
                            ),
                          ),
                          //SizedBox(height: 40,),
                          Row(
                            children: [
                              SizedBox(width: 150,),
                              Container(
                                height: 130,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/img2.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 300,
                            child: Row(
                              children: [
                                //SizedBox(width: 7,),
                                Text('姓名',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                SizedBox(width: 210,),
                                Container(
                                  width: 50,
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),
                                    controller: input_name,
                                    decoration:  InputDecoration(
                                      hintText: name,
                                      hintStyle: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                            //height: 20,
                            thickness: 3,
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 48,),
                              Text('性別',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                              SizedBox(width: 220,),
                              Text(sexual.toString(),style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Divider(
                            color: Colors.white,
                            //height: 20,
                            thickness: 3,
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: (){
                              if(show1 == false){
                                showWidget1();
                              }else{
                                hideWidget1();
                              }

                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 48,),
                                  Text('體重',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                  SizedBox(width: 205,),
                                  Text(weight.toString()+'kg',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 2,),
                          Divider(
                            color: Colors.white,
                            //height: 20,
                            thickness: 3,
                            indent: 30,
                            endIndent: 30,
                          ),
                          //SizedBox(height: 5,),
                          Visibility(
                              visible: show1,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Container(
                                color: Colors.white,
                                height: 100,
                                width: 400,
                                child: NumberPicker(
                                  value: _currentWeight,
                                  minValue: 30,
                                  maxValue: 150,
                                  step: 1,
                                  haptics: true,
                                  onChanged: (value) => setState(() {
                                    _currentWeight = value;
                                    weight =  _currentWeight;
                                    // Text(age.toString()+'y',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),);
                                  } ),
                                ),
                              )
                          ),
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: (){
                              if(show2 == false){
                                showWidget2();
                              }else{
                                hideWidget2();
                              }
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  SizedBox(width: 48,),
                                  Text('身高',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                  SizedBox(width: 195,),
                                  Text(height.toString()+'cm',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Divider(
                            color: Colors.white,
                            //height: 20,
                            thickness: 3,
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                              visible: show2,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Container(
                                color: Colors.white,
                                height: 100,
                                width: 400,
                                child: NumberPicker(
                                  value: _currentHeight,
                                  minValue: 130,
                                  maxValue: 200,
                                  step: 1,
                                  haptics: true,
                                  onChanged: (value) => setState(() {
                                    _currentHeight = value;
                                    height =  _currentHeight;
                                    // Text(age.toString()+'y',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),);
                                  } ),
                                ),
                              )
                          ),
                          SizedBox(height: 5,),
                          GestureDetector(
                            onTap: (){
                              if(show3 == false){
                                showWidget3();
                              }else{
                                hideWidget3();
                              }
                            },
                            child: Center(
                              child: Container(
                                child: Row(
                                  children: [
                                    SizedBox(width: 48,),
                                    Text('年齡',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                    SizedBox(width: 210,),
                                    Text(age.toString()+'y',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Divider(
                            color: Colors.white,
                            //height: 20,
                            thickness: 3,
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 5,),
                          Visibility(
                              visible: show3,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Container(
                                color: Colors.white,
                                height: 100,
                                width: 400,
                                child: NumberPicker(
                                  value: _currentAge,
                                  minValue: 12,
                                  maxValue: 80,
                                  step: 1,
                                  haptics: true,
                                  onChanged: (value) => setState(() {
                                    _currentAge = value;
                                    age =  _currentAge;
                                    // Text(age.toString()+'y',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),);
                                  } ),
                                ),
                              )
                          ),
                          //width: double.infinity,
                          Row(
                            children: [
                              SizedBox(width: 40,),
                              Text('運動習慣',style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                              SizedBox(width: 60,),
                              Text(habit,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: <Widget>[
                          //     Padding(
                          //       padding: const EdgeInsets.all(30.0),
                          //       child:customRadio(list[0], 0),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(30.0),
                          //       child:customRadio(list[1], 1),
                          //     ),
                          //   ],
                          // ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:Colors.blue,
                                shape: CircleBorder(), // <-- Radius
                              ),
                              child: Icon(Icons.check),

                              onPressed: (){
                                uploadInfos();
                              }
                          ),
                          //SizedBox(height: 20,),
                          Container(
                            width: 400,
                            height: 300,
                            child: Stack(
                              alignment:Alignment.center ,
                              children: [
                                Positioned(
                                  top:30,
                                  child: Container(
                                      margin: EdgeInsets.all(3),
                                      width: 300,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Color(0XFFE0E0E0) ,width: 2),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0XFFD6D6D6),
                                            blurRadius: 2.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(0.0, 5.0), // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child: Center(child: Text(decided,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),))
                                  ),
                                ),
                                Positioned(
                                  top:0,
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 3,
                                          shape: CircleBorder(),
                                          primary: Color(0xFF7E7F9A),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => editPlansScreen(),maintainState: false));
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(height: 8,),
                                            Text('變更',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),),
                                            Text('目標',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),),
                  ),
                ),
              )
          );
        }
      },
    );
  }

  void changeIndex(int index){
    setState((){
      selectedIndex = index;
    });
  }

  Widget customRadio(String txt, int index){
    return OutlineButton(
      onPressed: () => changeIndex(index),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      borderSide: BorderSide(color: selectedIndex == index ? Colors.blue : Colors.grey),
      child:
      Text(
        txt,style: TextStyle(
          color: selectedIndex == index ? Colors.blue : Colors.grey
      ),
      ),
    );
  }
}