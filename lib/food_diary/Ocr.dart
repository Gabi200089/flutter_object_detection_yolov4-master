import 'dart:async';
import 'dart:io';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/food_diary/main.dart';
import 'package:object_detection/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:object_detection/global.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ScanResult.dart';
import 'check_page.dart';
import 'package:sizer/sizer.dart';


// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//
//   // String value;
//   // ocr({this.value});
//   static final String title = 'Firebase OCR';
//
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//     debugShowCheckedModeBanner: false,
//     title: title,
//     home: Ocr(value: '089686170726',),
//   );
// }
class Ocr extends StatefulWidget {

  String value;
  bool exist;
  Ocr({this.value,this.exist});

  @override
  _OcrState createState() => _OcrState(this.value,this.exist);
}

class _OcrState extends State<Ocr> {
  String value;
  bool exist;

  _OcrState(this.value,this.exist);
  UploadTask task;
  File file;
  String urlvalue="";
  String urlDownload="";
  int isnum=0;//是否已讀經過大卡
  String all,pack,kcal,pro,fat,fat1,fat2,carb,na;//營養標示
  String temp="";//暫存數字
  String result="";
  File image;
  ImagePicker imagePicker;
  File _selectedFile;
  bool _inProcess = false;
  var _formKey = GlobalKey<FormState>();

  String selected_url="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/image%2Fbarcode-food.png?alt=media&token=fa40d98b-7647-4a6f-8944-02eae434952f";

  final TextEditingController _txtName = new TextEditingController();
  final TextEditingController _txtAll = new TextEditingController();
  final TextEditingController _txtPack = new TextEditingController();
  final TextEditingController _txtKcal = new TextEditingController();
  final TextEditingController _txtPro = new TextEditingController();
  final TextEditingController _txtFat = new TextEditingController();
  final TextEditingController _txtCarb = new TextEditingController();
  final ref = FirebaseFirestore.instance.collection('barcode');


  int gnum1=2,gnum2=5;//gnum1=大卡以上公克數量 gnum2=大卡以下公克數量


