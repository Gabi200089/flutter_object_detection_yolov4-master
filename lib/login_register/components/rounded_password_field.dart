import 'package:flutter/material.dart';
import 'package:object_detection/login_register/components/text_field_container.dart';
import 'package:object_detection/login_register/constants/constants.dart';



class RoundedPasswordField extends StatelessWidget {
  bool isHiddenPassword = true;
  final ValueChanged<String> onchanged;
  final TextEditingController controller;
  final Color textColor;
  RoundedPasswordField({
    Key key,
    this.onchanged,
    this.textColor = Colors.white,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContianer(
      child: TextField(
        style: TextStyle(color: Colors.black,fontSize: 20,letterSpacing: 1),
        obscureText: isHiddenPassword,
        controller: controller,
        onChanged: onchanged,
        decoration: InputDecoration(
          hintText: '請輸入密碼',
          icon: Icon(
            Icons.lock,
            color: kPrimaryLightColor,
          ),
          // suffixIcon: InkWell(
          //   child: Icon( //without unseen password
          //     Icons.visibility,
          //     color: kPrimaryLightColor,
          //   ),
          // ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

