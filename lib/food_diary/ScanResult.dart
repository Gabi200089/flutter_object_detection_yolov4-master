import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'food_record.dart';
import '../global.dart' as globals;
import '../global.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScanResult(value: '089686170726'),
    );
  }
}

class ScanResult extends StatefulWidget{

  String value;
  ScanResult({this.value});

  @override
  _ScanResultState createState() => _ScanResultState(this.value);
}

class _ScanResultState extends State<ScanResult> {
  String value;
  _ScanResultState(this.value);
  String who="user";

  final ref = FirebaseFirestore.instance.collection('barcode');
  final refFood = FirebaseFirestore.instance.collection('food');
  final refDiary = FirebaseFirestore.instance.collection('food-diary');


  String  pro,car,fat,cal,name,pack,total;//,barcodeScanRes="4710543002305";
  int caln,pron,fatn;
  bool _PlussEnabled,_MinusEnabled;
  int num=1;
  String valueSub;
  String dropdownValue='早餐';
  String time="time";
  bool datagot=false;
  Future<String> function_start;

  DateTime _dateTime;
  TimeOfDay _time;
  var picked_date,picked_time,Time;
  String Pmin,Phour;//minutes hours的全域變數




  Future<String> setData() async {
    await ref.doc(value).get().then((DocumentSnapshot doc) async{
      String _name = doc['name'];
      String _cal = doc['calorie'];
      String _pro = doc['protein'];
      String _fat = doc['fat'];
      String _car = doc['carbohydrate'];
      String _pack = doc['perpack'];
      String _total = doc['packnum'];

      await setState(() {
        name=_name;
        cal=_cal;
        pro=_pro;
        fat=_fat;
        car=_car;
        pack=_pack;
        total=_total;
      });
    });
    (num<int.parse(total))? _PlussEnabled=true : _PlussEnabled=false ;
    (num==1)? _MinusEnabled=false : _MinusEnabled=true ;
    datagot=true;
    // globals.food_url ="https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/food_diary%2Fuser%2Fbarcode-food.png?alt=media&token=06a7adcc-441d-4c79-bd94-46a15bde97e7";
  }

  Future<String> setDataFood(valueSub) async {
    await refFood.doc(valueSub).get().then((DocumentSnapshot doc) async{
      String _name = doc['name'];
      String _cal = doc['calorie'];
      String _pro = doc['protein'];
      String _fat = doc['fat'];
      String _car = doc['carbohydrate'];
      String _pack = doc['perpack'];
      String _total = doc['packnum'];

      await setState(() {
        name=_name;
        cal=_cal;
        pro=_pro;
        fat=_fat;
        car=_car;
        pack=_pack;
        total=_total;
      });
    });
    (num<int.parse(total))? _PlussEnabled=true : _PlussEnabled=false ;
    (num==1)? _MinusEnabled=false : _MinusEnabled=true ;
    datagot=true;
  }

  Future<void> setDiary() async {
    print(globals.food_url);

    await refDiary.doc(user_email).collection(picked_date).doc(picked_time).set({
      'name':name,
      'calorie':((double.parse(cal)*num.toDouble()).toInt()).toString(),
      "protein":(double.parse(pro)*num.toDouble()).toString(),
      "fat":(double.parse(fat)*num.toDouble()).toString(),
      "carbohydrate":(double.parse(car)*num.toDouble()).toString(),
      "perpack":pack,
      "num":num,
      "image":globals.food_url,
      "time":Time,
      "total":total,
      "type":dropdownValue,
    }
    );
  }

