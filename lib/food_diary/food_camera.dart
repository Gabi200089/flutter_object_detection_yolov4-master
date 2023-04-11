import 'dart:io';

import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/food_diary/food_search.dart';
import 'package:object_detection/food_diary/main.dart';
import 'package:object_detection/global.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:object_detection/api/firebase_apiu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tflite/tflite.dart';
import 'ScanResult.dart';
import '../global.dart' as globals;
import 'package:sizer/sizer.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class food_camera extends StatelessWidget {
  static final String title = '食物辨識';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.brown),
    home: FoodCamera(),
  );
}

class FoodCamera extends StatefulWidget {
  String value;
  FoodCamera({this.value});

  @override
  _FoodCameraState createState() => _FoodCameraState(this.value);
}

class _FoodCameraState extends State<FoodCamera> {
  String value;
  _FoodCameraState(this.value);

  File file;
  Path path;

  UploadTask task;
  String urlvalue="";
  String urlDownload="";

  String result1="";
  String result2="";
  List name=[];
  List confidence=[];


  bool isworking=false;
  String result="";


  loadModel() async
  {
    await Tflite.loadModel(
        model: "assets/model_unquant_meal.tflite",
        labels: "assets/label-meal.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate

    );
  }

  runModelOnStreamFrames(String path)async
  {
    int n=0;
    var recognitions = await Tflite.runModelOnImage(
      path: path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
        asynch: true
    );

    print(recognitions);
    setState(() {
      recognitions = recognitions;
    });


    // result="";
    result1=recognitions[0]["label"];
    result2=recognitions[1]["label"];
    // recognitions.forEach((response) //response=上面辨識到的食物(element)
    // {
    //   //label=食物名稱 confidence=信度 toStringAsFixed(2)=顯示到小數點後2位
    //   result = response["detectedClass"] + "  " + response["confidenceInClass"].toStringAsFixed(2);
    //   if(name.length==0)
    //     result1=result;
    //   else
    //     result2=result;
    //   name.add(response["detectedClass"]);
    //   confidence.add(response["confidenceInClass"].toStringAsFixed(2));
    //   print(result);
    //   // result="rice 0.9"+ "\n\n"+"toast 0.1";
    //
    // }
    // );

    setState(() {
      n++;
    });

    isworking = false;
  }

  @override
  void initState() {//default function
    super.initState();
    if(value=="camera")
      cameraFile();
    else
      selectFile();
    loadModel();
  }

