import 'package:flutter/material.dart';
import 'package:object_detection/login_register/components/text_field_container.dart';
import 'package:object_detection/login_register/constants/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
  final String hintText;
  final IconData icon;
  final Color color,textColor;
  final ValueChanged<String> onchanged;
  final TextEditingController controller;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.color = kPrimaryLightColor,
    this.textColor = Colors.white,
    this.icon = Icons.email,
    this.onchanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContianer(
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black, fontSize: 20,letterSpacing: 1),
        keyboardType: TextInputType.emailAddress,
        //validator: (val) =>isEmail(val) ? null : 'Enter an email',
        //validator: (val) =>val.isEmpty ? 'Enter an email' : null,
        onChanged: onchanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryLightColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

// bool isEmail(String input) {
//   if (input == null || input.isEmpty) return false;
//   return new RegExp(regexEmail).hasMatch(input);
// }

}

  
