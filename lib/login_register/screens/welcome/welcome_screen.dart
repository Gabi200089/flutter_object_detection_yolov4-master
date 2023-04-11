import 'package:object_detection/global.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/screens/welcome/components/body.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';

class welcomeScreen extends StatelessWidget {
  //const welcomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          body: Body(),
        );
  }
}