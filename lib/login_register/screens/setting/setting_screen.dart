import 'package:object_detection/global.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/screens/setting/components/body.dart';


class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  //const SettingScreen({ Key? key }) : super(key: key);
  void initState() {
    // mainpage=true;
    //頁面重整
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('settingpage'),
      //   automaticallyImplyLeading: false,  //appbar 的 goback button 消失
      // ),
      body: Body(),
    );
  }
}