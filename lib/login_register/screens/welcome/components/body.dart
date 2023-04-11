import 'package:flutter/services.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/components/rounded_button.dart';
import 'package:object_detection/login_register/constants/constants.dart';
import 'package:object_detection/login_register/screens/welcome/components/background.dart';
import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:object_detection/login_register/screens/signup/signup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';

class Body extends StatelessWidget {
  //const Body({ Key? key }) : super(key: key);
  bool datagot=false;
  final LocalStorage localStorage = new LocalStorage('healthy');
  final storage = FlutterSecureStorage();
  Future geteready()async{
    await localStorage.ready.then((_) => getemail());
  }
  Future<String>getemail()async{
    // user_email= await localStorage.getItem("email");
    // print("l:"+user_email);
    user_email = await storage.read(key: "email");
    print("s:"+user_email);
    datagot=true;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    Size size = MediaQuery.of(context).size;
    // geteready().then((_) => getemail());
    // getemail().then((_) => print(user_email));
    return FutureBuilder<String>(
      future: getemail(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( datagot == false){
          return Background(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    'Welcome to hEAlThÿ !',
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: size.height*0.05,),
                  Image.asset(
                    'assets/awesome!.png',
                    height: size.height * 0.4,
                  ),
                  SizedBox(height: size.height*0.08,),
                  RoundedButton(
                    text: 'LOGIN',
                    press: () {
                      String name = 'user';
                      String weight = '50';
                      String height = '160';
                      String age = '20';
                      String sexual = '女';
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context){
                          return LoginScreen();
                        },
                      ),
                      );
                    },
                  ),
                  RoundedButton(
                    text: 'SIGN UP',
                    color: kPrimaryLightColor,
                    textColor: Colors.black,
                    press: (){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context){
                            return signUpScreen();
                          }
                      )
                      );
                    },
                  ),
                ],
              ),
            ),);
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SettingScreen()));
          });
          return Container();
        }
      },
    );
    // if(user_email!=null)
    //   {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SettingScreen()));
    //     });
    //     return Container();
    //   }
    // else
    //   {
    //     // provide the total height and width of the screen
    //     return Background(
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: <Widget>[
    //             Text(
    //               'Welcome to hEAlThÿ !',
    //               style: TextStyle(
    //                   fontWeight: FontWeight.bold
    //               ),
    //             ),
    //             SizedBox(height: size.height*0.05,),
    //             Image.asset(
    //               'assets/awesome!.png',
    //               height: size.height * 0.4,
    //             ),
    //             SizedBox(height: size.height*0.08,),
    //             RoundedButton(
    //               text: 'LOGIN',
    //               press: () {
    //                 String name = 'user';
    //                 String weight = '50';
    //                 String height = '160';
    //                 String age = '20';
    //                 String sexual = '女';
    //                 Navigator.push(
    //                   context, MaterialPageRoute(
    //                   builder: (context){
    //                     return LoginScreen();
    //                   },
    //                 ),
    //                 );
    //               },
    //             ),
    //             RoundedButton(
    //               text: 'SIGN UP',
    //               color: kPrimaryLightColor,
    //               textColor: Colors.black,
    //               press: (){
    //                 Navigator.push(
    //                     context, MaterialPageRoute(
    //                     builder: (context){
    //                       return signUpScreen();
    //                     }
    //                 )
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       ),);
    //   }
  }
}

