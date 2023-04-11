import 'package:flutter/material.dart';
import 'package:object_detection/login_register/constants/constants.dart';

class TextFieldContianer extends StatelessWidget {
  final Widget child;
  const TextFieldContianer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: Color(0xFF585970),
            width: 2,
            style: BorderStyle.solid
        ),
      ),
      child: child,
    );
  }
}

