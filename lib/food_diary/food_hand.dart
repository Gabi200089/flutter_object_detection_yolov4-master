import 'dart:async';
import 'dart:io';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/food_diary/ScanResult.dart';
import 'package:object_detection/food_diary/check_page.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/food_diary/food_search.dart';
import 'package:object_detection/food_diary/main.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:object_detection/global.dart' as globals;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: food_hand(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class food_hand extends StatefulWidget {
  @override
  _food_handState createState() => _food_handState();
}

class _food_handState extends State<food_hand> {
  Timer timer;
  UploadTask task;
  File file;
  String temp;
  List food;
  String urlvalue="";
  String urlDownload="";
  bool checkOK=false;
  String selected_url="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/image%2Fbarcode-food.png?alt=media&token=fa40d98b-7647-4a6f-8944-02eae434952f";
  final ref = FirebaseFirestore.instance.collection('food');


  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtAll = new TextEditingController();
  final TextEditingController _txtPack = new TextEditingController();
  final TextEditingController _txtKcal = new TextEditingController();
  final TextEditingController _txtPro = new TextEditingController();
  final TextEditingController _txtFat = new TextEditingController();
  final TextEditingController _txtCarb = new TextEditingController();


  var _formKey = GlobalKey<FormState>();

  // Future getData() async {
  //   QuerySnapshot querySnapshot = await ref.get();//只顯示當天的飲食記錄
  //   final food_Data = querySnapshot.docs
  //       .map((doc) => temp = doc.id)
  //       .toList();
  //   food=food_Data;
  // }
  //
  // void check(){
  //   for(int i=0;i<food.length;i++){
  //     if(_txtName.text==food[i])
  //       checkOK=true;
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
  }

  Widget build(BuildContext context) {

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Color(0x80BCD4E6),
        height: height,
        width: width,
        child:SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top:10,left: 3),
                child: Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 40,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.black,
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => food_search ()),);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:height*0.075,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 145,
                      height: 145,
                      child: Text("新增\n餐點",
                        style: TextStyle(
                          color:Color(0xFF48406C),
                          fontWeight: FontWeight.w600,
                          fontSize: 44,
                          letterSpacing: 6,
                        ) ,
                      ),
                    ),
                    SizedBox(width: 13,),
                    GestureDetector(
                      onTap: (){
                        _showPickOptionDialog(context);
                      },
                      child: Container(
                        width: 145,
                        height: 145,
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
                                    width: 3,
                                    style: BorderStyle.solid
                                ),
                              ),
                              child: Icon(Icons.camera_alt_outlined,size: 50,color: Color(0xff7E7F9A),),
                            )
                          //Image.network( selected_url,fit: BoxFit.cover,)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: height*0.23),
                  height: height*0.85,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: const Radius.circular(40),
                          ),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                            child: Column(
                                children:[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _txtName,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: "品名",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtAll,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "每一份量(公克/毫升)",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtPack,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "本包裝含(份)",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtKcal,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "熱量(Kcal)",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtPro,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "蛋白質(g)",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtFat,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "脂肪(g)",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtCarb,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 22, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "碳水化合物(g)",
                                            labelStyle: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 80),
                                    child: Container(
                                      height: 50,
                                      child: ElevatedButton(
                                        //icon: Icon(Icons.check,size: 34),
                                        style: ElevatedButton.styleFrom(// returns ButtonStyle
                                          primary: Color(0xff7E7F9A),
                                          shape: StadiumBorder(
                                            //side: BorderSide( width: 10, color: Color(0xff7E7F9A)) //
                                          ),
                                        ),
                                        child: Text("下一步",
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 26,
                                            letterSpacing: 6,
                                          ) ,
                                        ),
                                        onPressed: () async {
                                          if(_formKey.currentState.validate()){
                                            uploadFile().then((_){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  check_page(
                                                    name: _txtName.text,
                                                    pack:_txtAll.text ,
                                                    total: _txtPack.text,
                                                    cal: _txtKcal.text,
                                                    pro: _txtPro.text,
                                                    fat: _txtFat.text,
                                                    car: _txtCarb.text,
                                                  )
                                              ),);
                                            });
                                          }
                                        },
                                        // globals.food_url=selected_url;
                                        // await ref.doc(value).set
                                        //   ({'name':_txtName.text,
                                        //   'perpack':_txtAll.text,
                                        //   'packnum':_txtPack.text,
                                        //   'calorie':_txtPack.text,
                                        //   'protein':_txtPro.text,
                                        //   'fat':_txtFat.text,
                                        //   'carbohydrate':_txtCarb.text})
                                        //     .then((value) => {
                                        //   _txtName.clear(),_txtAll.clear(),_txtPack.clear(),
                                        //   _txtKcal.clear(),_txtPro.clear(),_txtFat.clear(),_txtCarb.clear()});
                                        // Navigator.pop(context);

                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  @override

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


  Future uploadFile() async {

    if (file == null) return;
    var now = DateTime.now();
    final destination = 'food-diary/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);


    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    selected_url=urlDownload;
    globals.food_url=selected_url;
    print('Download-Link: $urlDownload');
    setState(() => selected_url=urlDownload);
  }
  Future Preset() async{
    setState(() => file = null);
  }
}
