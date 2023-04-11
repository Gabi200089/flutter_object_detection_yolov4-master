import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:object_detection/global.dart';

class discount1 extends StatelessWidget {

  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom]); //隱藏status bar
    Size size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding:EdgeInsets.only(top: height*0.0208),

      child: Container(
        color: Color(0xFFFAEDCB),
        //color: Color(0xFFDADEF2),//淺藍色
        height: height*0.579,
        width:width,
        child: ListView.builder(
          itemCount: product1.length,
          itemBuilder: (context, index) {
            return
              product1[index].contains(search)
                  ?Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width*0.0636, vertical: height*0.0111), //方塊的間距(左右、上下)
                  child:
                  new GestureDetector(
                    onTap: () {
                      //getData();
                      launch(links1[index]); //目前沒資料之後改成商品連結~~~
                    },
                    child: new Container(
                      height: size.height * 0.20,
                      decoration: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(20.0), //圓角
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 5.0, //影子圓周
                                offset: Offset(5, 5) //影子位移
                            )
                          ]),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height*0.034, left: width*0.0458, right: width*0.0458, bottom: height*0.0209),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.3,
                                  height: size.height * 0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image(
                                      image: NetworkImage(picture1[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.48,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width*0.0509 / 2, top: height*0.0278 / 2.5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product1[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black.withOpacity(0.9),
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                            fontSize: (product1[index].length <= 5)
                                                ? 18.sp
                                                : 14.sp,
                                          ),
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
                                        Container(
                                          // width: size.width * 0.48,
                                          child: Row(children: [
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              original1[index],
                                              style: TextStyle(
                                                decoration:
                                                TextDecoration.lineThrough,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF787676),
                                                fontSize: 12.sp,
                                                letterSpacing: 2,
                                              ), //之後放原價
                                              maxLines: 2,
                                            ),
                                            SizedBox(
                                              width: size.width * 0.055,
                                            ), //空格!
                                            Text(
                                              prices1[index],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF0808),
                                                fontSize: 18.sp,
                                                letterSpacing: 2,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ]),
                                        ),
                                      ], //Column children
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              )
                  :Container(height: height*0,);
          },
        ),
      ),


    );
  }

}