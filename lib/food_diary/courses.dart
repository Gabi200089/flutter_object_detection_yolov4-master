import 'package:object_detection/food_diary/food_inside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../global.dart';

import 'package:sizer/sizer.dart';

class Courses extends StatelessWidget {
  Widget _buildCourses(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;


    // Course course = courses[index];
    // if(food_type[index]=="早餐")
    //   {
    return
      food_type[index]=="早餐"?
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20/w*_width,vertical: 15/h*_height),
        child: new GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => foodInside(value:index,),maintainState: false));
          },
          child: new Container(
            height: size.height * 0.25,
            decoration: BoxDecoration(
              color: Color(0x4DD9D9D9),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5/h*_height,
                  left: 15.0/w*_width,
                  child:
                  Text(
                    food_time[index].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                  ),),
                Padding(
                  padding: EdgeInsets.only(top:25/h*_height,left:18/w*_width,right: 18/w*_width,bottom: 15/h*_height),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: NetworkImage(food_img[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.48,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: (20 / 2)/w*_width, top: (20 / 2.5)/h*_height),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(food_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  fontSize: (food_name[index].length<=5)?18.sp:14.sp,),
                                maxLines: 2,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              // Row(
                              //   children: [
                              // Icon(Icons.folder_open_rounded,color: Colors.black.withOpacity(0.3),),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              // Text(
                              //   food_time[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18,
                              //   ),
                              //   maxLines: 2,
                              // ),
                              Text(
                                "${food_kcal[index].toString()} kcal",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                  fontSize: 14.sp,
                                  letterSpacing: 2,
                                ),
                                maxLines: 2,
                              ),
                              // Text(
                              //   food_type[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.blue[800],
                              //     fontSize: 20,
                              //     letterSpacing: 2,
                              //   ),
                              //   maxLines: 2,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ):Text("");
    // }
  }
  Widget _buildCourses2(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    var list_b;

    // Course course = courses[index];
    // if(food_type[index]=="早餐")
    //   {
    return
      food_type[index]=="午餐"?
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20/w*_width,vertical: 15/h*_height),
        child: new GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => foodInside(value:index,),maintainState: false));
          },
          child: new Container(
            height: size.height * 0.22,
            decoration: BoxDecoration(
              color: Color(0x4DD9D9D9),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5/h*_height,
                  left: 15.0/w*_width,
                  child:
                  Text(
                    food_time[index].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                  ),),
                Padding(
                  padding:EdgeInsets.only(top:25/h*_height,left:18/w*_width,right: 18/w*_width,bottom: 15/h*_height),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: NetworkImage(food_img[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.48,
                        child: Padding(
                          padding:EdgeInsets.only(
                              left: (20 / 2)/w*_width, top: (20 / 2.5)/h*_height),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(food_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  fontSize: (food_name[index].length<=5)?18.sp:14.sp,),
                                maxLines: 2,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              // Row(
                              //   children: [
                              // Icon(Icons.folder_open_rounded,color: Colors.black.withOpacity(0.3),),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              // Text(
                              //   food_time[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18,
                              //   ),
                              //   maxLines: 2,
                              // ),
                              Text(
                                "${food_kcal[index].toString()} kcal",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                  fontSize: 14.sp,
                                  letterSpacing: 2,
                                ),
                                maxLines: 2,
                              ),
                              // Text(
                              //   food_type[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.blue[800],
                              //     fontSize: 20,
                              //     letterSpacing: 2,
                              //   ),
                              //   maxLines: 2,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ):Text("");

    // }
  }
  Widget _buildCourses3(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var list_b;

    // Course course = courses[index];
    // if(food_type[index]=="早餐")
    //   {
    return
      food_type[index]=="晚餐"?
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20/w*_width,vertical: (20/2)/h*_height),
        child: new GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => foodInside(value:index,),maintainState: false));
          },
          child: new Container(
            height: size.height * 0.22,
            decoration: BoxDecoration(
              color: Color(0x4DD9D9D9),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5/h*_height,
                  left: 15.0/w*_width,
                  child:
                  Text(
                    food_time[index].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                  ),),
                Padding(
                  padding: EdgeInsets.only(top:25/h*_height,left:18/w*_width,right: 18/w*_width,bottom: 15/h*_height),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: NetworkImage(food_img[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.48,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left:(20 / 2)/w*_width , top: (20 / 2.5)/h*_height),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(food_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  fontSize: (food_name[index].length<=5)?18.sp:14.sp,),
                                maxLines: 2,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              // Row(
                              //   children: [
                              // Icon(Icons.folder_open_rounded,color: Colors.black.withOpacity(0.3),),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              // Text(
                              //   food_time[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18,
                              //   ),
                              //   maxLines: 2,
                              // ),
                              Text(
                                "${int.parse(food_kcal[index])} kcal",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                  fontSize:14.sp,
                                  letterSpacing: 2,
                                ),
                                maxLines: 2,
                              ),
                              // Text(
                              //   food_type[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.blue[800],
                              //     fontSize: 20,
                              //     letterSpacing: 2,
                              //   ),
                              //   maxLines: 2,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ):Text("");

    // }
  }
  Widget _buildCourses4(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var list_b;

    // Course course = courses[index];
    // if(food_type[index]=="早餐")
    //   {
    return
      food_type[index]=="其他"?
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20/w*_width,vertical: (20/2)/h*_height),
        child: new GestureDetector(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => foodInside(value:index,),maintainState: false));
          },
          child: new Container(
            height: size.height * 0.22,
            decoration: BoxDecoration(
              color: Color(0x4DD9D9D9),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5/h*_height,
                  left: 15.0/w*_width,
                  child:
                  Text(
                    food_time[index].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                  ),),
                Padding(
                  padding: EdgeInsets.only(top:25/h*_height,left:18/w*_width,right: 18/w*_width,bottom: 15/h*_height),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.height * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image(
                            image: NetworkImage(food_img[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.48,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: (20 / 2)/w*_width, top:(20 / 2.5)/h*_height ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(food_name[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:Colors.black.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  fontSize: (food_name[index].length<=5)?18.sp:14.sp,),
                                maxLines: 2,
                                softWrap: true,
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              // Row(
                              //   children: [
                              // Icon(Icons.folder_open_rounded,color: Colors.black.withOpacity(0.3),),
                              SizedBox(
                                width: size.width * 0.01,
                              ),
                              // Text(
                              //   food_time[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     fontSize: 18,
                              //   ),
                              //   maxLines: 2,
                              // ),
                              Text(
                                "${food_kcal[index].toString()} kcal",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                  fontSize: 14.sp,
                                  letterSpacing: 2,
                                ),
                                maxLines: 2,
                              ),
                              // Text(
                              //   food_type[index].toString(),
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.blue[800],
                              //     fontSize: 20,
                              //     letterSpacing: 2,
                              //   ),
                              //   maxLines: 2,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ):Text("");

    // }
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20/w*_width,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20/w*_width,top: 5/h*_height,right: 30/w*_width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Breakfast",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4e416d),
                    fontSize: 17.sp,
                    letterSpacing: 3,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "See More ➡",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4e416d),
                    fontSize: 12.sp,
                    letterSpacing: 2,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: food_name.length,
                itemBuilder: (context, index) {
                  return _buildCourses(context, index);
                },
              )),
          Container(
            margin: EdgeInsets.only(left: 20/w*_width,top: 5/h*_height,right: 30/w*_width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lunch",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4e416d),
                    fontSize: 17.sp,
                    letterSpacing: 3,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "See More ➡",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4e416d),
                    fontSize: 12.sp,
                    letterSpacing: 2,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: food_name.length,
                itemBuilder: (context, index) {
                  return _buildCourses2(context, index);
                },
              )),
          Container(
            margin: EdgeInsets.only(left: 20/w*_width,top: 5/h*_height,right: 30/w*_width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dinner",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4e416d),
                    fontSize: 17.sp,
                    letterSpacing: 3,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "See More ➡",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4e416d),
                    fontSize: 12.sp,
                    letterSpacing: 2,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: food_name.length,
                itemBuilder: (context, index) {
                  return _buildCourses3(context, index);
                },
              )),
          Container(
            margin: EdgeInsets.only(left: 20/w*_width,top: 5/h*_height,right: 30/w*_width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Other",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4e416d),
                    fontSize: 17.sp,
                    letterSpacing: 3,
                  ),
                  maxLines: 2,
                ),
                Text(
                  "See More ➡",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4e416d),
                    fontSize: 12.sp,
                    letterSpacing: 2,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: food_name.length,
                itemBuilder: (context, index) {
                  return _buildCourses4(context, index);
                },
              )),
        ],
      ),
    );
  }
}
