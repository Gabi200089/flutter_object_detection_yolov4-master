import 'dart:async';

import 'package:object_detection/food_diary/food_inside.dart';
import 'package:object_detection/ingredient/recipe_inside.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/models/course.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../global.dart';

import 'package:sizer/sizer.dart';

class recipe_courses extends StatelessWidget {
  int value;
  recipe_courses({this.value,});
  Widget _buildCourses(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    // Course course = courses[index];
    bool has=false;

    final refrecord = FirebaseFirestore.instance.collection('ingredient');

    Future<void> getData() async {
      Alert(context: context,title: "食譜加載中....", desc: "請稍候😃",buttons: []).show();
      String temp;
      int same=0;

      QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(
          user_email).get(); //只顯示該用戶的食材記錄
      final name_Data = querySnapshot.docs
          .map((doc) => temp = doc['name'])
          .toList();
      ingredient_name = name_Data;
      yesno=look_gredients;


      for (int i = 0; i < look_gredients.length; i++) {
        for (int j = 0; j < ingredient_name.length; j++) {
          if (look_gredients[i].contains(ingredient_name[j])) {
            // setState(() {
              // yesno.add("1");

              yesno[i]="1"+yesno[i];
              has=true;
              j = ingredient_name.length;
            // });
          }
        }
        if (has==false)
        {
          yesno[i]="0"+yesno[i];
        }
        print("1");
        has=false;
      }
      Alert(context: context, title: "食譜加載中....", desc: "請稍候😃",buttons: []).dismiss();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => recipeInside(value1:value,name:has_foods[index].toString(),recipe_link:has_link[index],pic_link:has_pic[index]), maintainState: false));
    }

    return Padding(
      padding:EdgeInsets.symmetric(
          horizontal: 20/w*_width, vertical: (20 / 2)/h*_height),
    child: new GestureDetector(
    onTap: (){
      look_gredients=has_gredients[index].split('、');
      getData();
    },
      child: new Container(
        // width: size.width * 0.5,
        height: size.height * 0.40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30.0,//影子圓周
                  offset: Offset(10, 15)//影子位移
          )
            ]
      ),
        // child: Padding(
        //   padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                width: size.width * 0.9,
                height: size.height * 0.3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  child: Image(
                    image: NetworkImage(has_pic[index]),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: size.width * 0.65,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 0/w*_width, top:(20 / 1.5)/h*_height ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        has_foods[index].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:18.sp,
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      // Row(
                      //   children: [
                          // Icon(Icons.folder_open_rounded,color: Colors.black.withOpacity(0.3),),
                        ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: 20,
          ),
        ),
        Expanded(
            child:
            ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: has_foods.length,
              itemBuilder: (context, index) {
                return _buildCourses(context, index);
              },
            ))
      ],
    ),
    ),
    ],);

  }
}
