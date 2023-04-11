import 'package:object_detection/leadingScreens/weightScreen.dart';
import 'package:object_detection/login_register/screens/signup/components/body.dart';
import 'package:object_detection/login_register/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/leadingScreens/ageScreen.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

class heightScreen extends StatefulWidget {
  @override
  _heightScreenState createState() => _heightScreenState();
}

class _heightScreenState extends State<heightScreen> {

@override
  void initState() {
    super.initState();
  }
bool check = false;
  @override
  Widget build(BuildContext context) {
    final screen_height = MediaQuery.of(context).size.height;
    final screen_width = MediaQuery.of(context).size.width;

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10/h1*screen_height,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ageScreen(), maintainState: false));
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
                  width: screen_width*0.12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5/h1*screen_height,),
            Text('step 2/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: screen_height*0.12,),
            Text('請輸入目前身高',
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                letterSpacing: 4,
              ) ,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: screen_width*0.07,bottom: screen_width*0.06,right: 10/w1*screen_width),
                  padding:EdgeInsets.symmetric(horizontal: 13/w1*screen_width),
                  width: screen_width*0.3,
                  height:65/h1*screen_height,
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
                    onChanged: (value){
                      setState(() {
                         height = int.parse(value);
                         if(value == null){
                           check = false;
                         }else{
                           check = true;
                         }
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      //hintText: 'height(cm)',
                      // border: InputBorder.none,
                    ),
                  ),
                ),
                Text('公分',
                  style: TextStyle(
                    color:Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    letterSpacing: 4,
                  ) ,
                ),
              ],
            ),
            SizedBox(height: screen_width*0.05,),
            Container(
              margin: EdgeInsets.only(bottom: 10/h1*screen_height),
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.2),
              child: Image.asset(
                "assets/去背板1.png",
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
                    if(check == true){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => weightScreen()));
                      check = false;
                    }

                  }),
            ),
          ],
        ),
      ),
    );
  }
}