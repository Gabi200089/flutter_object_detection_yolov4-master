import 'package:flutter/material.dart';

class backGround extends StatelessWidget {
  final Widget child;
  const backGround({
    Key key,
    this.child,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
      child,
        ],
      ),
    );
  }
}