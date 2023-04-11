import 'package:object_detection/login_register/screens/setting/setting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
// import 'package:object_detection/login_register/screens/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sign in',
      theme: ThemeData(
        // primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: reportScreen(),
    );
  }
}
class reportScreen extends StatefulWidget {
  const reportScreen({Key key}) : super(key: key);

  @override
  _reportScreenState createState() => _reportScreenState();
}

class _reportScreenState extends State<reportScreen> {
  String report_email = '';
  String describe_problem = '';
  String selected = '程式無反應';
  final List<String> items = <String>[
    '程式無反應',
    '建議不精準',
    '付款過程',
    '其他',
  ];

  createReportForm() {
    DateTime _dateTime;
    _dateTime = DateTime.now();
    //'$_dateTime': input,
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('bugreport')
        .doc(_dateTime.toString());
    return documentReference.set({
      'email': report_email,
      'type_problem': selected,
      'describe_problem': describe_problem,
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      body:
      SingleChildScrollView(
        child: Container(
            color: Color(0xFFDADEF2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 40/h*height,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.black,
                      onPressed: () {
                        search = "";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen()),
                        );
                      },
                    ),
                    // Padding(padding: EdgeInsets.only(top: height*0.32)),
                    // Text(
                    //   "問題回報",
                    //   style: TextStyle(
                    //     letterSpacing: 7,
                    //     height: 1.6,
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 26,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    Container(
                      height: 185/h*height,
                      width: 335/w*width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/problem.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  ],
                ),

                // Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //      // crossAxisAlignment: CrossAxisAlignment.start,
                //      children: [
                //        // Text("問題回報",
                //        //   style: TextStyle(
                //        //     letterSpacing: 6,
                //        //     height: 1.6,
                //        //     fontWeight: FontWeight.w700,
                //        //     fontSize: 30,
                //        //     color: Colors.black,
                //        //   ),
                //        // ),
                //        Padding(padding: EdgeInsets.only(left: 15)),

                // ]),


                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    //margin: EdgeInsets.only(top: height * 0.01),
                    height: height * 0.72,

                    child: Stack(
                      children: [
                        Positioned(
                          // margin: EdgeInsets.only(top: 0),
                          // top: height * 0.1,
                          height: height * 0.8,
                          left: 0/w*width,
                          right: 0/w*width,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: const Radius.circular(35),
                            ),
                            child: Container(
                              color: Colors.white,
                              // padding: const EdgeInsets.only(
                              //     top: 25, left: 8, right: 8, bottom: 10),
                              child: Column(
                                children: [
                                  SizedBox(height: 65/h*height,),
                                  Text('請輸入你的帳號:',
                                    style: TextStyle(
                                      letterSpacing: 5,
                                      // height: 1.6,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    width: 250/w*width,
                                    child: TextField(
                                      //style: TextStyle(color: textColor),
                                      //keyboardType: TextInputType.number,
                                      //validator: (val) =>isEmail(val) ? null : 'Enter an email',
                                      //validator: (val) =>val.isEmpty ? 'Enter an email' : null,
                                      onChanged: (value) {
                                        setState(() {
                                          report_email = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: '你的帳號',
                                        hintStyle: TextStyle(
                                          letterSpacing: 5,
                                          // height: 1.6,
                                          // fontWeight: FontWeight.w400,
                                          // fontSize: 18,
                                          // color: Colors.black,
                                        ),
                                        // border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 30/h*height,),
                                  Text('請選擇你的問題:',
                                    style: TextStyle(
                                      letterSpacing: 5,
                                      // height: 1.6,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Text('Please select your problem:'),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(
                                          color: Colors.grey, width: 2/w*width),
                                    ),
                                    width: 250/w*width,
                                    child: DropdownButton<String>(
                                      hint: Text('please  select  problem'),
                                      value: selected,
                                      onChanged: (value) {
                                        setState(() {
                                          selected = value;
                                        });
                                      },
                                      items: items.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                            style: TextStyle(
                                              letterSpacing: 3,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                  SizedBox(height: 30/h*height,),
                                  Text('請說明你的問題:',
                                    style: TextStyle(
                                      letterSpacing: 5,
                                      // height: 1.6,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),),
                                  Container(
                                    width: 250/w*width,
                                    child: TextField(
                                      //style: TextStyle(color: textColor),
                                      // keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          describe_problem = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: '說明問題',
                                        hintStyle: TextStyle(
                                          letterSpacing: 5,
                                        ),
                                        // border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 50/h*height,),
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       elevation: 0,
                                  //       primary: Colors.blue,
                                  //       textStyle: TextStyle(
                                  //           fontSize: 22,
                                  //           fontWeight: FontWeight.w400),
                                  //     ),
                                  //     child: Text('submit'),
                                  //     onPressed: () {
                                  //       createReportForm();
                                  //       Navigator.of(context).pushReplacement(
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   HomeScreen()));
                                  //     }),

                                  IconButton(padding: const EdgeInsets.all(4),
                                      iconSize: 60/h*height,
                                      icon: Image.asset('assets/ok.png'),
                                      onPressed: () {
                                        createReportForm();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SettingScreen()));
                                      }
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      )
    );
  }
}
