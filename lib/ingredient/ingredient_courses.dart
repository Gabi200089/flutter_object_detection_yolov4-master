import 'dart:async';

import 'ingredient_inside.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:object_detection/global.dart';

import 'package:sizer/sizer.dart';

class Ingredient_Courses extends StatelessWidget {

  Color expColor=Colors.grey;
  Color remColor=Colors.green;

  Widget _buildCourses(BuildContext context, int index) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //Size size = MediaQuery.of(context).size;
    // Course course = courses[index];




    return Padding(
      padding: EdgeInsets.only(top:15/h1*height),
    child: new GestureDetector(
    onTap: (){
      ingredient_index=index;
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ingredientInside(value: 0,),maintainState: false));
    },
      child: Container(
        height: 200.0/h1*height,
        decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5.0,//影子圓周
                  offset: Offset(5, 5)//影子位移
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            width: width * 0.4,
            child: Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints.tightFor(width: 55.0/w1*width, height: 55.0/h1*height),
                  decoration: BoxDecoration(
                    color: Color(0xFF42476F),
                    shape: BoxShape.circle,
                    border: new Border.all(color: Color(0xFFA8A8A8), width: 4),
                  ),
                  alignment: Alignment.center,
                  child: Text(ingredient_num[sorted_id[index]],
                    style: TextStyle(
                      color:Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,),
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Text(
                  ingredient_name[sorted_id[index]].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                  maxLines: 2,
                ),
                SizedBox(
                  height: height * 0.005,
                ),

                Container(
                  child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("有效期限",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            letterSpacing: 2,
                            height: 1.6/h1*height,
                            fontWeight: FontWeight.w600,
                            fontSize:9.sp,
                            color: Colors.black54,
                          ),),
                          SizedBox(
                            height: height * 0.005,
                          ),
                          new LinearPercentIndicator(
                            width: width * 0.36,
                            lineHeight: 20.0,
                            percent: exp_day(ingredient_exp[sorted_id[index]]),
                            center: Text(
                              Remainder(ingredient_exp[sorted_id[index]]),
                              style: new TextStyle(fontSize:9.0.sp),
                              textAlign: TextAlign.center,
                            ),
                            // trailing: Icon(Icons.mood),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            backgroundColor: expColor,
                            progressColor: remColor,
                          )
                        ],
                      ),
                ),
              ],
                ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10/w1*width,
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
              child: Container(
                child: GridView.builder(
                  padding:EdgeInsets.only(top:4/h1*height,right:10/w1*width,left:10/w1*width),
                  physics: BouncingScrollPhysics(),
                  itemCount: ingredient_name.length,
                  itemBuilder: (context, index) {
                    return _buildCourses(context, index);
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.9),
                ),
              ))
        ],
      ),
    );
  }

  String Remainder(int exp) {
    if(exp<0)
      return "已過期";
    else
      return "$exp天";
  }

  double exp_day(int exp) {
    if(exp>30){
      expColor=Colors.grey;
      remColor=Colors.green;
      return 1;
    }
    else if(exp==-1) {
      expColor=Colors.red;
      return 0;
    }
    else{
      if(exp<3) remColor=Colors.yellow;
      else remColor=Colors.green;
      expColor=Colors.grey;
      return exp/30.0;
    }
  }

}