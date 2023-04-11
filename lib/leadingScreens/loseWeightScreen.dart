import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/databaseManager.dart';
import 'package:object_detection/leadingScreens/plansForWeightScreen.dart';
import 'package:object_detection/leadingScreens/showInfoScreen.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

class loseWeightScreen extends StatefulWidget {
  
  @override
  _loseWeightScreenState createState() => _loseWeightScreenState();
}

class _loseWeightScreenState extends State<loseWeightScreen> {
   
  int selected = 0;
  String warning = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Text(warning);
  }

  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10/h1*screen_height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => plansForWeightScreen(),
                            maintainState: false));
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
                  height:13/h1*screen_height,
                  width:screen_width*0.45 ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  height:13,
                  width: screen_width*0.36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Text('step 6/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: screen_height*0.03,),
            Text('設立一週目標',
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                letterSpacing: 4,
              ) ,
            ),
            SizedBox(height: screen_height*0.015,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.03),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: selected,
                          activeColor: Colors.blue,
                          onChanged: (int value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                      Text('最少減重:0.2公斤',style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 2,
                          groupValue: selected,
                          activeColor: Colors.blue,
                          onChanged: (int value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                      Text('正常減重:0.5公斤',style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 3,
                          groupValue: selected,
                          activeColor: Colors.blue,
                          onChanged: (int value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                      Text('重度減重:0.8公斤',style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 4,
                          groupValue: selected,
                          activeColor: Colors.blue,
                          onChanged: (int value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                      Text('瘋狂減重:1公斤',style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.22),
              child: Image.asset(
                "assets/Eating salad _Isometric.png",
                // width: width*0.85,
              ),
            ),
            SizedBox(
              width: screen_width*0.6,
              height: screen_width*0.14,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    primary: Color(0xff9AD3F1),
                    textStyle:
                    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600,letterSpacing: 6),
                  ),
                  child: Text('下一步'),
                  onPressed: () {
                    if (selected == 1 && tdee - 200 < bmr) {
                      warning = '你先不要減重了吧!';
                      _showDialog(context,warning);
                    } else if (selected == 2 && tdee - 500 < bmr) {
                      warning = '一開始先選少一點的選項啦!';
                      _showDialog(context,warning);
                    } else if (selected == 3 && tdee - 800 < bmr) {
                      warning = '你是想減重還是想餓死!';
                      _showDialog(context,warning);
                    } else if (selected == 4 && tdee - 1000 < bmr) {
                      warning = '瘦這麼快以後會反彈啦!';
                      _showDialog(context,warning);
                    } else if (selected == 1) {
                      decided = '最少減重:0.2公斤';
                      changed_tdee = tdee - 200;
                      DatabaseManager().createPlans();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showInfoScreen()));
                    } else if (selected == 2) {
                      decided = '正常減重:0.5公斤';
                      changed_tdee = tdee - 500;
                      DatabaseManager().createPlans();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showInfoScreen()));
                    } else if (selected == 3) {
                      decided = '重度減重:0.8公斤';
                      changed_tdee = tdee - 800;
                      DatabaseManager().createPlans();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showInfoScreen()));
                    } else if (selected == 4) {
                      decided = '瘋狂減重:1公斤';
                      changed_tdee = tdee - 1000;
                      DatabaseManager().createPlans();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => showInfoScreen()));
                    }
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => plansForWeightScreen()));
                  }),
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
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 15/h1*screen_height,),
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
                          '重選',
                          style: TextStyle(fontSize:16.sp,letterSpacing: 2),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          setState(() {
                            selected=0;
                          });
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