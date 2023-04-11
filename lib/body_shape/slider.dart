import 'package:cached_network_image/cached_network_image.dart';
import 'package:object_detection/body_shape/download.dart';
import 'package:object_detection/login_register/screens/login/components/background.dart';
import 'package:object_detection/model/firebase_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../global.dart';


//Future main() async {
// WidgetsFlutterBinding.ensureInitialized();
//await SystemChrome.setPreferredOrientations([
//  DeviceOrientation.portraitUp,
//  DeviceOrientation.portraitDown,
// ]);

// await Firebase.initializeApp();

// runApp(MyApp());
//}

class slider extends StatelessWidget {
  static final String title = '紀錄查看';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.purple),
    home: MainPage(),
  );
}

class MainPage extends StatefulWidget {

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double value = 0;
  int _current = 0;

  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    return Scaffold(
      backgroundColor: Color(0xffC9E4DF),
      body:
      SingleChildScrollView(
        child:
        Column(
          children:
          [
            SizedBox(height:width*0.03,),
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: const EdgeInsets.all(4),
                iconSize: 40/w*width,
                icon: Icon(Icons.arrow_back_ios_outlined),
                color: Colors.black,
                onPressed: (){
                  imgList.clear();
                  nameList.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => download()),);
                },
              ),
            ),
            SizedBox(height:width*0.05,),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width:width*0.75,
                  height:height*0.675,
                  color: Colors.white.withOpacity(0.3),
                ),
                Container(
                  width:width*0.8,
                  height:height*0.66,
                  color: Colors.white.withOpacity(0.5),
                ),
                Container(
                  width:width*0.85,
                  height:height*0.64,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        color: Colors.white,
                        margin: EdgeInsets.only(
                            left: width * 0.045,
                            right: width * 0.045,
                            top: width * 0.035),
                        child: imgList.length > 0
                            ? Stack(
                          children: [
                            Container(
                              height: height * 0.55,
                              child:
                              CachedNetworkImage(
                                imageUrl: '${imgList[value.toInt()]}',
                                // cacheManager: ,
                                useOldImageOnUrlChange: true,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image:
                                    DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                      // colorFilter:
                                      // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                    ),
                                  ),
                                ),
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                // errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                              // child: Image.network(
                              //   '${imgList[value.toInt()]}',
                              //   // 'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/folderName%2F2021-5-12%20%20%E9%AB%94%E9%87%8D%3A100%E5%85%AC%E6%96%A4?alt=media&token=012f5237-452a-4682-abee-71c520a06a6e',
                              //   fit: BoxFit.cover,
                              //   loadingBuilder: (BuildContext context, Widget child,
                              //       ImageChunkEvent loadingProgress) {
                              //     if (loadingProgress == null) return child;
                              //     return Center(
                              //         child: CircularProgressIndicator(
                              //           value: loadingProgress.expectedTotalBytes != null
                              //               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              //               :null
                              //           ));
                              //   },
                              //   //width: 1000 / w * width,
                              // ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.1,
                                  vertical: width * 0.1,
                                ),
                                // child: Text(
                                //   '${nameList[value.toInt()].substring(0, nameList[value.toInt()].length)}',
                                //   //照片上的字
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 14.sp,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ),
                            ),
                          ],
                        )
                            : Container(
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/nopic.gif',
                                  // 'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/folderName%2F2021-5-12%20%20%E9%AB%94%E9%87%8D%3A100%E5%85%AC%E6%96%A4?alt=media&token=012f5237-452a-4682-abee-71c520a06a6e',
                                  fit: BoxFit.cover,
                                  width: 1000 / w * width,
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(200, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0),
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20 / w * width,
                                      vertical: 10 / h * height,
                                    ),
                                    child: Text(
                                      '還沒有上傳照片喔~趕快上傳吧', //照片上的字
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      imgList.length > 1
                          ? Slider(
                        value: value,
                        min: 0,
                        max: imgList.length.toDouble() - 1,
                        divisions: imgList.length - 1,
                        activeColor: Color.fromRGBO(138, 196, 184, 1),
                        inactiveColor: Color.fromRGBO(201, 228, 222, 1),
                        //label: value.round().toString(),
                        onChanged: (value) =>
                            setState(() => this.value = value),
                      )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height:width*0.08,),
            imgList.length > 1
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: width*0.23,
                  width: width*0.42,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide( color: Color(0xFF8AA5A0), width: 3),
                        right: BorderSide( color: Color(0xFF8AA5A0), width: 3)
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height:width*0.04,),
                      Text(
                        '${nameList[value.toInt()].substring(0, 10)}',
                        style: TextStyle(
                          color: Color(0xff1D5C51),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '日期',
                        style: TextStyle(
                          color: Color(0xff748B88),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: width*0.23,
                  width: width*0.42,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide( color: Color(0xFF8AA5A0), width: 3),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height:width*0.04,),
                      Text(
                        '${nameList[value.toInt()].substring(21, nameList[value.toInt()].length-2)} kg',
                        style: TextStyle(
                          color: Color(0xff1D5C51),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '體重',
                        style: TextStyle(
                          color: Color(0xff748B88),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
                : Container()
          ],
        ),
      ),
    );
  }
}
