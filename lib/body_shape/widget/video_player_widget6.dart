import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/body_shape/widget/video_controls_widget.dart';
import 'package:object_detection/body_shape/widget/video_progress_indicator.dart';
import 'package:object_detection/global.dart';
import 'package:video_player/video_player.dart';

import 'custom_controls_widget.dart';

class VideoPlayerWidget6 extends StatefulWidget {
  final List<Duration> timestamps;

  const VideoPlayerWidget6({
    @required this.timestamps,
    Key key,
  }) : super(key: key);
  @override
  _VideoPlayerWidget6State createState() => _VideoPlayerWidget6State();
}

class _VideoPlayerWidget6State extends State<VideoPlayerWidget6> {
  // VideoPlayerController controller;
  int endtime=295;
  int userPoint;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2F5%E5%88%86%E9%90%98%E5%BF%AB%E9%80%9F%E6%94%B6%E6%93%8D%E9%81%8B%E5%8B%95%20%E9%A0%90%E9%98%B2%E5%8F%97%E5%82%B7%20%E5%BE%A9%E5%8E%9F%E8%82%8C%E8%82%89%EF%BD%9C5%20MIN%20COOL%20DOWN%20-%20quick%20recovery%E3%80%90Bellysu%E6%B8%9B%E8%82%A5%E4%B8%AD%E3%80%91%20%5B720p%5D.mp4?alt=media&token=5f4909dc-ceef-4387-8705-514e026e2664',
    );

    controller.addListener(() {
      setState(() {});
    });
    controller.setLooping(true);
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  final ref = FirebaseFirestore.instance.collection('user_point');

  Future<String>getData() async {
    await ref.doc(user_email).get().then((DocumentSnapshot doc) {  //rewrite
      userPoint=doc['point'];
    });
  }
  updateUserPoint(){
    ref.doc(user_email).update({'point':userPoint+10});  //rewrite
  }

  start_timer()
  {
    video_timer=Timer.periodic(Duration(seconds: 1), (Timer t) {
      video_time=video_time+1;
      print(video_time.toString());
      if(video_time==endtime)
      {
        setState(() {
          reward=true;
        });
        final snackBar = SnackBar(
          content: const Text('已達到運動時間了喔!!獎勵10點~'),
          action: SnackBarAction(
            label: '了解~',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        video_timer.cancel();
        updateUserPoint();
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
  Widget build(BuildContext context) => Column(
    children: [
      AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            VideoPlayer(controller),
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
            // VideoControlsWidget(controller: controller,endtime: endtime,),
                CustomVideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  timestamps: widget.timestamps,
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          CustomControlsWidget(
            controller: controller,
            timestamps: widget.timestamps,
          ),
          SizedBox(height: 12),
        ],
      );
}