  getImage(ImageSource source) async {
    this.setState((){
      _inProcess = true;
    });
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: source);
    if(image != null){
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(
              ratioX: 1, ratioY: 1),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            //  CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPreset.ratio16x9
          ],
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            lockAspectRatio: false,
            initAspectRatio: CropAspectRatioPreset.original,
            toolbarColor: Colors.deepOrange,
            toolbarTitle: "RPS Cropper",
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
          )
      );

      this.setState((){
        _selectedFile = cropped;
        _inProcess = false;
        performImageLabeling();
      });
    } else {
      this.setState((){
        _inProcess = false;
      });
    }
  }

  performImageLabeling()async
  {
    final FirebaseVisionImage firebaseVisionImage=FirebaseVisionImage.fromFile( _selectedFile);
    final TextRecognizer recognizer = FirebaseVision.instance.cloudTextRecognizer();
    VisionText visionText = await recognizer.processImage(firebaseVisionImage);

    result ="";gnum1=2;gnum2=5;temp="";isnum=0;
    all="";pack="";kcal="";pro="";fat="";fat1="";fat2="";carb="";na="";
    setState(() {
      for(TextBlock block in visionText.blocks)
      {
        final String txt=block.text;//有很多文字block

        for(TextLine line in block.lines)//讀出每個block的每個line
            {
          isnum=0;
          for(TextElement element in line.elements)//讀出每個line的每個element(字)
              {
            if(element.text.contains(new RegExp(r'[0-9]'))) {//如果字裡有數字的話
              temp = element.text; //把數字加到temp裡
              isnum=1;
            }
          }
          if(line.text.contains('大卡')) {
            //Kcal= true;
            gnum1=0;
            kcal=temp;
            result+="熱量:"+kcal;
          }
          else if(isnum==1&&gnum1==2){
            all=temp;
            gnum1-=1;
            result+="每一份量:"+all;
          }
          else if(isnum==1&&gnum1==1){
            pack=temp;
            gnum1-=1;
            result+="本包裝含:"+pack+"份";
          }
          else if(isnum==1&&gnum2==5){
            pro=temp;
            gnum2-=1;
            result+="蛋白質:"+pro;
          }
          else if(isnum==1&&gnum2==4){
            fat=temp;
            gnum2-=1;
            result+="脂肪:"+fat;
          }
          else if(isnum==1&&gnum2==3){
            fat1=temp;
            gnum2-=1;
            result+="飽和脂肪:"+fat1;
          }
          else if(isnum==1&&gnum2==2){
            fat2=temp;
            gnum2-=1;
            result+="反式脂肪:"+fat2;
          }
          else if(isnum==1&&gnum2==1){
            carb=temp;
            gnum2-=1;
            result+="碳水化合物:"+carb;
          }
          else if(line.text.contains('毫克')&&gnum2==0) {
            gnum2-=1;
            na=temp;
            result+="鈉:"+na;
          }

          result += "\n";//每一line換行
        }
        result += "\n";//每一block換行
      }
    });

  }

  Future<void> setData() async {
    if(exist==true){
      await ref.doc(value).get().then((DocumentSnapshot doc) async {
        String _name = doc['name'];
        String _cal = doc['calorie'];
        String _pro = doc['protein'];
        String _fat = doc['fat'];
        String _car = doc['carbohydrate'];
        String _pack = doc['perpack'];
        String _total = doc['packnum'];

        await setState(() {
          _txtName.text = _name;
          _txtKcal.text = _cal;
          _txtPro.text = _pro;
          _txtFat.text = _fat;
          _txtCarb.text = _car;
          _txtPack.text = _total;
          _txtAll.text = _pack;
        });
      });
    }
    else{
      setState(() {
        _txtName.text = "";
        _txtKcal.text = "";
        _txtPro.text = "";
        _txtFat.text = "";
        _txtCarb.text = "";
        _txtPack.text = "";
        _txtAll.text = "";
      });
    }

  }

  Future<void> newBarcode()async{
    await ref.doc(value).set
      ({'name':_txtName.text,
      'perpack':_txtAll.text,
      'packnum':double.parse(_txtPack.text).round().toString(),
      'calorie':_txtKcal.text,
      'protein':_txtPro.text,
      'fat':_txtFat.text,
      'carbohydrate':_txtCarb.text});
    //   .then((value) => {
    // _txtName.clear(),_txtAll.clear(),_txtPack.clear(),
    // _txtKcal.clear(),_txtPro.clear(),_txtFat.clear(),_txtCarb.clear()});

  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    setData();
  }

  @override
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
                margin: EdgeInsets.only(top:10/h*height,left: 3/w*width),
                child: Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 40,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Addrecord(),maintainState: false));
                      },
                    ),
                    Text("條碼:"+value,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black,letterSpacing: 3),
                    ),
                    SizedBox(width: width*0.07),
                    IconButton(
                      icon: Icon(Icons.info_outline_rounded),
                      color: Color(0xff7E7F9A),
                      iconSize: width*0.1,
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return SingleChildScrollView(
                                child: AlertDialog(
                                  title: Text('OCR使用說明',style: TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,),),
                                  content:  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: height*0.03,),
                                      Text('1.點選營養標示進入掃描',style: TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,),),
                                      SizedBox(height: height*0.02,),
                                      Image.asset(
                                        "assets/ocr_img1.png",
                                        width: width,
                                        // width: 125.0,
                                      ),
                                      SizedBox(height: height*0.04,),
                                      Text('2.拍攝營養標示',style: TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,),),
                                      SizedBox(height: height*0.02,),
                                      Image.asset(
                                        "assets/ocr_img3.png",
                                        width: width,
                                        // width: 125.0,
                                      ),
                                      SizedBox(height: height*0.04,),
                                      Text('3.將圖片裁切，僅保留右半邊「每份」營養資訊（即如紅色框線所示）',style: TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,),),
                                      //SizedBox(height: height*0.03,),
                                      SizedBox(height: height*0.02,),
                                      Image.asset(
                                        "assets/ocr_img2.png",
                                        width: width,
                                        // width: 125.0,
                                      ),
                                      SizedBox(height: height*0.04,),
                                      Text('如下圖所示進行裁切',style: TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,),),
                                      //SizedBox(height: height*0.03,),
                                      SizedBox(height: height*0.02,),
                                      Image.asset(
                                        "assets/ocr_img5.png",
                                        width: width,
                                        // width: 125.0,
                                      ),
                                      SizedBox(height: height*0.04,),
                                      Text('4.品名是需要自己輸入的喔!',style: TextStyle(
                                        color:Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,),),
                                      SizedBox(height: height*0.02,),
                                      Image.asset(
                                        "assets/ocr_img4.png",
                                        width: width,
                                        // width: 125.0,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        style: TextButton.styleFrom(
                                          padding:  EdgeInsets.all(10),
                                          shape:
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                                          backgroundColor: Color(0xff6893aa),
                                        ),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('我知道了!',style: TextStyle(color:Colors.white,))
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60/h*height,),
              ),
              Container(
                margin: EdgeInsets.only(top:height*0.085,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 145/w*width,
                      height: 145/h*height,
                      child: Text("新增\n餐點",
                        style: TextStyle(
                          color:Color(0xFF48406C),
                          fontWeight: FontWeight.w600,
                          fontSize: 38.sp,
                          letterSpacing: 6,
                        ) ,
                      ),
                    ),
                    SizedBox(width: 13/w*width,),
                    GestureDetector(
                      onTap: (){
                        _showPickOptionDialog(context);
                      },
                      child: Container(
                        width: 145/w*width,
                        height: 145/h*height,
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
                  ],
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: height*0.24),
                  // height: height*0.92,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 60/h*height),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: const Radius.circular(40),
                          ),
                          child: Container(
                            color: Colors.white,
                            padding:  EdgeInsets.only(left: 40/w*width, right: 40/w*width, bottom: 10/h*height,top: 40/h*height),
                            child: Column(
                              // padding: EdgeInsets.only(top: 30),
                                children:[
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _txtName,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: "品名",
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: _txtAll..text=all,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "每一份量(公克/毫升)",
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          onChanged:(val){all=val;},
                                        ),
                                        TextFormField(
                                          controller: _txtPack..text=pack,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "本包裝含(份)",
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          onChanged:(val){pack=val;},
                                        ),
                                        TextFormField(
                                          controller: _txtKcal..text=kcal,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "熱量(Kcal)",
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          onChanged:(val){kcal=val;},
                                        ),
                                        TextFormField(
                                          controller: _txtPro..text=pro,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "蛋白質(g)",
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          onChanged:(val){pro=val;},
                                        ),
                                        TextFormField(
                                          controller: _txtFat..text=fat,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "脂肪(g)",
                                            labelStyle: TextStyle(
                                                fontSize:14.sp,
                                                color: Colors.black),
                                          ),
                                          onChanged:(val){fat=val;},
                                        ),
                                        TextFormField(
                                          controller: _txtCarb..text=carb,
                                          validator: (val)=>val.isEmpty?"不得空白":null,
                                          style: TextStyle(
                                              fontSize: 16.sp, color: Colors.black),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "碳水化合物(g)",
                                            labelStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                          onChanged:(val){carb=val;},
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15/h*height,),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 80/w*width),
                                    child: Container(
                                      height: 50/h*height,
                                      child: ElevatedButton(
                                        // icon: Icon(Icons.check,size: 34),
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
                                            fontSize: 20.sp,
                                            letterSpacing: 6,
                                          ) ,
                                        ),
                                        onPressed: () async {
                                          if(_formKey.currentState.validate()){
                                            globals.food_url=selected_url;
                                            uploadFile().then((_) => newBarcode()).then((_){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  check_page(
                                                    name: _txtName.text,
                                                    pack:_txtAll.text,
                                                    total:double.parse(_txtPack.text).round().toString() ,
                                                    cal: _txtKcal.text,
                                                    pro: _txtPro.text,
                                                    fat: _txtFat.text,
                                                    car: _txtCarb.text,
                                                  )
                                              ),);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Container(
                        height: 75/h*height,
                        width: 75/w*width,
                        margin: EdgeInsets.only(top: 35/h*height,left:width*0.38),
                        decoration: BoxDecoration(
                          color: Color(0xff7E7F9A),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 4,
                              blurRadius: 5,
                              // offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(CircleBorder()),
                            backgroundColor: MaterialStateProperty.all(Color(0xff7E7F9A)),

                          ),
                          child: Text("營養\n標示",
                            style: TextStyle(
                                color:Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                height: 1.2/h*height
                            ) ,
                          ),
                          onPressed: (){
                            getImage(ImageSource.camera);
                          },
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

  Future uploadFile() async {
    Alert(context: context, title: "資料上傳中....", desc: "請稍候😃",buttons: []).show();
    if (file == null)
    {
      Alert(context: this.context, title: "資料上傳中....", desc: "請稍候😃",buttons: []).dismiss();
      globals.food_url="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/barcode-food.png?alt=media&token=37eb8b1f-46c6-4e3d-8ff1-4a7d6e6c99e3";
      return;
    }

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
    Alert(context: context, title: "資料上傳中....", desc: "請稍候😃",buttons: []).dismiss();
    if(exist==false) newBarcode();
  }
  Future Preset() async{
    setState(() => file = null);
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

}
