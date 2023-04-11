import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/databaseManager.dart';
import 'package:object_detection/leadingScreens/plansForWeightScreen.dart';
import 'package:object_detection/leadingScreens/showInfoScreen.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

class gainMustleScreen extends StatefulWidget {

  @override
  _gainMustleScreenState createState() => _gainMustleScreenState();
}

class _gainMustleScreenState extends State<gainMustleScreen> {
  
  int selected = 0;

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
                  height:13/h1*screen_height,
                  width: screen_width*0.36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5/h1*screen_height,),
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
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.25),
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
                      Text('最少增肌: 5%',style: TextStyle(fontSize: 15.sp)),
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
                      Text('正常增肌: 10%',style: TextStyle(fontSize: 15.sp)),
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
                      Text('瘋狂增肌: 15%',style: TextStyle(fontSize: 15.sp)),
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
                      if(selected == 1){
                        decided = '最少增肌: 5%';
                        changed_tdee = tdee * 1.05;
                        DatabaseManager().createPlans();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => showInfoScreen()));
                      }else if(selected == 2){
                        decided = '正常增肌: 10%';
                        changed_tdee = tdee * 1.1;
                        DatabaseManager().createPlans();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => showInfoScreen()));
                      }else if(selected == 3) {
                        decided = '瘋狂增肌: 15%';
                        changed_tdee = tdee * 1.15;
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
}