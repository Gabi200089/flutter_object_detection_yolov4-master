import 'dart:async';
import 'dart:io';

import 'package:object_detection/api/firebase_apiu.dart';
import 'package:object_detection/body_shape/download.dart';
import 'package:object_detection/discount/discount.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/dailymenu.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:object_detection/login_register/screens/home_screen.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:object_detection/login_register/screens/welcome/welcome_screen.dart';
import 'package:object_detection/mall/mall.dart';
import 'package:object_detection/notification/notification.dart';
import 'package:object_detection/personal_edit/all_information.dart';
import 'package:object_detection/report/report.dart';
import 'package:object_detection/reportscreen.dart';
import 'package:object_detection/reward/checkin_reward.dart';
import 'package:object_detection/notification/notificationButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:object_detection/login_register/screens/profileScreen/profileScreenEdit.dart';
import 'package:object_detection/login_register/screens/setting/components/profile_menu.dart';
import 'package:object_detection/login_register/screens/setting/components/profilepic.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:sizer/sizer.dart';

class Body extends StatefulWidget {
  //const Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static BuildContext appContext;
  int currentTab = 4;
  final auth = FirebaseAuth.instance;
  final storage = FlutterSecureStorage();

  bool datagot=false;
  Timer timer;
  String urlDownload="";
  // String photo;
  UploadTask task;
  File file;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData_userInfo();
    NotificationApi.init(initScheduled: true);
    // listenNotifications();
  }
  Future<String>uploadpic() async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userInfo');
    await documentReference.update({
      'photo' : photo,
    });

    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
  }
  Future<String>getData_userInfo() async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('flutter-user').doc(user_email).collection('infos').doc('userInfo');
    await documentReference.get().then((DocumentSnapshot doc) async{
      name = doc['name'];
      photo = doc['photo'];
    });
    datagot=true;
  }
  // void  listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen(onClickedNotification);
  //
  //
  // void onClickedNotification(String payload) async{
  //   if(!mounted) return;
  //   Navigator.push(this.context, MaterialPageRoute(builder: (context) => welcomeScreen()),);
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);//隱藏status bar
    return FutureBuilder<String>(
      future: getData_userInfo(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return  Scaffold(
            body:
            Center(
              child:
              Container(
                  height: height,
                  width: width,
                  color:Color(0xffffbac4),
                  child:
                  Column(
                    children: [
                      SizedBox(height:170/h1*height,),
                      Image.asset(
                        "assets/loading10.gif",
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
            body:
            Container(
              child:
              SingleChildScrollView(
                child:
                Stack(
                  children: [
                    Container(
                      height: height*0.3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 2/w1*width),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                        color: Color(0xFF9EA8DB),
                      ),
                    ),
                    Positioned(
                      top: height*0.1669,
                      left: width*0.1323,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFFFFFFF),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 3.0,//影子圓周
                                  offset: Offset(3, 3)//影子位移
                              )
                            ]
                        ),
                        height: height*0.181,
                        width: width*0.738,
                        // icon: Icons.person_rounded,
                        child:
                        Text(name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 24.sp,
                          ) ,),
                      ),
                    ),
                    Positioned(
                      top: height*0.306,
                      left: width*0.267,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF858FDC),
                        ),
                        height: height*0.07,
                        width: width*0.458,
                        // icon: Icons.person_rounded,
                        child:
                        TextButton(
                          style: TextButton.styleFrom(
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),),
                          child: Text('編輯個人資料',
                            style: TextStyle(
                              color:Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ) ,),
                          onPressed: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => all_information()));},
                        ),
                      ),
                    ),
                    Positioned(
                      top: height*0.05,
                      left: width*0.015,
                      child: Container(
                        height: height*0.005,
                        width: width*0.22,
                        // icon: Icons.person_rounded,
                        child:
                        Divider(
                          height: 10,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),//上面白線1
                    Positioned(
                      top: height*0.08,
                      left: width*0.05,
                      child: Container(
                        height: height*0.005,
                        width: width*0.22,
                        // icon: Icons.person_rounded,
                        child:
                        Divider(
                          height: 10,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),//上面白線2
                    Column(
                      children: [
                        SizedBox(height: height*0.04),
                        SizedBox(
                          height: 115/h1*height,
                          width: 115/w1*width,
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(photo),
                              ),
                              // Positioned(
                              //   right:-12/w1*width,
                              //   bottom: 0/h1*height,
                              //   child: SizedBox(
                              //     height: 46/h1*height,
                              //     width: 46/w1*width,
                              //     child: TextButton(    //flatbutton
                              //         style: TextButton.styleFrom(
                              //           padding: EdgeInsets.zero,
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(50),
                              //             side: BorderSide(color: Colors.white),
                              //           ),
                              //           backgroundColor: Color(0xFFF5F6F9),
                              //         ),
                              //         onPressed: (){
                              //           _showPickOptionDialog(context);
                              //         },
                              //         child: Icon(Icons.camera_enhance_rounded)),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: width*0.35,),
                        profileMenu(
                          icon: Icons.card_giftcard,
                          text: 'healthy points',
                          press: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CheckinReward()),);
                          },
                        ),
                        profileMenu(
                          icon: Icons.campaign_sharp,
                          text: '撿便宜專區',
                          press: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => discount()),);
                          },
                        ),
                        profileMenu(
                          icon: Icons.campaign_sharp,
                          text: '素食商城',
                          press: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => mall()),);
                          },
                        ),
                        notification(
                          icon: Icons.notifications_active_rounded,  //notifications_none_rounded
                          text: '每日提醒',
                        ),
                        profileMenu(
                          icon: Icons.question_answer_rounded,
                          text: '問題回報',
                          press: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => reportScreen()),);
                          },
                        ),
                        profileMenu(
                          icon: Icons.logout,
                          text: '登出',
                          press: (){
                            storage.deleteAll();
                            auth.signOut();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),

              ),

            ),
            bottomNavigationBar: CustomNavigationBar(
              iconSize: 45,
              selectedColor: Color(0xff040307),
              strokeColor: Color(0x30040307),
              unSelectedColor: Color(0xffacacac),
              backgroundColor: Colors.white,
              scaleFactor: 	0.5,
              items: [
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/食材管理.png',)),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/飲食紀錄.png')),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/身形管理.png')),
                ),
                CustomNavigationBarItem(
                  icon: Container(
                      margin: EdgeInsets.only(bottom: width*0.012),
                      alignment: Alignment.bottomCenter,
                      width: width * 0.07,
                      child: Image.asset('assets/數據分析.png')),
                ),
                CustomNavigationBarItem(
                  icon: Container(child: Image.asset('assets/設定(改).png')),
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
          );
        }
        // BottomAppBar(
        //   shape: CircularNotchedRectangle(),
        //   notchMargin: 10,
        //   child: Container(
        //     height:60,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             MaterialButton(      //button1
        //               minWidth: 75/w*width,
        //               onPressed: (){
        //                 Navigator.pop(context);
        //                 Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
        //                 currentTab = 0;
        //               },
        //               child:  Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.manage_search,   //dining_rounded
        //                     color: currentTab == 0 ? Colors.blue : Colors.grey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             MaterialButton(      //button2
        //               minWidth: 75/w*width,
        //               onPressed: (){
        //                 Navigator.pop(context);
        //                 Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));//change
        //                 currentTab = 1;
        //               },
        //               child:  Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.fastfood_rounded,  //emoji_food_beverage_rounded   //add_reaction_rounded,
        //                     color: currentTab == 1 ? Colors.blue : Colors.grey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             MaterialButton(      //button3
        //               minWidth: 75/w*width,
        //               onPressed: (){
        //                 Navigator.pop(context);
        //                 Navigator.push(context, MaterialPageRoute(builder: (context) => download(),maintainState: false));//ch//change
        //                 currentTab = 2;
        //               },
        //               child:  Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.local_fire_department_outlined,   //dining_rounded
        //                     color: currentTab == 2 ? Colors.blue : Colors.grey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             MaterialButton(      //button4
        //               minWidth: 75/w*width,
        //               onPressed: (){
        //                 Navigator.pop(context);
        //                 Navigator.push(context, MaterialPageRoute(builder: (context) => Report(),maintainState: false)); //change
        //                 currentTab = 3;
        //               },
        //               child:  Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.bar_chart_rounded,   //dining_rounded
        //                     color: currentTab == 3 ? Colors.blue : Colors.grey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             MaterialButton(      //button5
        //               minWidth: 75/w*width,
        //               onPressed: (){
        //                 Navigator.pop(context);
        //                 Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false));
        //                 currentTab = 4;
        //               },
        //               child:  Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Icon(
        //                     Icons.person,   //dining_rounded
        //                     color: currentTab == 4 ? Colors.blue : Colors.grey,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

      },
    );
  }
  Future selectFile(BuildContext context) async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    uploadFile();

  }

  Future cameraFile(BuildContext context) async {
    final _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.camera);

    //if (result == null) return;
    //final path = result.files.single.path!;

    setState(() => file = File(result.path));
    uploadFile();
  }
  Future uploadFile() async {
    Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).show();
    if (file == null)
    {
      Alert(context: this.context, title: "圖片上傳中....", desc: "請稍候😃",buttons: []).dismiss();
      return;
    }
    var now = DateTime.now();
    final destination = 'user_photo/$user_email/$now';

    task = FirebaseApi2.uploadFile(destination, file);


    if (task == null) return;
    final snapshot = await task.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    // globals.food_url=selected_url;
    print('Download-Link: $urlDownload');
    setState(() => photo=urlDownload);
    Navigator.pop(context);
    uploadpic().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),maintainState: false)));
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
                        Icons.person,
                        size: 33,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '上傳頭貼',
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
