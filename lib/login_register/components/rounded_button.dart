import 'package:flutter/material.dart';
import 'package:object_detection/login_register/constants/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function() press;
  final Color color,textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor, 
    this.textColor = Colors.white,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 5,
          child: Container(
            width:  size.width * 0.75,
            height: size.width * 0.14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Color(0xFFF4DB43),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width:  size.width * 0.8,
          height: size.width * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
                color: Color(0xFF585970),
                width: 3,
                style: BorderStyle.solid
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            onPressed: press,
            child:Text(
              text,
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xFF585970),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

