import 'package:object_detection/model/firebase_file.dart';
import 'package:object_detection/api/firebase_api.dart';
import 'package:object_detection/model/firebase_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/body_shape/download.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../../global.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({
    Key key,
    this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]); //隱藏status bar
    Size size = MediaQuery.of(context).size;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffC9E4DF),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height:_width*0.04,),
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 40/w*_width,
                      icon: Icon(Icons.arrow_back_ios_outlined),
                      color: Colors.black,
                      onPressed: (){
                        imgList.clear();
                        nameList.clear();
                        Navigator.pop(context,);
                      },
                    ),
                  ),
                  Text(
                    '${file.name.substring(21, file.name.length-2)} kg',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _width*0.1,),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: _width*0.05,right: _width*0.05,top: _width*0.08),
                height: _height * 0.7,
                width: _width*0.9,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: _height * 0.56,
                      width: _width*0.9,
                      child: Image.network(
                        file.url,
                        height: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: _width*0.05,),
                    Text(
                      '${file.name.substring(0, 16)} ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _width*0.05,),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: _width*0.07),
                    child: FloatingActionButton(
                      //getting image button
                        backgroundColor: Color(0xffFCD581),
                        child: Icon(Icons.delete,size: _width*0.09,),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("確定要刪除嗎?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("否" , style: TextStyle(color: Colors.redAccent),),
                                      onPressed: (){
                                        Navigator.of(context).pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("是"),
                                      onPressed: () async {
                                        await FirebaseApi.deleteFile(file.ref);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => download(), maintainState: false));
                                      },
                                    ),

                                  ],

                                );
                              }
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: _width*0.05,
            top: _width*0.05,
            child: FloatingActionButton(
              //getting image button
                backgroundColor: Color(0xffFCD581),
                child: Icon(Icons.file_download,size: _width*0.09,),
                onPressed: () async {
                  await FirebaseApi.downloadFile(file.ref);

                  final snackBar = SnackBar(
                    content: Text('Downloaded ${file.name}'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }),
          ),
        ],
      ),
    );
  }
}