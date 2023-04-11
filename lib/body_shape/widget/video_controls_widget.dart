import 'dart:async';

import 'package:flutter/material.dart';
import 'package:object_detection/global.dart';
import 'package:video_player/video_player.dart';

class VideoControlsWidget extends StatelessWidget {
  VideoPlayerController controller;
  int endtime;
  VideoControlsWidget({this.controller, this.endtime,});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: video_control(controller: controller,endtime: endtime,),
  );
}

class video_control extends StatefulWidget {
  VideoPlayerController controller;
  int endtime;
  video_control({this.controller, this.endtime,Key key,}) : super(key: key);
  @override
  _video_controlState createState() => _video_controlState(this.controller, this.endtime,);
}

class _video_controlState extends State<video_control> {
  VideoPlayerController controller;
  int endtime;

  _video_controlState(this.controller, this.endtime,);

  start_timer()
  {
    video_timer=Timer.periodic(Duration(seconds: 1), (Timer t) {
      video_time=video_time+1;
      print(video_time.toString());
      if(video_time==5)
      {
        setState(() {
          reward=true;
        });
        final snackBar = SnackBar(
          content: const Text('Yay! A SnackBar!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        video_timer.cancel();
        print(reward.toString());
      }
    });
  }
  stop_timer()
  {
    if(video_timer!=null)
      video_timer.cancel();
    setState(() {
      video_timer=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            width: width,
            height: _height,
            child:
            Stack(
              children: <Widget>[
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 50),
                  reverseDuration: Duration(milliseconds: 200),
                  child: controller.value.isPlaying
                      ? SizedBox.shrink()
                      : Container(
                    color: Colors.black26,
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 100.0,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(controller.value.isPlaying==true)
                    {
                      controller.pause();
                      stop_timer();
                    }
                    else
                    {
                      controller.play();
                      if(video_timer==null&&reward==false)
                      {
                        start_timer();
                      }
                    }
                  },
                ),
              ],
            )
            )
        );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
}

// class VideoControlsWidget extends StatelessWidget {
//   VideoPlayerController controller;
//   int endtime;
//
//   VideoControlsWidget({
//      this.controller,
//      this.endtime,
//     Key key,
//   }) : super(key: key);
//
//   start_timer()
//   {
//     video_timer=Timer.periodic(Duration(seconds: 1), (Timer t) {
//       video_time=video_time+1;
//       print(video_time.toString());
//       if(video_time==5)
//         {
//           reward=true;
//           video_timer.cancel();
//           print(reward.toString());
//         }
//     });
//   }
//   stop_timer()
//   {
//     video_timer.cancel();
//     video_timer=null;
//   }
//   @override
//   Widget build(BuildContext context) => Stack(
//         children: <Widget>[
//           AnimatedSwitcher(
//             duration: Duration(milliseconds: 50),
//             reverseDuration: Duration(milliseconds: 200),
//             child: controller.value.isPlaying
//                 ? SizedBox.shrink()
//                 : Container(
//                     color: Colors.black26,
//                     child: Center(
//                       child: Icon(
//                         Icons.play_arrow,
//                         color: Colors.white,
//                         size: 100.0,
//                       ),
//                     ),
//                   ),
//           ),
//           GestureDetector(
//             onTap: () {
//               if(controller.value.isPlaying==true)
//                 {
//                   controller.pause();
//                   stop_timer();
//                 }
//               else
//                 {
//                   controller.play();
//                   if(video_timer==null&&reward==false)
//                     {
//                       start_timer();
//                       if(reward==true)
//                         {
//                           final snackBar = SnackBar(
//                             content: const Text('Yay! A SnackBar!'),
//                             action: SnackBarAction(
//                               label: 'Undo',
//                               onPressed: () {
//                                 // Some code to undo the change.
//                               },
//                             ),
//                           );
//
//                           // Find the ScaffoldMessenger in the widget tree
//                           // and use it to show a SnackBar.
//                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                         }
//                     }
//                 }
//             },
//           ),
//         ],
//       );
// }
