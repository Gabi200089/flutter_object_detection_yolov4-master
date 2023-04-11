import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/constants/constants.dart';
import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:object_detection/login_register/screens/welcome/welcome_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  runApp(App());
}
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(                           //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(                  //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil.setScreenSize(constraints, orientation);  //initialize SizerUtil
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'sign in',
              theme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.white,
              ),
              home: welcomeScreen(),
            );
          },
        );
      },
    );
  }
}