  void _Check(){
    (num>=int.parse(total)) ? _PlussEnabled=false : _PlussEnabled=true;
    (num<=1) ? _MinusEnabled=false : _MinusEnabled=true;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datagot=false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar

    if(value.contains("food"))
    {
      valueSub = value.substring(4);
      function_start=setDataFood(valueSub);
    }
    else
      function_start=setData();

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<String>(
      future: function_start, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFFEE4B57),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170/h*height,),
                      Image.asset(
                        "assets/loading6.gif",
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
            backgroundColor: Colors.white ,
            body: Stack(
              children: [
                Container(
                  height: 50/h*height,
                  width: 50/w*width,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined,size: 40/h*height,),
                    color: Colors.black,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => food_record()),);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 70.0/h*height,left: 10/w*width,right: 10/w*width),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          letterSpacing: 3,
                          color: Color(0xFF48406C),
                        ),),
                      SizedBox(height: 15/h*height,),
                      Text("每一份量含 "+pack.toString()+" 公克",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          letterSpacing: 5,
                          color: Color(0xFF48406C),
                        ),),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: height*0.3,
                      height: height*0.8,
                      left: 0/w*width,
                      right: 0/w*width,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(35),
                        ),
                        child: Container(
                          color: Color(0xffb2cfdd),
                          padding: EdgeInsets.only(top: 15/h*height, left: 18/w*width, right: 8/w*width, bottom: 10/h*height),
                          child: Column(
                            children:<Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("類別 : ",
                                    style: TextStyle(
                                      color:Color(0xFF48406C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.sp,
                                    ) ,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(width: 5/w*width,),
                                  Container(
                                    padding: EdgeInsets.only(left: 10/w*width),
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide( color: Color(0xFF48406C), width: 3/w*width),
                                      ),
                                    ),
                                    child: DropdownButton(
                                      value: dropdownValue,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      items: <String>['早餐', '午餐', '晚餐', '其他']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                            style: TextStyle(
                                              color:Color(0xFF48406C),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22.sp,
                                            ) ,
                                            textAlign: TextAlign.center,),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25/h*height,),
                              Row(
                                crossAxisAlignment:CrossAxisAlignment.center,
                                children: <Widget>[
                                  _RadialProgress(
                                    width: width * 0.29,
                                    height: width * 0.3,
                                    progress: double.parse(cal)/1000*num,
                                    cal: double.parse(cal)*num,
                                  ),
                                  SizedBox(width: 14/w*width,),
                                  Container(
                                    padding: EdgeInsets.only(top:5/h*height,bottom: 8/h*height,left: 10/w*width,right: 10/w*width),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        _IngredientProgress(
                                          ingredient: "蛋白質",
                                          progress: double.parse(pro)/15*num,
                                          progressColor: Colors.green,
                                          leftAmount: double.parse(pro)*num,
                                          width: width*0.43,
                                        ),
                                        SizedBox(height: 5,),
                                        _IngredientProgress(
                                          ingredient: "脂肪",
                                          progress: double.parse(fat)/30*num,
                                          progressColor: Colors.red,
                                          leftAmount: double.parse(fat)*num,
                                          width: width*0.43,
                                        ),
                                        SizedBox(height: 5,),
                                        _IngredientProgress(
                                          ingredient: "碳水化合物",
                                          progress: double.parse(car)/60*num,
                                          progressColor: Colors.yellow,
                                          leftAmount: double.parse(car)*num,
                                          width: width*0.43,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:width*0.05,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    onPressed:(){
                                      if(_MinusEnabled){
                                        setState(() {
                                          num-=1;
                                        });
                                        _Check();
                                      }
                                      else null ;
                                    },
                                    child: Icon(FontAwesomeIcons.minus,color: Color(0xff220055),
                                      size: 30/h*height,),
                                    shape: CircleBorder(),
                                    elevation:5.0,
                                    fillColor: Color(0xffFAF4F2),
                                    padding: const EdgeInsets.all(10.0),
                                  ),
                                  Text(
                                    '$num份',
                                    style: TextStyle(fontSize: 38.sp,color:Color(0xFF48406C),fontWeight: FontWeight.w600,),
                                  ),
                                  RawMaterialButton(
                                    onPressed:(){
                                      if(_PlussEnabled){
                                        setState(() {
                                          num+=1;
                                        });
                                        _Check();
                                      }
                                      else null ;
                                    },
                                    //_PlussEnabled ? () =>plus : null ,
                                    child: Icon(FontAwesomeIcons.plus,color: Color(0xFF092A44),
                                      size: 30/h*height,),
                                    shape: CircleBorder(),
                                    elevation: 5.0,
                                    fillColor: Color(0xffFAF4F2),
                                    padding: const EdgeInsets.all(10.0),
                                  ),
                                ],
                              ),
                              SizedBox(height: width*0.05,),
                              Text(picked_time == null ? '尚未選擇時間喔!' : picked_time.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),),
                              SizedBox(height: width*0.03,),
                              FlatButton(
                                child: Text(
                                  "選擇時間".toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19.sp,
                                    color: Colors.white,
                                    letterSpacing: 3,
                                  ),
                                ),
                                height: 45/h*height,
                                minWidth: 250/w*width,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                color: Color(0xff7E7F9A),
                                onPressed: () {
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
                                      picked_date=DateFormat('yyyy-MM-dd').format(_dateTime);
                                      picked_time="${picked_date}-$hours:$minutes";
                                      Time="${picked_date}-$hours:$minutes";
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
                              SizedBox(height: width*0.02,),
                              FlatButton(
                                height: 45/h*height,
                                minWidth: 250/w*width,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                color: Color(0xFF3D82AE),
                                onPressed: () {
                                  if(picked_time == null)
                                    {
                                      Alert(context: this.context, title: "尚未選擇時間喔~", desc: "請記得選擇時間喔!!",buttons: []).show();
                                    }
                                  else
                                    {
                                      setDiary();
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));
                                    }
                                },
                                child: Text(
                                  "完成".toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19.sp,
                                    color: Colors.white,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class _RadialProgress extends StatelessWidget{

  final double height,width,progress,cal;

  const _RadialProgress({Key key, this.height, this.width, this.progress, this.cal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
        progress: progress>1 ? 1 : progress, //0.7    //跟上面有連接
      ),
      child: Container(
          height: height,
          width: width,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(text: cal.toStringAsFixed(1),style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF200087)
                    ),),
                    TextSpan(text: "\n"),
                    TextSpan(text: "kcal",style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF200087)
                    ),),
                  ]
              ),
            ),
          )
      ),
    );
  }

}

