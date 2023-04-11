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
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: <Widget>[
          child,
        ],
      ),
    );
  }
}