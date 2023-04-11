import 'dart:ffi';

import 'package:object_detection/leadingScreens/showInfoScreen.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/leadingScreens/gainMustleScreen.dart';
import 'package:object_detection/leadingScreens/gainWeightScreen.dart';
import 'package:object_detection/leadingScreens/loseFatScreen.dart';
import 'package:object_detection/leadingScreens/loseWeightScreen.dart';
import 'package:object_detection/leadingScreens/sportHabitScreen.dart';
import 'package:flutter/services.dart';

import '../databaseManager.dart';

import 'package:sizer/sizer.dart';


class plansForWeightScreen extends StatelessWidget {
 

  
  
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => sportHabitScreen()));
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
                  height:13/h1*screen_height,
                  width: screen_width*0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5/h1*screen_height,),
            Text('step 5/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: screen_height*0.08,),
            Text('選擇你的目標',
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                letterSpacing: 4,
              ) ,
            ),
            SizedBox(height: screen_height*0.05,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: screen_width*0.16,
                      width: screen_width*0.27,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(width: 2, color: Color(0xff48748A)),
                          ),
                          onPressed: () {
                            selectedPlan = 'lose weight';
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => loseWeightScreen()));
                          },
                          child: Text('減重',style: TextStyle(fontSize: 18.sp,color: Colors.black,letterSpacing: 3),)),
                    ),
                    SizedBox(width: screen_width*0.06,),
                    Container(
                      height: screen_width*0.16,
                      width: screen_width*0.27,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(width: 2, color: Color(0xff48748A)),
                          ),
                          onPressed: () {
                            selectedPlan = 'lose fat';
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => loseFatScreen()));
                          },
                          child: Text('減脂',style: TextStyle(fontSize: 18.sp,color: Colors.black,letterSpacing: 3),)),
                    ),
                  ],
                ),
                SizedBox(height: screen_width*0.08,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: screen_width*0.16,
                      width: screen_width*0.27,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(width: 2, color: Color(0xff48748A)),
                          ),
                          onPressed: () {
                            selectedPlan = 'gain weight';
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => gainWeightScreen()));
                          },
                          child: Text('增重',style: TextStyle(fontSize: 18.sp,color: Colors.black,letterSpacing: 3))),
                    ),
                    SizedBox(width: screen_width*0.06,),
                    Container(
                      height: screen_width*0.16,
                      width: screen_width*0.27,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(width: 2, color: Color(0xff48748A)),
                          ),
                          onPressed: () {
                            selectedPlan = 'gain mustle';
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => gainMustleScreen()));
                          },
                          child: Text('增肌',style: TextStyle(fontSize: 18.sp,color: Colors.black,letterSpacing: 3))),
                    ),
                  ],
                ),
                SizedBox(height: screen_width*0.08,),
                Container(
                  height: screen_width*0.16,
                  width: screen_width*0.6,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        side: BorderSide(width: 2, color: Color(0xff48748A)),
                      ),
                      onPressed: () {
                        selectedPlan = 'maintain';
                        decided = '維持體重';
                        changed_tdee = tdee;
                        DatabaseManager().createPlans();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => showInfoScreen()));
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => maintainWeightScreen()));
                      },
                      child: Text('維持',style: TextStyle(fontSize: 18.sp,color: Colors.black,letterSpacing: 3))),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screen_width*0.11),
                  child: Image.asset(
                    "assets/startup.png",
                    // width: width*0.85,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}