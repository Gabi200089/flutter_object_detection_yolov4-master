import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/leadingScreens/ageScreen.dart';
import 'package:object_detection/leadingScreens/sportHabitScreen.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'heightScreen.dart';

import 'package:sizer/sizer.dart';


class weightScreen extends StatefulWidget {
  @override
  _weightScreenState createState() => _weightScreenState();
}

class _weightScreenState extends State<weightScreen> {
  DateTime _dateTime;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  createInfo(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('userInfo');
    documentReference.update({
      //'$_dateTime': input,
      'age' : age,
      'height' : height,
      'name' : name,
      'sexual' : sexual,
      'weight' : weight,
    });
    final report = FirebaseFirestore.instance.collection('report_body');
    //每日身體素質上傳(報表用)
    final date=DateTime.now();
    report.doc(user_email).collection(DateFormat('yyyy-MM-dd').format(date)).doc("body_shape").set({
      'kg':"0",
    }
    );
  }
  createbmr(){
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('userbmr');
    return documentReference.set({
      //'$_dateTime': input,
      'bmr' : bmr,
    });
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
            SizedBox(
              height: 10/h1*screen_height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => heightScreen(), maintainState: false));
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
                  width: screen_width*0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5/h1*screen_height,),
            Text('step 3/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: screen_height*0.12,),
            Text('請輸入目前體重',
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
                          weight = int.parse(value);
                          if(value == null){
                            check == false;
                          }else{
                            check =true;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        // hintText: 'weight(kg)',
                        //border: InputBorder.none,
                      ),
                    ),
                ),
                Text('公斤',
                  style: TextStyle(
                    color:Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize:16.sp,
                    letterSpacing: 4,
                  ) ,
                ),
              ],
            ),
            SizedBox(height: screen_width*0.15,),
            Container(
              margin: EdgeInsets.only(bottom: 10/h1*screen_height),
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.19),
              child: Image.asset(
                "assets/undraw_nature_on_screen_xkli.png",
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
                      if(sexual == '男'){
                        bmr = 10*weight+6.25*height-5*age+5;
                      }else{
                        bmr = 10*weight+6.25*height-5*age-161;
                      }
                      print('bmr:'+bmr.toString());
                      createInfo();
                      createbmr();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => sportHabitScreen()));
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