class _RadialPainter extends CustomPainter{

  final double progress;

  _RadialPainter({this.progress});

  void paint(Canvas canvas,Size size){

    Paint bcgpaint =Paint()
      ..strokeWidth=10
      ..color = Colors.white
      ..style=PaintingStyle.fill //中間變空心
      ..strokeCap = StrokeCap.round;

    Paint paint =Paint()
      ..strokeWidth=10
      ..color = Colors.grey[350]//Color(0xFF200087)
      ..style=PaintingStyle.stroke //中間變空心
      ..strokeCap = StrokeCap.round;

    Offset center =Offset(size.width/2,size.height/2);
    canvas.drawCircle(center, size.width/2, bcgpaint);
    canvas.drawCircle(center, size.width/2, paint);

    Paint progressPaint =Paint()
      ..strokeWidth=10
      ..color = Colors.blue
      ..shader = LinearGradient(
          colors: [Color(0xFF005C97),Color(0xff363795),])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..style=PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;



    double relativeProgress=360*progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90), //改變方向從12點鐘方向往左走
      math.radians(-relativeProgress),  //改變百分比
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class _IngredientProgress extends StatelessWidget {

  final String  ingredient;
  final double leftAmount;
  final double progress,width;
  final Color progressColor;

  const _IngredientProgress({Key key, this.ingredient, this.leftAmount, this.progress, this.progressColor, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          ingredient.toUpperCase(),
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xFF48406C),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height:13,
                  width:width ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  height:13,
                  width: progress>1.0 ? width*1.0 : width*progress ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color:progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8,),
            Text(
              leftAmount.toStringAsFixed(1) + "g",
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF48406C),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

