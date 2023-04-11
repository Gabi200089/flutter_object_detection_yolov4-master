import 'package:flutter/services.dart';
import 'package:object_detection/global.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class profileMenu extends StatelessWidget {
  const profileMenu({
    Key key,
    this.text,
    this.icon,
    this.press,
    
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      child:
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 0),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 3.0,//影子圓周
                  offset: Offset(3, 3)//影子位移
              )
            ]
        ),
        child:
        TextButton(
          style: TextButton.styleFrom(
            padding:  EdgeInsets.all(20),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
            backgroundColor: Color(0xFFF2F2F2),
          ),
          onPressed: press,
          child: Row(
            children: [
              Icon(
                icon,
                //Icons.person_rounded,
                size: 28/w*width,
                color: Colors.redAccent,
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Text(
                  text,
                  //'My Account',
                  style: TextStyle(
                    color:Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ) ,
                  // style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Icon(Icons.arrow_forward_ios,color:Color(0xFF444FA3),),
            ],
          ),
        ),
      ),
    );
  }
}

