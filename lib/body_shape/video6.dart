import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/body_shape/video_list.dart';
import 'package:object_detection/body_shape/widget/video_player_widget6.dart';
import 'package:object_detection/global.dart';

void main() => runApp(video6());

class video6 extends StatelessWidget {
  final String title = 'Video Controls';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: MyHomePage(title: title),
  );
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: const Radius.circular(70),
              ),
              child: Container(
                color: Color(0xffC9E4DE),
                child: Column(
                  children: [
                    SizedBox(height: width*0.02,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          // padding: const EdgeInsets.all(4),
                          iconSize: 40,
                          icon: Icon(Icons.arrow_back_ios_outlined),
                          color: Colors.black,
                          onPressed: (){
                            controller.dispose();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => video_list()),);
                          },
                        ),
                        SizedBox(width: width*0.03,),
                        Center(
                          child: Text(
                            '一起運動吧!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width*0.16,),
                    VideoPlayerWidget6(
                      timestamps: <Duration>[
                        Duration(minutes: 0, seconds: 30),
                      ],
                    ),
                    SizedBox(height: width*0.13,),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Color(0xffC9E4DE),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(70),
                ),
                child: Container(
                  color: Color(0xffF2F8F6),
                  child:Image.asset(
                    "assets/Meditation_Two Color.png",
                    height: width*0.55,
                    // width: 125.0,
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
