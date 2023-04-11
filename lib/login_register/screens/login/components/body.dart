import 'package:flutter/services.dart';
import 'package:object_detection/databaseManager.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/components/already_have_an_account_acheck.dart';
import 'package:object_detection/login_register/components/rounded_button.dart';
import 'package:object_detection/login_register/components/rounded_input_field.dart';
import 'package:object_detection/login_register/components/rounded_password_field.dart';
import 'package:object_detection/login_register/screens/home_screen.dart';
import 'package:object_detection/login_register/screens/login/components/background.dart';
import 'package:object_detection/login_register/screens/signup/signup.dart';
import 'package:object_detection/global.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email = '';
  String password = '';
  String warning = '';
  TextEditingController controller1,controller2;
  final auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();
  final LocalStorage localStorage = new LocalStorage('healthy');
  // _BodyState({
  //   Key? key,
  // }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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
                    color: Colors.transparent,
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
                    color: Color(0xFFF4DB43),
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
              onchanged: (value){
                setState(() {
                  password = value.trim();
                });
              },
            ),
            SizedBox(height: size.height * 0.03,),
            RoundedButton(
              text: '登入',
              press: () async {
                bool right=true;
                try {
                  if(email == null){// || controller1.text == null || controller2.text == null
                    right = false;
                    //_showDialog(context, '帳號或密碼未輸入!');
                  }else{
                    right = true;
                  }
                  UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  if(Platform.isAndroid){
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      warning = '沒有這位使用者喔!';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      warning = '帳號或密碼錯誤';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    } else if (e.code == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
                      print('連線逾時');
                      warning = '連線逾時';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    }else if (e.code == 'invalid-email') {
                      print('invalid-email');
                      warning = '帳號或密碼錯誤';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    }
                    // else if (e.code == 'NoSuchMethodError') {
                    //   print('NoSuchMethodError');
                    //   warning = '帳號或密碼未輸入!';
                    //   _showDialog(context, warning);
                    //   controller1.clear();
                    //   controller2.clear();
                    //   right=false;
                    // }
                    else{
                      warning = '登入錯誤';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    }
                  }else if(Platform.isIOS){
                    if (e.code == 'Error 17011') {
                      print('No user found for that email.');
                      warning = '沒有這位使用者喔!';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    } else if (e.code == 'Error 17009') {
                      print('Wrong password provided for that user.');
                      warning = '帳號或密碼錯誤';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    } else if (e.code == 'Error 17020') {
                      print('連線逾時');
                      warning = '連線逾時';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    }else if (e.code == 'invalid-email') {
                      print('invalid-email');
                      warning = '帳號或密碼錯誤';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    }
                    // else if (e.code == 'NoSuchMethodError') {
                    //   print('NoSuchMethodError');
                    //   warning = '帳號或密碼未輸入!';
                    //   _showDialog(context, warning);
                    //   controller1.clear();
                    //   controller2.clear();
                    //   right=false;
                    // }
                    else{
                      warning = '登入錯誤';
                      _showDialog(context, warning);
                      // controller1.clear();
                      // controller2.clear();
                      right=false;
                    }
                  }
                }catch (e) {
                  print("e:"+e);
                  _showDialog(context, e.toString());
                  // controller1.clear();
                  // controller2.clear();
                  right=false;
                }
                if(right==true){
                  localStorage.setItem("email", email);
                  localStorage.setItem("password", password);
                  await storage.write(key: "email", value: email);
                  user_email=email;
                  DatabaseManager().getData();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SettingScreen()));
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
                  login: true,
                  press: (){
                    Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context){
                          return signUpScreen();
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

