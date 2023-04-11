import 'dart:io';

import 'package:object_detection/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:object_detection/api/firebase_apiu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:object_detection/body_shape/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

//Future main() async {
 // WidgetsFlutterBinding.ensureInitialized();
  //await SystemChrome.setPreferredOrientations([
  //  DeviceOrientation.portraitUp,
  //  DeviceOrientation.portraitDown,
 // ]);

 // await Firebase.initializeApp();

 // runApp(MyApp());
//}

class upload extends StatelessWidget {
  static final String title = '上傳資料';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.green),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UploadTask task;
  File file;
  DateTime _dateTime;
  TimeOfDay _time;
  var picked_date;
  String kg="";
  String Pmin,Phour;//minutes hours的全域變數

  final report = FirebaseFirestore.instance.collection('report_body');
  //每日身體素質上傳(報表用)
  Future<void> setreport() async {
    await report.doc(user_email).collection(DateFormat('yyyy-MM-dd').format(_dateTime)).doc("body_shape").set({
      'kg':kg,
    }
    );
  }

  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file.path) : '尚未選擇';

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(upload.title),
      //   centerTitle: true,
      // ),
      body:
      SingleChildScrollView(
        child:Stack(
          children: [
            Positioned(
              right: 3,
                top:10,
                child: Container(
                  width: _width*0.38,
                  height: _width*0.38,
                  child: Image.asset(
                    "assets/Balloon_Two.png",
                  ),
                )
            ),
            Column(
              children: [
                SizedBox(height:_width*0.03,),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40/w*_width,
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        color: Colors.black,
                        onPressed: (){
                          imgList.clear();
                          nameList.clear();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => download()),);
                        },
                      ),
                    ),
                    SizedBox(width: 6,),
                    Center(
                      child: Text(
                        '上傳資料',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(73, 65, 109, 1),
                          fontSize: 28,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height:_width*0.1,),
                Container(
                  padding: EdgeInsets.only(left: _width*0.15,right: _width*0.15),//左右兩邊空白
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2))
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 18),
                      controller: myController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "體重(Kg)",
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(73, 65, 109, 1),
                            letterSpacing: 2,
                            fontSize: 18
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height:_width*0.08,),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: const Radius.circular(60),
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height:_height*0.8,
                    color: Color(0xffC9E4DE),
                    padding: const EdgeInsets.only(top: 15, left: 18, right: 8, bottom: 5),
                    child: Column(
                      children: [
                        Text(
                          fileName,
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: _width*0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(bottom: 5) ,
                                  height: _width*0.2,
                                  width: _width*0.2,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(235, 245, 238, 1),
                                    borderRadius: new BorderRadius.circular(20),
                                    shape: BoxShape.rectangle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(15),
                                    icon: Image.asset('assets/camera.png'),
                                    color: Colors.black,
                                    onPressed: (){
                                      cameraFile();
                                    },
                                  ),
                                ),
                                Text("使用相機",
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2,
                                    fontSize: 18,
                                  ) ,
                                )
                              ],
                            ),
                            SizedBox(width: _width*0.1,),
                            Column(
                              children: [
                                Container(
                                  margin:EdgeInsets.only(bottom: 5) ,
                                  height: _width*0.2,
                                  width: _width*0.2,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(235, 245, 238, 1),
                                    borderRadius: new BorderRadius.circular(20),
                                    shape: BoxShape.rectangle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    padding: const EdgeInsets.all(18),
                                    icon: Image.asset('assets/image.png'),
                                    color: Colors.black,
                                    onPressed: (){
                                      selectFile();
                                    },
                                  ),
                                ),
                                Text("開啟相簿",
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2,
                                    fontSize: 18,
                                  ) ,
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: _width*0.1),
                        Text(picked_date == null ? '尚未選擇時間' : picked_date.toString(),style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),),
                        SizedBox(height: 20/h*_height),
                        Column(
                          children: [
                            Container(
                              margin:EdgeInsets.only(bottom: 5) ,
                              height: _width*0.2,
                              width: _width*0.2,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(235, 245, 238, 1),
                                borderRadius: new BorderRadius.circular(20),
                                shape: BoxShape.rectangle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(15),
                                icon: Image.asset('assets/calender.png'),
                                color: Colors.black,
                                onPressed: (){
                                  showTimePicker(//選擇時間
                                    context: context,
                                    initialTime: _time == null ? TimeOfDay.now() : _time,
                                  ).then((time) {
                                    setState(() {
                                      _time = time;
                                      final hours = time.hour.toString().padLeft(2, '0');
                                      final minutes = time.minute.toString().padLeft(2, '0');
                                      Phour=hours;
                                      Pmin=minutes;
                                      picked_date="${_dateTime.year}/${_dateTime.month}/${_dateTime.day}/$hours:$minutes";
                                    });
                                  });
                                  showDatePicker(//選擇日期
                                      context: context,
                                      initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                      firstDate: DateTime(2001),
                                      lastDate: DateTime.now()
                                  ).then((date) {
                                    setState(() {
                                      _dateTime = date;

                                    });
                                  });
                                },
                              ),
                            ),
                            Text("選擇時間",
                              style: TextStyle(
                                color:Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2,
                                fontSize: 18,
                              ) ,
                            )
                          ],
                        ),
                        SizedBox(height: 40/h*_height),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                            primary: Colors.blueGrey[900],
                          ),
                          onPressed: (){
                            uploadFile().then((_){
                              Alert(context: context, title: "資料上傳成功!",
                                buttons: [
                                  DialogButton(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                    ),
                                    onPressed: () => Alert(context: context, title: "資料上傳成功!",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                                          ),
                                          onPressed: (){
                                            Alert().dismiss();
                                          },
                                          width: 120/w*_width,
                                        )
                                      ],).dismiss(),
                                    width: 120/w*_width,
                                  )
                                ],).show();
                            });
                          },
                          child: Icon(
                            Icons.check,
                            size: 30.0/h*_height,
                          ),
                        ),
                        SizedBox(height: 20/h*_height),
                        task != null ? buildUploadStatus(task) : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),


      // floatingActionButton: FloatingActionButton(//getting image button
      //     child: Icon(Icons.image),
      //     onPressed: (){
      //       cameraFile();
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => download(), maintainState: false));
      //     }
      // ),
    );
  }

  Future selectFile() async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));

  }
  Future cameraFile() async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.camera);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));

  }

  Future uploadFile() async {
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).show();
    kg=myController.text;
    setreport();

    if (file == null) return;

    final fileName = basename(file.path);
    DateFormat('yyyy-MM-dd').format(_dateTime);
    final destination = 'body_shape/$user_email/${_dateTime.year}-${DateFormat('MM').format(_dateTime)}-${DateFormat('dd').format(_dateTime)}-$Phour:$Pmin  體重:$kg公斤';

    task = FirebaseApi2.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
