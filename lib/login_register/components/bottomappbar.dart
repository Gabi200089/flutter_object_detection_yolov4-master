// import 'package:flutter/material.dart';
// import 'package:signin/screens/profileScreen/profileScreenEdit.dart';
// import 'package:signin/screens/setting/setting_screen.dart';


// class bottomappbar extends StatefulWidget {
//   @override
//   _bottomappbarState createState() => _bottomappbarState();
// }

// class _bottomappbarState extends State<bottomappbar> {
//   int currentTab = 0;
//   final List<Widget> screens = [
//     ProfileScreen(),
//     SettingScreen(),
//     SettingScreen(),
//     SettingScreen(),
//   ];
//   final PageStorageBucket bucket = PageStorageBucket();
//   Widget currentScreen = ProfileScreen();  //當前頁面

//   //final auth = FirebaseAuth.instance;
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageStorage(
//         bucket: bucket, 
//         child: currentScreen,
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   child: Icon(Icons.filter_center_focus_rounded),   //add
//       //   onPressed: (){},
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 10,
//         child: Container(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MaterialButton(      //button1
//                     minWidth: 80,
//                     onPressed: (){
//                       setState(() {
//                         currentScreen = ProfileScreen();  //change
//                         currentTab = 0;
//                       });
//                     },
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.home,   //dining_rounded
//                           color: currentTab == 0 ? Colors.blue : Colors.grey,
//                         ),
//                         // Text(
//                         //   'Dashboard',
//                         //   style: TextStyle(
//                         //     color:  currentTab == 1 ? Colors.blue : Colors.grey,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   MaterialButton(      //button2
//                     minWidth: 80,
//                     onPressed: (){
//                       setState(() {
//                         currentScreen = SettingScreen();  //change
//                         currentTab = 1;
//                       });
//                     },
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.fastfood_rounded,  //emoji_food_beverage_rounded   //add_reaction_rounded,
//                           color: currentTab == 1 ? Colors.blue : Colors.grey,
//                         ),
//                         // Text(
//                         //   'Dashboard',
//                         //   style: TextStyle(
//                         //     color:  currentTab == 0 ? Colors.blue : Colors.grey,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MaterialButton(      //button3
//                     minWidth: 60,
//                     onPressed: (){
//                       setState(() {
//                         currentScreen = SettingScreen();  //change
//                         currentTab = 2;
//                       });
//                     },
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.bar_chart_rounded,  //equalizer_rounded  //analytics_rounded  //align_vertical_bottom_rounded
//                           color: currentTab == 2 ? Colors.blue : Colors.grey,
//                         ),
//                         // Text(
//                         //   'Dashboard',
//                         //   style: TextStyle(
//                         //     color:  currentTab == 0 ? Colors.blue : Colors.grey,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   MaterialButton(      //button4
//                     minWidth: 80,
//                     onPressed: (){
//                       setState(() {
//                         currentScreen = SettingScreen();
//                         currentTab = 3;
//                       });
//                     },
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.person,
//                           color: currentTab == 3 ? Colors.blue : Colors.grey,
//                         ),
//                         // Text(
//                         //   'Dashboard',
//                         //   style: TextStyle(
//                         //     color:  currentTab == 0 ? Colors.blue : Colors.grey,
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }