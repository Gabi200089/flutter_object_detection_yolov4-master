import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/body_shape/widget/video_controls_widget.dart';
import 'package:object_detection/body_shape/widget/video_progress_indicator.dart';
import 'package:object_detection/global.dart';
import 'package:video_player/video_player.dart';

import 'custom_controls_widget.dart';

class VideoPlayerWidget7 extends StatefulWidget {
  final List<Duration> timestamps;

  const VideoPlayerWidget7({
    @required this.timestamps,
    Key key,
  }) : super(key: key);
  @override
  _VideoPlayerWidget7State createState() => _VideoPlayerWidget7State();
}

class _VideoPlayerWidget7State extends State<VideoPlayerWidget7> {
  // VideoPlayerController controller;
  int endtime=628;
  int userPoint;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2F10%E5%88%86%E9%90%98%E7%AB%99%E7%AB%8B%E5%BC%8F%E7%87%83%E8%84%82%E9%81%8B%E5%8B%95%20%E6%97%A9%E6%99%A8%E4%BE%8B%E8%A1%8C%20%E7%84%A1%E8%B7%B3%E8%BA%8D%20_%20The%20Best%20Morning%20Workout%20Routine-no%20jumping%2C%20apartment%20friendly%E3%80%90Bellysu%E6%B8%9B%E8%82%A5%E4%B8%AD%E3%80%91%20%5B720p%5D.mp4?alt=media&token=1df4769c-4d48-4cfa-8f5a-03d47f94ca9c',
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
