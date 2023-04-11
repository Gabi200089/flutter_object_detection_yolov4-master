import 'dart:io';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/body_shape/video_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:object_detection/report/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:object_detection/api/firebase_api.dart';
// import 'package:date_format/date_format.dart';
import 'package:object_detection/model/firebase_file.dart';
import 'package:object_detection/body_shape/page/image_page.dart';
import 'package:object_detection/body_shape/slider.dart';
import 'package:object_detection/body_shape/upload.dart';

import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(download());
}

class download extends StatelessWidget {
  static final String title = '歷史紀錄';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MainPage(),
  );
}
File imageFile;
final List<String> imgList = [];
final List<String> nameList = [];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<List<FirebaseFile>> futureFiles;
  int currentTab = 2;
  DateTime _dateTime;

  final _screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    imgList.clear();
    nameList.clear();
    futureFiles = FirebaseApi.listAll('body_shape/$user_email');
  }

  @override
  Widget build(BuildContext context) {
    // imgList.clear();
    // nameList.clear();

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Screenshot(
      controller: _screenshotController,
      child:
      Scaffold(
        body:
        Container(
          height: 1000/h*_height,
          width: 400/w*_width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              child: Column(
                children:
                [
                  Padding(padding: EdgeInsets.only(top: 50/h*_height)),
                  Stack(
                    children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 20/w*_width)),
                      Text('歷史紀錄',style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600, letterSpacing:3,color: Color.fromRGBO(73, 65, 109, 1),),),
                      Padding(padding: EdgeInsets.only(left: 20/w*_width)),
                      IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => video_list(), maintainState: false));
                          },
                          icon: Icon(Icons.whatshot_outlined,size:38/h*_height,color: Color.fromRGBO(73, 65, 109, 1),)),
                      IconButton(
                          onPressed: (){
                            _takeScreenshot();
                          },
                          icon: Icon(Icons.share_rounded,size:38/h*_height,color: Color.fromRGBO(73, 65, 109, 1),)),
                    ],
                  ),
                      Positioned(
                        top: 5/h*_height,
                        left: 313/w*_width,
                        child: Container(
                          height: 55/h*_height,
                          width: 55/w*_width,
                          decoration: BoxDecoration(
                            //border: Border.all(color: Color.fromRGBO(73, 65, 109, 1),width: 2),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          child:
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => slider(),
                                      maintainState: false));
                            },
                            icon: Image.asset('assets/play.png'),
                            color: Color.fromRGBO(73, 65, 109, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 35/h*_height)),
                  Center(
                    child: Container(
                      width: 350/w*_width,
                      height: 500/h*_height,
                      //padding: EdgeInsets.only(left: 32,right: 32),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: new BorderRadius.circular(40),
                        shape: BoxShape.rectangle,
                      ),
                      child: FutureBuilder<List<FirebaseFile>>(
                        future: futureFiles,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Center(child: Text('Some error occurred!'));
                              } else {
                                final files = snapshot.data;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding:EdgeInsets.only(top: 15/h*_height)),
                                    buildHeader(files.length),
                                    SizedBox(height: 12/h*_height),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: files.length,
                                        itemBuilder: (context, index) {
                                          final file = files[index];
                                          makelist(file);
                                          return buildFile(context, file);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        bottomNavigationBar: CustomNavigationBar(
          iconSize: 40.0,
          selectedColor: Color(0xff040307),
          strokeColor: Color(0x30040307),
          unSelectedColor: Color(0xffacacac),
          backgroundColor: Colors.white,
          scaleFactor: 	0.5,
          items: [
            CustomNavigationBarItem(
              icon: Container(
                  margin: EdgeInsets.only(bottom: _width*0.012),
                  alignment: Alignment.bottomCenter,
                  width: _width * 0.07,
                  child: Image.asset('assets/食材管理.png',)),
            ),
            CustomNavigationBarItem(
              icon: Container(
                  margin: EdgeInsets.only(bottom: _width*0.012),
                  alignment: Alignment.bottomCenter,
                  width: _width * 0.07,
                  child: Image.asset('assets/飲食紀錄.png')),
            ),
            CustomNavigationBarItem(
              icon: Container(
                  child: Image.asset('assets/身形管理(改).png')),
            ),
            CustomNavigationBarItem(
              icon: Container(
                  margin: EdgeInsets.only(bottom: _width*0.012),
                  alignment: Alignment.bottomCenter,
                  width: _width * 0.07,
                  child: Image.asset('assets/數據分析.png')),
            ),
            CustomNavigationBarItem(
              icon: Container(
                  margin: EdgeInsets.only(bottom: _width*0.012),
                  alignment: Alignment.bottomCenter,
                  width: _width * 0.063,
                  child: Image.asset('assets/設定.png')),
            ),
          ],
          currentIndex: currentTab,
          onTap: (index) {
            switch(index){
              case 0:
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
                break;
              case 1:
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));
                break;
              case 2:
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => download(),maintainState: false));
                break;
              case 3:
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),maintainState: false));
                break;
              case 4:
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false));
                break;
            }

            // setState(() {
            //   _currentIndex = index;
            //   print(_currentIndex);
            // });
          },
        ),
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
    leading: ClipOval(
      child: 
      Image.network(
        file.url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    ),
    title:
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          file.name.substring(0,file.name.length-9),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color.fromRGBO(73, 65, 109, 1),
            // decoration: TextDecoration.underline,
            //color: Colors.blue,
          ),
        ),
        SizedBox(height: 3,),
        Divider(
          height: 5,
          thickness: 3,
          indent: 0,
          endIndent: 10,
        ),
      ],
    ),

    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children:
      [Text(

        file.name.substring(21,file.name.length),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          // decoration: TextDecoration.underline,
          fontSize: 24,
          color: Color.fromRGBO(73, 65, 109, 1),
          //color: Colors.blue,
        ),
      ),
      ],
    ),
    onTap: () => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImagePage(file: file),
    )),
  );



  Widget buildHeader(int length) => Container(
    child:Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 32)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(10),
            primary: Color.fromRGBO(138, 196, 184, 1),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => upload(), maintainState: false));
          },
          child: Icon(
            Icons.add,
            size: 40.0,
            color: Colors.black,
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 32)),
        Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Color.fromRGBO(73, 65, 109, 1),
          ),
        ),

      ],
    ),
  );
  makelist(FirebaseFile file)async
  {
    // imgList.clear();
    // nameList.clear();
    imgList.add(file.url);
    nameList.add(file.name);
  }
  void _takeScreenshot() async{
    _dateTime = DateTime.now();

    final imageFile = await _screenshotController.capture();
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/$_dateTime.png');
    image.writeAsBytesSync(imageFile);

    Share.shareFiles([image.path], text: "Shared from #hEAlThÿ");
  }
}

