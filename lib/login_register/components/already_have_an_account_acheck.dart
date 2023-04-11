import 'package:flutter/material.dart';
import 'package:object_detection/login_register/constants/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final void Function() press;
  const AlreadyHaveAnAccountCheck({
    // Key? key,
    // this.login = true,
    // required this.press,
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              login ? "還沒有帳號嗎? " : "已經有帳號了嗎? ",
              style: TextStyle(
                color: Color(0xFF585970),
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
            GestureDetector(
              onTap: press, // sign up method
              child: Text(
                login ? "點此註冊" : "點此登入",
                style: TextStyle(
                  color: Color(0xFF585970),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: w*0.26,right: w*0.3,top: w*0.01),
          height: 1.5,
          color: Color(0xFFF4DB43),
        ),
      ],
    );
  }
}