  @override
  void dispose() async{
    super.dispose();
    await Tflite.close();
    // cameraController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFD8E6F0),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              height: height*0.23,
              left: 0/w1*width,
              right: 0/w1*width,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: const Radius.circular(20),
                ),
                child:Container(
                  color: Color(0xff8787A0),
                ) ,
              )),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: width*0.03,),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding: const EdgeInsets.all(4),
                        iconSize: 40/h*height,
                        icon: Icon(Icons.arrow_back_ios_outlined),
                        color: Colors.white,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Addrecord()),);
                        },
                      ),
                    ),
                    Text('食物辨識',
                      style: TextStyle(
                        color:Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                        letterSpacing: 4,
                      ) ,
                    ),
                  ],
                ),
                SizedBox(height: width*0.08,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: width*0.06),
                  color: Colors.white,
                  padding: EdgeInsets.only(top: width*0.01,left: width*0.01,right: width*0.01,bottom: width*0.05),
                  child: Column(
                    children: [
                      SizedBox(height: 12/h*height,),
                      Center(
                        child:
                        file == null
                        ?
                        Container(
                          height: 270/h*height,
                          width: 360/w*width,
                          child: Image.asset("assets/camera.gif",),
                        )
                        :Container(
                          height: 270/h*height,
                          width: 360/w*width,
                          child: Image.file(file,fit: BoxFit.cover,),
                        ),
                      ),
                      SizedBox(height: 12/h*height,),
                      Text('請選擇你的辨識結果',
                        style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          letterSpacing: 4,
                        ) ,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20/h*height,),
                Container(
                  height: width*0.1,
                  width: width*0.7,
                  child: Stack(
                    children: [
                      Container(
                        height: width*0.1,
                        width: width*0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child:
                          Text(
                            // category != null ? category!.label : '',
                            result1==""?"尚未有資料喔~":result1,
                            // split_result[0]=="ul"?"[尚未有資料喔~]":"番茄炒蛋",
                            style : TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.black),
                          ),
                          onPressed: () {
                            // uploadFile(split_result[0]);.
                            uploadFile(result1);
                          },
                        ),
                      ),
                      Container(
                        color: Color(0xff8787A0),
                        width: width*0.03,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top:55.0/h*height),
                    child:
                    Container(
                      height: width*0.1,
                      width: width*0.7,
                      child: Stack(
                        children: [
                          Container(
                            height: width*0.1,
                            width: width*0.7,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              ),
                              child:
                              Text(
                                // category != null ? category!.label : '',
                                // result2==""?"尚未有資料喔~":result2,
                                "其他",
                                // split_result[0]=="ul"?"[尚未有資料喔~]":"番茄炒蛋",
                                style : TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600,color: Colors.black),
                              ),
                              onPressed: () {
                                // uploadFile(split_result[0]);
                                Navigator.pop(this.context);
                                Navigator.push(this.context, MaterialPageRoute(builder: (context) => food_search()),);
                                // uploadFile(result2);
                              },
                            ),
                          ),
                          Container(
                            color: Color(0xff8787A0),
                            width: width*0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // body: Container(
      //   color: Color(0xFFFAEDCB),
      //   height: height,
      //   width: width,
      //   child:
      //   Column(
      //     children: [
      //       Container(
      //         alignment: Alignment.topLeft,
      //         child: IconButton(
      //           padding: const EdgeInsets.all(4),
      //           iconSize: 40/h*height,
      //           icon: Icon(Icons.arrow_back_ios_outlined),
      //           color: Colors.black,
      //           onPressed: (){
      //             Navigator.push(context, MaterialPageRoute(builder: (context) => Addrecord()),);
      //           },
      //         ),
      //       ),
      //       Center(
      //         child:
      //         Container(
      //           margin: EdgeInsets.only(top:35/h*height),
      //           height: 300/h*height,
      //           width: 360/w*width,
      //           child:file == null
      //               ? Container(
      //             height: 270/h*height,
      //             width: 360/w*width,
      //             child:Image.asset(
      //               "assets/camera.gif",
      //               width: width,
      //               // width: 125.0,
      //             ),
      //           )
      //               : Container(
      //             height: 270/h*height,
      //             width: 360/w*width,
      //             // decoration: BoxDecoration(
      //             //   border: Border.all(),
      //             // ),
      //             child: ClipRRect(
      //                 borderRadius: BorderRadius.circular(20.0),
      //                 child:
      //                 Image.file( file,fit: BoxFit.cover)
      //               // :Image.network( selected_url,fit: BoxFit.fill,)
      //             ),
      //           ),
      //         ),
      //       ),
      //       Center(
      //         child: Container(
      //           margin: EdgeInsets.only(top:55.0/h*height),
      //           child: SingleChildScrollView(
      //             child:FlatButton(
      //               child:
      //               Text(
      //                 // category != null ? category!.label : '',
      //                 result1,
      //                 style : TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      //               ),
      //               onPressed: () {
      //                 uploadFile(name[0]);
      //               },
      //             ),
      //           ),
      //         ),
      //       ),
      //       Center(
      //         child: Container(
      //           margin: EdgeInsets.only(top:55.0/h*height),
      //           child: SingleChildScrollView(
      //             child:FlatButton(
      //               child:
      //               Text(
      //                 // category != null ? category!.label : '',
      //                 result2,
      //                 style : TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      //               ),
      //               onPressed: () {
      //                 uploadFile(name[1]);
      //               },
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
  Future selectFile() async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = File(result.path);
    });
    print("1"+file.path);
    runModelOnStreamFrames(file.path);
  }
  Future cameraFile() async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.camera);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    print("1"+file.path);
    runModelOnStreamFrames(file.path);

  }
  Future uploadFile(String name) async {
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).show();
    if (file == null) return;

    var now = DateTime.now();
    final destination = 'food_diary/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    food_url=urlDownload;
    print('Download-Link: $urlDownload');
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
    Navigator.pop(this.context);
    Navigator.push(this.context, MaterialPageRoute(builder: (context) => ScanResult(value: "food"+name)),);
  }
}