import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/databaseManager.dart';
import 'package:object_detection/leadingScreens/ageScreen.dart';
import 'package:object_detection/leadingScreens/heightScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/components/already_have_an_account_acheck.dart';
import 'package:object_detection/login_register/components/rounded_button.dart';
import 'package:object_detection/login_register/components/rounded_input_field.dart';
import 'package:object_detection/login_register/components/rounded_password_field.dart';
import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:object_detection/login_register/screens/signup/components/background.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../../global.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String photo='https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/user_photo%2Fawesome!.png?alt=media&token=8f579d46-f139-43ea-a5f3-8ad8499c9b05';
  String email = '';
  String password = '';
  Timer timer;
  String warning='';
  TextEditingController controller1,controller2;
  final auth = FirebaseAuth.instance;
  // _BodyState({
  //   Key? key,
  // }) : super(key: key);
  String today ;
  var now = new DateTime.now();
  final ref = FirebaseFirestore.instance.collection('user_point');
  Future<void>updateUserPoint()async {
    ref.doc(user_email).set({
      'latest':today,
      'point':0,
      'stage':0,
    });  //rewrite
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    today=DateFormat('yyyy-MM-dd').format(now);

  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    Size size = MediaQuery.of(context).size;
    return backGround(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: w*0.11,
                  width: w*0.19,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4DB43),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '註冊',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF585970),
                      fontSize: 18,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: w*0.01,),
                Container(
                  height: w*0.11,
                  width: w*0.19,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '登入',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF585970),
                      fontSize: 18,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: w*0.03,),
              ],
            ),
            SizedBox(height: size.height * 0.08,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w*0.1),
              child: Image.asset(
                'assets/healthy_logo.png',
              ),
            ),
            SizedBox(height: size.height * 0.02,),
            RoundedInputField(
              color: Colors.white,
              controller: controller1,
              hintText: '請輸入信箱',
              onchanged: (value){
                setState(() {
                  email = value.trim();
                });
              },
            ),
            SizedBox(height: size.height * 0.02,),
            RoundedPasswordField(
              controller: controller2,
              onchanged:(value){
                setState(() {
                  password = value.trim();
                });
              } ,
            ),
            SizedBox(height: size.height * 0.03,),
            RoundedButton(
              text: "註冊", //without sign up successful message
              press: () async {
                bool right=true;
                try {
                  if(email == null){
                    right = false;
                    _showDialog(context, '帳號或密碼未輸入!');
                  }else{
                    right = true;
                  }
                  UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    warning = '密碼強度太弱了喔!';
                    _showDialog(context, warning);
                    right=false;
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                    warning = '此信箱已有人使用';
                    _showDialog(context, warning);
                    right=false;
                  }
                } catch (e) {
                  print(e);
                  _showDialog(context, e.toString());
                }
                if(right==true){
                  print(email);
                  user_email=email;
                  DatabaseManager().createUserData(name,weight.toString(),height,age.toString(),sexual,photo);
                  DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('switch');
                  await documentReference.set({
                    'switch':true,
                  });
                  DocumentReference documentReference1 = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('dailyNotification');
                  await documentReference1.set({
                    //'$_dateTime': input,
                    'hour' : "8",
                    'minute' : "30",
                  });
                  updateUserPoint();

                  Alert(context: context, title: "資料上傳中....", desc: "請稍等5秒鐘!",buttons: []).show();
                  timer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
                    Alert(context: context, title: "資料上傳中....", desc: "請稍等5秒鐘!",buttons: []).dismiss();
                    timer.cancel();
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ageScreen(), maintainState: false));
                  });

                }
              },
            ),
            SizedBox(height: size.height * 0.015,),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: w*0.06,right: w*0.02),
                      child: Image.asset(
                        'assets/healthy圖示.png',
                      ),
                    ),
                  ],
                ),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: (){
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context){
                          return LoginScreen();
                        }
                    )
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _showDialog(BuildContext context, String warning) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: screen_width*0.85,
                height: screen_width*0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:screen_width*0.15),
                      child: Image.asset(
                        "assets/20.png",
                        // width: width*0.85,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      warning,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: screen_width*0.3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff4472C4),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '確定',
                          style: TextStyle(fontSize: 20,letterSpacing: 2),
                        ),
                        onPressed: () async {
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

