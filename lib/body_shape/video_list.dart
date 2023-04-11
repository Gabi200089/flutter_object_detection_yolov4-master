import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/body_shape/download.dart';
import 'package:object_detection/body_shape/video1.dart';
import 'package:object_detection/body_shape/video2.dart';
import 'package:object_detection/body_shape/video3.dart';
import 'package:object_detection/body_shape/video5.dart';
import 'package:object_detection/body_shape/video6.dart';
import 'package:object_detection/body_shape/video7.dart';
import 'package:object_detection/global.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';

import 'video4.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(video_list());
}

class video_list extends StatelessWidget {
  static final String title = '運動影片';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    video_timer=null;
    video_time=0;
    reward=false;
    print(reward.toString());
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    final _height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffC9E4DE),
      body: Container(
        width: width,
        height: _height,
        child:
        SingleChildScrollView(
          child:
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    // padding: const EdgeInsets.all(4),
                    iconSize: 40,
                    icon: Icon(Icons.arrow_back_ios_outlined),
                    color: Colors.black,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => download()),);
                    },
                  ),
                  SizedBox(width: width*0.03,),
                  Center(
                    child: Text(
                      '運動影片',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              //1
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail1.jpg?alt=media&token=5bd0ba94-f8f8-4248-b093-84b79c3a3d82',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '10分鐘全身燃脂運動 TABATA 無跳躍 無噪音 | 10 MIN TABATA-full body fat burn',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video1(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
              //2
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail2.jpg?alt=media&token=9c55c50b-6832-4ae7-87f6-00701ce2f866',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '20分鐘HIIT全身燃脂運動\n｜全程站立、無工具【周六野Zoey】',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video2(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
              //3
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail3.jpg?alt=media&token=98045f00-213c-402c-be30-35c4473caa01',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '20分鐘低難度有氧運動 | 腰腿| 燃脂| 無工具高體脂大基數入門適合【周六野Zoey】',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video3(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
              //4
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail4.jpg?alt=media&token=0c2acd3e-465f-4f84-8880-5e57745fcda0',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '10分鐘無跳躍站立式TABATA🔥全身燃脂運動 無噪音',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video4(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
              //5
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail5.jpg?alt=media&token=84fa0d3e-9362-4d5e-bd20-c7155fa9c402',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '十分鐘運動 全身拉筋舒展',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video5(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
              //6
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail6.jpg?alt=media&token=ec599e77-4d42-4b80-bf0a-051da2ca839a',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '5分鐘快速收操運動 預防受傷 復原肌肉｜5 MIN COOL DOWN - quick recovery【Bellysu減肥中】',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video6(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
              //7
              GestureDetector(
                child: Container(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(30),
                        ),
                        child: Container(
                          width: width*0.9,
                          height: width*0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2Fthumbnail7.jpg?alt=media&token=308aba03-4b68-4847-b17e-d962511c328c',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: const Radius.circular(30),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width*0.09,vertical: width*0.02),
                          width: width*0.9,
                          height: width*0.3,
                          color: Colors.white,
                          child: Text(
                            '10分鐘站立式燃脂運動 早晨例行 無跳躍 【Bellysu減肥中】',
                            style: TextStyle(fontSize: 19,
                              letterSpacing: 2,
                              color: Color.fromRGBO(73, 65, 109, 1),),),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => video7(), maintainState: false));
                },
              ),
              SizedBox(height: width*0.05,),
            ],
          ),
        )
      )
    );
  }
}

