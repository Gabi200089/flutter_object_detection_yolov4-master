import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:object_detection/login_register/screens/welcome/welcome_screen.dart';
import 'package:object_detection/notification/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../login_register/screens/setting/setting_screen.dart';

class notification extends StatefulWidget {
  const notification({
    Key key,
    this.text,
    this.icon,

  }) : super(key: key);

  final String text;
  final IconData icon;

  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  String temp;
  int EXPout=0;
  int EXPclose=0;
  bool value = true;
  int hour = 0,minute = 0;
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  TimeOfDay time= TimeOfDay(hour: 0, minute: 0); //一開始在註冊資料時firebase要有值才不會壞掉
  bool datagot=false,datagot2=false;

  Future<String>getTime() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('dailyNotification');
    await documentReference.get().then((DocumentSnapshot doc) async{
      hour = int.parse(doc['hour']);
      minute = int.parse(doc['minute']);
    });
    DocumentReference documentReference1 = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('switch');
    await documentReference1.get().then((DocumentSnapshot doc) async{
      value = doc['switch'];
    });
    time= TimeOfDay(hour: hour, minute: minute);
    datagot=true;
  }
  void createAlarm(hours,minutes) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('dailyNotification');
    return documentReference.set({
      //'$_dateTime': input,
      'hour' : hours,
      'minute' : minutes,
    });

  }
  Future<String>getExp() async {
    EXPclose=0;
    EXPout=0;
    final refrecord = FirebaseFirestore.instance.collection('ingredient');
    QuerySnapshot querySnapshot = await refrecord.doc('userdata').collection(user_email).get();
    final exp_Data = querySnapshot.docs
        .map((doc) => temp = doc['exp'])
        .toList();
    final today = formatter.format(now);
    for(var i = 0; i < exp_Data.length; i++){
      final difference = DateTime.parse(exp_Data[i]).difference(DateTime.parse(today));
      if(difference.inDays<0)
        {
          exp_Data[i]=-1;
          EXPout+=1;
        }
      else
        {
          if(difference.inDays<3)
            {
              EXPclose+=1;
            }
          exp_Data[i]=difference.inDays;
        }
    }
        if(value==true)
        {
          print("EXPout:"+EXPout.toString());
          NotificationApi().cancelNotification();
          NotificationApi().showScheduledNotification(
              title: 'hEAlThy',
              body: '你今天登入了嗎?',
              payload: 'hi',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          );
          (EXPout==0&&EXPclose>0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPclose.toString()+"個食材快要過期了喔😢",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
          (EXPout>0&&EXPclose==0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPout.toString()+"個食材已經過期了喔😔",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
          (EXPout>0&&EXPclose>0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPclose.toString()+"個食材快過期，"+"\n"+"以及"+EXPout.toString()+"個食材過期了喔😰",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
        }
    datagot2=true;
  }
  String getText(){
    if(time == null){
      return 'select Time';
    }else{
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      createAlarm(hours,minutes);
      return '$hours : $minutes';

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenNotifications();
    buildSwitch();
    getTime();
    time= TimeOfDay(hour: hour, minute: minute);
  }

  void listenNotifications()
  {
    NotificationApi.onNotifications.stream.listen((event){onClickedNotification("");});
  }
  void onClickedNotification(String payload) async{
    if(!mounted) return;
    Navigator.push(
      context, MaterialPageRoute(
      builder: (context){
        Navigator.pop(context);
        return welcomeScreen();
      },
    ),
    );
    // Navigator.push(context, MaterialPageRoute(builder: (context) => welcomeScreen()),);
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<List<String>>(
        future: Future.wait([
          getTime(),
          getExp()
        ]),// function where you call your api
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {   // AsyncSnapshot<Your object type>
          if( datagot == false||datagot2 == false){
            return  Center(
              heightFactor: height,
              child:
              Container(
                  height: height,
                  width: width,
                  color: Color(0xFFEDC58A),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170,),
                      Image.asset(
                        "assets/loading4.gif",
                        width: width,
                        // width: 125.0,
                      ),
                      Text('Loading...',
                        style: TextStyle(
                          color:Color(0xff51381c),
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          letterSpacing: 4,
                        ) ,
                      ),
                    ],
                  )
              ),
            );
          }else{
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
              child: Container(
                padding:EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 0),
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFF2F2F2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 3.0,//影子圓周
                          offset: Offset(3, 3)//影子位移
                      )
                    ]
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      widget.icon,
                      //Icons.person_rounded,
                      size: 28/h1*height,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Text(
                        widget.text,
                        //'My Account',
                        style: TextStyle(
                          color:Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ) ,
                      ),
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {
                        pickTime(context);
                      } ,
                      child: Text(
                          getText(),
                        style: TextStyle(
                          color:Color(0xFF369CF3),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ) ,
                      ),
                    ),
                    SizedBox(width: 5,),
                    buildSwitch(),
                  ],
                ),
              ),
            );
          }
        }
    );


  }
  Widget buildSwitch() => Switch.adaptive(
      activeColor: Colors.orange,
      activeTrackColor: Colors.orangeAccent,
      value: value,
      onChanged: (value) {
        setState(
              () {
                this.value = value;
                print("schedule:"+value.toString());
              }
        );

        if(value == true){
          NotificationApi().showScheduledNotification(
              title: 'hEAlThy',
              body: '你今天登入了嗎?',
              payload: 'hi',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          );
          (EXPout>0&&EXPclose==0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPclose.toString()+"個食材快要過期了喔😰",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
          (EXPout==0&&EXPclose>0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPout.toString()+"個食材已經過期了喔😔",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
          (EXPout>0&&EXPclose>0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPclose.toString()+"個食材快過期，"+"\n"+"以及"+EXPout.toString()+"個食材過期了喔😰",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();

        }else
          NotificationApi().cancelNotification();

        DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('alarm').doc('switch');
        return documentReference.set({
          'switch':value,
        });
      }
  );

  Future pickTime(BuildContext context) async{
    final initialTime = TimeOfDay(hour: 12, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if(newTime == null) return;

    setState(() {
      time = newTime;
      createAlarm(time.hour, time.minute);
      if(value==true)
        {
          NotificationApi().showScheduledNotification(
              title: 'hEAlThy',
              body: '你今天登入了嗎?',
              payload: 'hi',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          );
          (EXPout==0&&EXPclose>0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPclose.toString()+"個食材快要過期了喔😢",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
          (EXPout>0&&EXPclose==0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPout.toString()+"個食材已經過期了喔😔",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
          (EXPout>0&&EXPclose>0)
              ?NotificationApi().showScheduledNotification1(
              title: 'hEAlThy',
              body: '你有'+EXPclose.toString()+"個食材快過期，"+"\n"+"以及"+EXPout.toString()+"個食材過期了喔😰",
              payload: '貼心小提醒',
              scheduledDate: DateTime.now().add(Duration(seconds: 1))
          ):Container();
        }
    }
     );
  }
}
