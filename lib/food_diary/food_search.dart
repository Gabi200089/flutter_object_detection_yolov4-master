import 'dart:io';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/food_diary/ScanResult.dart';
import 'package:object_detection/food_diary/food_hand.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/components/text_field_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:object_detection/global.dart' as globals;
import 'package:sizer/sizer.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: food_search(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class food_search extends StatefulWidget {
  @override
  _food_searchState createState() => _food_searchState();
}

class _food_searchState extends State<food_search> {
  String search_food="";
  UploadTask task;
  File file;
  String temp;
  List food;
  String urlvalue="";
  String urlDownload="";
  bool checkOK=false;
  bool datagot=false;
  String selected_url="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/barcode-food.png?alt=media&token=37eb8b1f-46c6-4e3d-8ff1-4a7d6e6c99e3";
  final TextEditingController _txtName = new TextEditingController();
  final ref = FirebaseFirestore.instance.collection('food');

  var _formKey = GlobalKey<FormState>();

  Future<String>getData() async {
    QuerySnapshot querySnapshot = await ref.get();//只顯示當天的飲食記錄
    final food_Data = querySnapshot.docs
        .map((doc) => temp = doc.id)
        .toList();
    food=food_Data;
    datagot=true;
  }

  void check(){
    for(int i=0;i<food.length;i++){
      if(_txtName.text.contains(food[i]))
        checkOK=true;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    globals.food_url="";
    file=null;
    getData();
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: getData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFF0EB2BE),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170/h1*height,),
                      Image.asset(
                        "assets/loading2.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xffffffff),
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          letterSpacing: 4,
                        ) ,
                      ),
                    ],
                  )
              ),
            ),
          );
        }else{
          return Scaffold(
            backgroundColor: Color(0xFFD8E6F0),
            body: Container(
              // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  Column(
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
                              color: Colors.black,
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => food_record()),);
                              },
                            ),
                          ),
                          Text('手動搜尋',
                            style: TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                              letterSpacing: 4,
                            ) ,
                          ),
                        ],
                      ),
                      SizedBox(height: width*0.03,),
                      GestureDetector(
                        onTap: (){
                          _showPickOptionDialog(context);
                        },
                        child: Container(
                          width: 190/w*width,
                          height: 170/h*height,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child:file!=null
                                  ?Image.file( file,fit: BoxFit.cover,)
                                  :Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xff7E7F9A),
                                      width: 3/w*width,
                                      style: BorderStyle.solid
                                  ),
                                ),
                                child: Icon(Icons.camera_alt_outlined,size: 50/h*height,color: Color(0xff7E7F9A),),
                              )
                            //Image.network( selected_url,fit: BoxFit.cover,)
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.03,),
                      // Center(
                      //   child: Container(
                      //       constraints: BoxConstraints(
                      //           maxHeight: MediaQuery.of(context).size.height*0.25),
                      //       // decoration: BoxDecoration(
                      //       //   border: Border.all(),
                      //       // ),
                      //       child: file!=null
                      //           ?Image.file( file,fit: BoxFit.fill,)
                      //           :Image.network( selected_url,fit: BoxFit.fill,)
                      //   ),
                      // ),
                      // Padding(padding: EdgeInsets.only(
                      //   top: 20.0,
                      // )),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         cameraFile(context);
                      //       },
                      //       child: Text(
                      //         '使用相機',
                      //         style: TextStyle(fontSize: 20),
                      //       ),
                      //     ),
                      //     Padding(padding: EdgeInsets.only(
                      //       right: 10.0,
                      //     )),
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         selectFile(context);
                      //       },
                      //       child: Text(
                      //         '從裝置選擇',
                      //         style: TextStyle(fontSize: 20),
                      //       ),
                      //     ),
                      //     Padding(padding: EdgeInsets.only(
                      //       right: 10.0,
                      //     )),
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         Preset();
                      //       },
                      //       child: Text(
                      //         '使用預設',
                      //         style: TextStyle(fontSize: 20),
                      //       ),
                      //     ),
                      //   ],),
                      Form(
                        key: _formKey,
                        child:
                        Container(
                          width: width,
                          alignment: Alignment.center,
                          child:
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      width: width * 0.7,
                                      height: height*0.08,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 3,
                                            blurRadius: 3,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        controller: _txtName,
                                        style: TextStyle(fontSize: 17.0.sp, color: Colors.black,fontWeight: FontWeight.w600,),
                                        validator: (val)=>val.isEmpty?"名稱不得空白":null,
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.grey,
                                          ),
                                          fillColor: Colors.red,
                                          hintText: "請輸入名稱",
                                          hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                                          // labelText: "名稱",
                                          // labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value){
                                          setState(() {
                                            search_food = value.trim();
                                            print(search_food);
                                          });
                                        },
                                        // maxLength: 15,
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(
                                      right: 10.0/w*width,
                                    )),
                                    Container(
                                      height: 45/h1*height,
                                      width: 45/w1*width,
                                      decoration: BoxDecoration(
                                        color: Color(0xff7E7F9A),
                                        shape: BoxShape.circle,
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.grey.withOpacity(0.5),
                                        //     spreadRadius: 5,
                                        //     blurRadius: 7,
                                        //     offset: Offset(0, 3), // changes position of shadow
                                        //   ),
                                        // ],
                                      ),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(4),
                                        iconSize: 37/h1*height,
                                        icon: Icon(Icons.add,color: Colors.white,),
                                        onPressed: (){
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => food_hand()),);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: width*0.1,),
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: const Radius.circular(40),
                                  ),
                                  child: Container(
                                    color: Colors.white,
                                    height: height*0.6-25,
                                    padding: EdgeInsets.symmetric(horizontal: width*0.1,vertical:  width*0.06),
                                    child:_buildList(),
                                  ),
                                ),
                                // Container(
                                //   height: height*0.6-25,
                                //   width: width*0.9,
                                //   child:ListView.builder(
                                //     itemCount: food.length,
                                //     itemBuilder: (context, index) {
                                //       return
                                //         food[index].contains(search)
                                //         ?Container(
                                //         child: Row(
                                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //           children: [
                                //             Container(
                                //               child: Text(
                                //                 food[index],
                                //                 style: TextStyle(
                                //                   fontWeight: FontWeight.w600,
                                //                   fontSize:16.sp,
                                //                   // color: Colors.white,
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //       :Container();
                                //     },
                                //   ),
                                // ),
                              ]),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     globals.food_url=selected_url;
                      //     if(file!=null)
                      //       uploadFile();
                      //     else
                      //     {
                      //       check();
                      //       if(_formKey.currentState.validate()){
                      //         if(checkOK==true)
                      //         {
                      //           Navigator.pop(context);
                      //           Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(value: "food"+_txtName.text)),);
                      //         }
                      //         else
                      //           Alert(context: context, title: "資料庫沒有資料喔!", desc: "可以使用影像辨識看看~",buttons: []).show();
                      //       }
                      //     }
                      //   },
                      //   child: Text(
                      //     'Add Data',
                      //     style: TextStyle(fontSize: 20),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _showPickOptionDialog(BuildContext context) {
    showDialog(context: context,
        builder: (context)=>AlertDialog(
          elevation:0,
          backgroundColor: Colors.transparent,
          content: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 250,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xff434352),
                ),
              ),
              Container(
                width: 200,
                height: 250,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Color(0xff434352),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white,
                            width: 4,
                            style: BorderStyle.solid
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '紀錄圖片',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '選擇一張圖片或是拍張照',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7e7f9a),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '圖片',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          selectFile(context);
                        },//按一下相簿選圖片
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff7e7f9a),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8), // <-- Radius
                          ),
                        ),
                        child: Text(
                          '拍照',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          cameraFile(context);
                        },//按一下相簿選圖片
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildList() {
    List tempList = new List();
    for (int i = 0; i < food.length; i++) {
      if (food[i].contains(search_food)) {
        tempList.add(food[i]);
      }
    }
    return
      tempList.length>0
          ?
      ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        itemCount: tempList.length,
        itemBuilder: (BuildContext context, int index) {
          return new
          SingleChildScrollView(
            child:ListTile(
              title: Text(tempList[index],
                style: TextStyle(fontSize: 17.0.sp, color: Colors.black,fontWeight: FontWeight.w500,),maxLines: 2,),
              onTap: () {
                uploadFile(tempList[index]);
              },
            ),
          );
        },
      ):Container();
  }
  Future selectFile(BuildContext context) async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    Navigator.pop(context);

  }
  Future cameraFile(BuildContext context) async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.camera);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    Navigator.pop(context);
  }
  Future uploadFile(String tempList) async {
    Alert(context: context, title: "資料搜尋中....", desc: "請稍候😃",buttons: []).show();
    if (file == null)
    {
      Alert(context: this.context, title: "資料搜尋中....", desc: "請稍候😃",buttons: []).dismiss();
      globals.food_url=selected_url;
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(value: "food"+tempList)),);
    }
    var now = DateTime.now();
    final destination = 'food_diary/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);


    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    selected_url=urlDownload;
    globals.food_url=selected_url;
    print('Download-Link: $urlDownload');
    setState(() => selected_url=urlDownload);

    check();
    Alert(context: context, title: "資料搜尋中....", desc: "請稍候😃",buttons: []).dismiss();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanResult(value: "food"+tempList)),);
  }
  Future Preset() async{
    setState(() => file = null);
  }
}
