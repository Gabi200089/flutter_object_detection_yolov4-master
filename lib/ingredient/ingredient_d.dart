import 'dart:async';
import 'dart:io';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:object_detection/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';

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
      home: Ingredient_D(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Ingredient_D extends StatefulWidget {
  String name,url;
  Ingredient_D({this.name,this.url});
  @override
  _Ingredient_DState createState() => _Ingredient_DState(this.name,this.url);
}

class _Ingredient_DState extends State<Ingredient_D> {
  String name,url;
  _Ingredient_DState(this.name,this.url);

  bool _PlussEnabled=true;
  bool _MinusEnabled=true;
  int now_num=1;
  UploadTask task;
  File file;
  String recognition1="";
  String recognition2="";
  String urlvalue="";
  String urlDownload="";
  String selected_url="";
  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtNum = new TextEditingController();
  final TextEditingController _txtExp = new TextEditingController();
  final TextEditingController _txtClass = new TextEditingController();
  final ref = FirebaseFirestore.instance.collection('ingredient');
  String dropdownValue = '1';

  DateTime selectedDate=DateTime.now();
  DateTime selectedExp=DateTime.now();

  var _formKey = GlobalKey<FormState>();


  _selectExp() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: selectedExp,
        firstDate: DateTime(1990),
        lastDate: DateTime(2100)
    );

    if(date==null) return;

    setState(() {
      selectedExp=date;
      _txtExp
        ..text = DateFormat('yyyy-MM-dd').format(selectedExp)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _txtExp.text.length,
            affinity: TextAffinity.upstream));
    });
  }
  void _plusCheck(){
    (now_num<=1) ? _MinusEnabled=false : _MinusEnabled=true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected_url=url;
    _txtName.text=name;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    (now_num==1)? _MinusEnabled=false : _MinusEnabled=true ;
    return Scaffold(
      body: Container(
        color: Color(0xFFFAEDCB),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                    child: IconButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 40/h*_height,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.black,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(
                    right: 100.0/w*_width,
                  )),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        '新增\n食材',
                        style: TextStyle(
                          color:Color(0xFF49416D),
                          fontWeight: FontWeight.w600,
                          fontSize: 39.sp,
                          letterSpacing: 3,
                        ) ,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height*0.22,
                        width: MediaQuery.of(context).size.height*0.22,
                        // decoration: BoxDecoration(
                        //   border: Border.all(),
                        // ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                            child: file!=null
                                ?Image.file( file,fit: BoxFit.fill,)
                                :Image.network( selected_url,fit: BoxFit.fill,)
                          ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(
                  top: 20.0/h*_height,
                )),
                Container(
                    height: 460/h*_height,
                    width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 400/h*_height,
                        width: 320/w*_width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(45),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 3.0,//影子圓周
                                  offset: Offset(3, 3)//影子位移
                              )
                            ]
                        ),
                        child:Form(
                          key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.only(
                                    top: 40.0/h*_height,
                                  )),
                                  Container(
                                    width: 260/w*_width,
                                    child:  TextFormField(
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 29.0.sp, color: Colors.black,fontWeight: FontWeight.w600,),
                                      controller: _txtName,
                                      validator: (val)=>val.isEmpty?"名稱不得空白":null,
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 40.0),
                                          fillColor: Colors.transparent,
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                          hintText: "請輸入名稱",
                                          hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                                          // labelText: "名稱",
                                          // labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                                          border:  UnderlineInputBorder(),
                                          filled: true),
                                      maxLength: 15,
                                    ),
                                  ),
                                  Container(
                                    width: 260/w*_width,
                                    child:Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "類別",
                                              style: TextStyle(
                                                color:Color(0xFF49416D),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19.sp,
                                              ) ,
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(padding: EdgeInsets.only(
                                              left: 20.0/w*_width,
                                            )),
                                            DropdownButton(
                                              value: dropdownValue,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  dropdownValue = newValue;
                                                });
                                              },
                                              items: <String>['1', '2', '3', '4']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Image(image: AssetImage('assets/$value.png')),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                        Divider(color:Color(0xFF49416D),thickness:2),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 260/w*_width,
                                    child:
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "有效期限",
                                                  style: TextStyle(
                                                    color:Color(0xFF49416D),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 19.sp,
                                                  ) ,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Padding(padding: EdgeInsets.only(
                                                  left: 15.0/w*_width,
                                                )),
                                                Container(
                                                  width:43/w*_width,
                                                  height:43/h*_height,
                                                  child: Image(image: AssetImage('assets/calender.png'),),
                                                ),
                                              ],
                                            ),
                                            TextFormField(
                                              controller: _txtExp,
                                              readOnly: true,
                                              validator: (val)=>val.isEmpty?"有效日期不得空白":null,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize:19.0.sp, color: Colors.black,fontWeight: FontWeight.w600,),
                                              decoration: InputDecoration(
                                                  fillColor: Colors.transparent,
                                                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Color(0xFF49416D),width:2)),
                                                  hintText: "請選擇日期",
                                                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                                                  border:  UnderlineInputBorder(),
                                                  filled: true),
                                              onTap: _selectExp,
                                            ),
                                          ],
                                        ),
                                  ),
                                  // TextFormField(
                                  //   controller: _txtNum,
                                  //   validator: (val)=>val.isEmpty?"數量不得空白":null,
                                  //   decoration: InputDecoration(
                                  //       fillColor: Colors.transparent,
                                  //       hintText: "請輸入數量",
                                  //       hintStyle: TextStyle(fontSize: 22, color: Colors.grey),
                                  //       labelText: "數量",
                                  //       labelStyle: TextStyle(fontSize: 22, color: Colors.black),
                                  //       border:  UnderlineInputBorder(),
                                  //       filled: true),
                                  //   keyboardType: TextInputType.number,
                                  // ),
                                  Padding(padding: EdgeInsets.only(
                                    top: 20.0/h*_height,
                                  )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:[
                                      Container(
                                        height: 40/h*_height,
                                        width: 50/w*_width,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFF49416D), width: 2),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.transparent,
                                        ),
                                        child: FlatButton(
                                          padding: const EdgeInsets.all(4),
                                          child: Text("–",
                                            style: TextStyle(
                                              color:Color(0xFF48406C),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 22.sp,
                                            ) ,
                                            textAlign: TextAlign.center,
                                          ),
                                          // color: Color(0xFF49416D),
                                          onPressed:(){
                                            if(_MinusEnabled){
                                              setState(() {
                                                now_num-=1;
                                                print(now_num);
                                              });
                                              _plusCheck();
                                            }
                                            else null ;
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: size.width * 0.2,
                                        alignment:Alignment.center,
                                        child:
                                        Text(now_num.toString()+"份",
                                          style: TextStyle(
                                            color:Color(0xFF48406C),
                                            fontWeight: FontWeight.w700,
                                            fontSize:24.sp,
                                          ) ,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        height: 40/h*_height,
                                        width: 50/w*_width,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Color(0xFF49416D), width: 2),
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.transparent,
                                        ),
                                        child: IconButton(
                                          padding: const EdgeInsets.all(4),
                                          iconSize: 30/h*_height,
                                          icon: Icon(Icons.add),
                                          color: Color(0xFF49416D),
                                          onPressed:(){
                                            if(_PlussEnabled){
                                              setState(() {
                                                now_num+=1;
                                                print(now_num);
                                              });
                                              _plusCheck();
                                            }
                                            else null ;
                                          },
                                        ),
                                      ),
                                    ], ),
                                ]),
                          ),
                        ),
                      Positioned(
                        top: 0/h*_height,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  cameraFile();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7E7F9A),// set the background color
                                ),
                                child: Text(
                                  '相機',
                                  style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(
                                right: 10.0/w*_width,
                              )),
                              ElevatedButton(
                                onPressed: () async {
                                  selectFile();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7E7F9A),// set the background color
                                ),
                                child: Text(
                                  '裝置',
                                  style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(
                                right: 10.0/w*_width,
                              )),
                              ElevatedButton(
                                onPressed: () async {
                                  Preset();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7E7F9A),// set the background color
                                ),
                                child: Text(
                                  '預設',
                                  style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w600,),
                                ),
                              ),
                            ],),
                      ),
                      Positioned(
                        top: 400/h*_height,
                        child:Container(
                          height: 60/h*_height,
                          width: 60/w*_width,
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: 40/h*_height,
                            icon: Image.asset('assets/ok.png'),
                          onPressed: () async {
                            uploadFile();
                            }
                        ),
                      ),
                      ),
                    ],),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future selectFile() async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);
    recognition1="飯";
    recognition2="吐司";
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
  if(_txtExp.text=="")
  {
    Alert(context: this.context, title: "尚未選擇時間喔~", desc: "請記得選擇時間喔!!",buttons: []).show();
  }
  else {
    Alert(context: context, title: "圖片上傳中....", desc: "請稍候😃", buttons: [])
        .show();
    if (file == null) {
      await ref.doc('userdata').collection(user_email).add(
          {
            'name': _txtName.text,
            'num': now_num.toString(),
            "exp": _txtExp.text,
            "class": dropdownValue,
            "image": selected_url
          })
          .then((value) =>
      {
        _txtName.clear(),
        now_num = 1,
        _txtExp.clear()
      });
      Alert(
          context: this.context, title: "圖片上傳中....", desc: "請稍候😃", buttons: [])
          .dismiss();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ingredient_management(), maintainState: false));
    }
    var now = DateTime.now();
    final destination = 'ingredient/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);

    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
    selected_url = urlDownload;
    // ingredient_url=selected_url;
    print('Download-Link: $urlDownload');
    setState(() => selected_url = urlDownload);
    Alert(context: context, title: "圖片上傳中....", desc: "請稍候😃", buttons: [])
        .dismiss();
    await ref.doc('userdata').collection(user_email).add(
        {
          'name': _txtName.text,
          'num': now_num.toString(),
          "exp": _txtExp.text,
          "class": dropdownValue,
          "image": selected_url
        })
        .then((value) =>
    {
      _txtName.clear(),
      now_num = 1,
      _txtExp.clear()
    });
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ingredient_management(), maintainState: false));
  }
}

  Future Preset() async{
    setState(() => file = null);
  }
}
