import 'package:object_detection/login_register/screens/signup/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/leadingScreens/heightScreen.dart';
import 'package:object_detection/leadingScreens/weightScreen.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

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
      home: ageScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class ageScreen extends StatefulWidget {
  @override
  _ageScreenState createState() => _ageScreenState();
}

class _ageScreenState extends State<ageScreen> {


int selected = 0;
bool check1=false,check2=false;
@override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10/h1*height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => signUpScreen()));
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (context) => heightScreen()));
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.grey[600],
                    size: 40/h1*height,
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height:13/h1*height,
                  width:width*0.45 ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  height:13/h1*height,
                  width: width*0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5/h1*height,),
            Text('step 1/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: height*0.05,),
            Center(
              child: Column(
                children: [
                  Text('請輸入姓名',
                    style: TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize:20.sp,
                      letterSpacing: 4,
                    ) ,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: width*0.03,bottom: width*0.06),
                    padding:EdgeInsets.symmetric(horizontal: 13/w1*width),
                    width: width*0.6,
                    height:65/h1*height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 8,
                          blurRadius:10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                          if(value == null){
                            check1=false;
                          }else{
                            check1 = true;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        //hintText: 'your name',
                        //border: InputBorder.none,
                      ),
                    ),
                  ),
                  Text('性別',
                    style: TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      letterSpacing: 4,
                    ) ,
                  ),
                  SizedBox(height: 10/h1*height,),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: width*0.15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width*0.3,
                            height: width*0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: sexual=='女'?Color(0xff9AD3ED):Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 8,
                                  blurRadius:10,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: FlatButton(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset('assets/female.png'),
                              onPressed: (){
                                setState(() {
                                  sexual = '女';
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 15/w1*width,),
                          Container(
                            width: width*0.3,
                            height: width*0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: sexual=='男'?Color(0xff9AD3ED):Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 8,
                                  blurRadius:10,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: FlatButton(
                              padding: const EdgeInsets.all(0),
                              child: Image.asset('assets/male.png'),
                              onPressed: (){
                                setState(() {
                                  sexual = '男';
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18/h1*height,),
                  Text('年齡',
                    style: TextStyle(
                      color:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      letterSpacing: 4,
                    ) ,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: width*0.03,bottom: width*0.09),
                    padding:EdgeInsets.symmetric(horizontal: 13/w1*width),
                    width: width*0.25,
                    height:65/h1*height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 8,
                          blurRadius:10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          age = int.parse(value);
                          if(value == null){
                            check2=false;
                          }else{
                            check2 = true;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        //hintText: 'age',
                        //border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width*0.6,
                    height: width*0.14,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 4,
                          primary: Color(0xff9ad3f1),
                          textStyle:
                              TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600,letterSpacing: 6),
                        ),
                        child: Text('下一步'),
                        onPressed: () {
                          if(check1 == true && check2 == true){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => heightScreen()));
                            check1 = false;
                            check2 = false;
                          }
                        }
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
}