import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:object_detection/food_diary/food_record.dart';
import 'package:object_detection/global.dart';
import 'package:object_detection/ingredient/ingredient.dart';
import 'package:object_detection/ingredient/ingredient_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/login_register/screens/DashboardScreen.dart';
import 'package:object_detection/login_register/screens/login/login.dart';
import 'package:object_detection/login_register/screens/profileScreen/profileScreenEdit.dart';
import 'package:object_detection/login_register/screens/setting/setting_screen.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 4;
  final List<Widget> screens = [
    
    DashboardScreen(),
    SettingScreen(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = SettingScreen();  //當前頁面

  final auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Scaffold(
      body:
      PageStorage(
        bucket: bucket,
        child: currentScreen, //一開始進入homeScreen會跳出的頁面
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.filter_center_focus_rounded),   //add
      //   onPressed: (){},
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: mainpage==true ? 60 : 0,
          // height:60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(      //button1
                    minWidth: 75,
                    onPressed: (){
                      setState(() {
                        currentScreen = ingredient_management();  //change
                        // Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ingredient_management()),);
                        currentTab = 0;
                      });
                    },
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.manage_search,   //dining_rounded
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                        // Text(
                        //   'Dashboard',
                        //   style: TextStyle(
                        //     color:  currentTab == 1 ? Colors.blue : Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  MaterialButton(      //button2
                    minWidth: 75,
                    onPressed: (){
                      setState(() {
                        // Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => food_record(),maintainState: false));
                        currentScreen = food_record();  //change
                        currentTab = 1;
                      });
                    },
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood_rounded,  //emoji_food_beverage_rounded   //add_reaction_rounded,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        // Text(
                        //   'Dashboard',
                        //   style: TextStyle(
                        //     color:  currentTab == 0 ? Colors.blue : Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  MaterialButton(      //button3
                    minWidth: 75,
                    onPressed: (){
                      setState(() {
                        currentScreen = SettingScreen();  //change
                        currentTab = 2;
                      });
                    },
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_fire_department_outlined,   //dining_rounded
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        // Text(
                        //   'Dashboard',
                        //   style: TextStyle(
                        //     color:  currentTab == 1 ? Colors.blue : Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  MaterialButton(      //button4
                    minWidth: 75,
                    onPressed: (){
                      setState(() {
                        currentScreen = SettingScreen();  //change
                        currentTab = 3;
                      });
                    },
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart_rounded,   //dining_rounded
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        // Text(
                        //   'Dashboard',
                        //   style: TextStyle(
                        //     color:  currentTab == 1 ? Colors.blue : Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  MaterialButton(      //button5
                    minWidth: 75,
                    onPressed: (){
                      setState(() {
                        currentScreen = SettingScreen();  //change
                        currentTab = 4;
                      });
                    },
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,   //dining_rounded
                          color: currentTab == 4 ? Colors.blue : Colors.grey,
                        ),
                        // Text(
                        //   'Dashboard',
                        //   style: TextStyle(
                        //     color:  currentTab == 1 ? Colors.blue : Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //appBar: AppBar(title: Text('homepage'),),
    //   body: _children[_currentTab],
    //   bottomNavigationBar: BottomNavigationBar(// this will be set when a new tab is tapped
    //    onTap: onTabTapped, // new
    //    currentIndex: _currentTab,
    //    items: [
    //      BottomNavigationBarItem(
    //        icon: new Icon(Icons.home),
    //        title: new Text('Home'),
    //      ),
    //      BottomNavigationBarItem(
    //        icon: new Icon(Icons.mail),
    //        title: new Text('Messages'),
    //      ),
    //      BottomNavigationBarItem(
    //        icon: Icon(Icons.person),
    //        title: Text('Profile')
    //      )
    //    ],
    //  ),

      // body: Center(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //     child: Text('profile'),
      //     onPressed: (){
      //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen()));
      //     },
      //     ),
      //       ElevatedButton(
      //         child: Text('logout'),
      //         onPressed: (){
      //           auth.signOut();
      //           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      //         },
      //       ),
      //     ],
      //   ),
        
      // ),
    );
  }
}

