import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  //const notificationScreen({ Key? key }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DashboardScreen'),),
      body: Center(child: Text('DashboardScreen'),),
    );
  }
}