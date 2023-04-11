import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/leadingScreens/plansForWeightScreen.dart';
import 'package:object_detection/leadingScreens/weightScreen.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

class sportHabitScreen extends StatefulWidget {
  const sportHabitScreen({ Key key }) : super(key: key);

  @override
  _sportHabitScreenState createState() => _sportHabitScreenState();
}

class _sportHabitScreenState extends State<sportHabitScreen> {
  
  int selected = 0;

  @override

  Future createtdee()async{
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('usertdee');
    return documentReference.set({
      //'$_dateTime': input,
      'tdee' : tdee,
    });
  }
  Future createhabit()async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('habits');
    if(selected==1)
      {
        return documentReference.set({'habit' : '沒有運動習慣',});
      }
    else if(selected==2)
      {
        return documentReference.set({'habit' : '運動1-2天/週',});
      }
    else if(selected==3)
    {
      return documentReference.set({'habit' : '運動3-5天/週',});
    }
    else if(selected==4)
    {
      return documentReference.set({'habit' : '運動6-7天/週',});
    }
    else if(selected==5)
    {
      return documentReference.set({'habit' : '每天運動2次',});
    }
    print('selected:'+selected.toString());
  }
  Future createnutrients()async{
    //CollectionReference todocollection = FirebaseFirestore.instance.collection('TODOs');
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(mail).collection('infos').doc('nutrients');
    return documentReference.set({
      //'$_dateTime': input,
      'protein' : protein,
      'fat' : fat,
      'carb' : carb,
    });
  }

  // selectedRadio(int val){
  //   setState(() {
  //     selected = val;
  //   });
  // }

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
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => weightScreen()));
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
                  width: screen_width*0.24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:Color(0xffBAE0F4),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5/h1*screen_height,),
            Text('step 4/7',style: TextStyle(color: Color(0xff48748A)),),
            SizedBox(height: screen_height*0.03,),
            Text('運動習慣',
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
                letterSpacing: 4,
              ) ,
            ),
            SizedBox(height: screen_height*0.015,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.08),
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
                      Text('沒有運動習慣',style: TextStyle(fontSize: 15.sp)),
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
                      Text('運動1-2天/週',style: TextStyle(fontSize: 15.sp)),
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
                      Text('運動3-5天/週',style: TextStyle(fontSize: 15.sp)),
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
                      Text('運動6-7天/週',style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 5,
                          groupValue: selected,
                          activeColor: Colors.blue,
                          onChanged: (int value) {
                            setState(() {
                              selected = value;
                            });
                          }),
                      Text('每天運動2次',style: TextStyle(fontSize: 15.sp)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screen_width*0.22),
              child: Image.asset(
                "assets/Fitness_Isometric.png",
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
                    if(selected != 0){
                      if (selected == 1) {
                        tdee = bmr * 1.2;
                        protein = weight * 0.8;
                        fat = tdee * 0.2 / 9;
                        carb = (tdee - (protein * 4 + fat * 9)) / 4;
                        createnutrients().then((_) {
                          createtdee().then((_) {
                            createhabit().then((_) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => plansForWeightScreen()));
                            });
                          });
                        });
                      } else if (selected == 2) {
                        tdee = bmr * 1.375;
                        protein = weight * 1.2;
                        fat = tdee * 0.2 / 9;
                        carb = (tdee - (protein * 4 + fat * 9)) / 4;
                        createnutrients().then((_) {
                          createtdee().then((_) {
                            createhabit().then((_) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => plansForWeightScreen()));
                            });
                          });
                        });
                      } else if (selected == 3) {
                        tdee = bmr * 1.55;
                        protein = weight * 1.2;
                        fat = tdee * 0.2 / 9;
                        carb = (tdee - (protein * 4 + fat * 9)) / 4;
                        createnutrients().then((_) {
                          createtdee().then((_) {
                            createhabit().then((_) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => plansForWeightScreen()));
                            });
                          });
                        });
                      } else if (selected == 4) {
                        tdee = bmr * 1.725;
                        protein = weight.toDouble() * 2;
                        fat = tdee * 0.2 / 9;
                        carb = (tdee - (protein * 4 + fat * 9)) / 4;
                        createnutrients().then((_) {
                          createtdee().then((_) {
                            createhabit().then((_) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => plansForWeightScreen()));
                            });
                          });
                        });
                      } else  if (selected == 5) {
                        tdee = bmr * 1.9;
                        protein = weight.toDouble() * 2;
                        fat = tdee * 0.2 / 9;
                        carb = (tdee - (protein * 4 + fat * 9)) / 4;
                        createnutrients().then((_) {
                          createtdee().then((_) {
                            createhabit().then((_) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context) => plansForWeightScreen()));
                            });
                          });
                        });
                      }
                    }

                  }),
            ),
          ],
        ),
      ),
    );
  }
}