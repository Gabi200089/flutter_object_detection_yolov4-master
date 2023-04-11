import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/body_shape/widget/video_controls_widget.dart';
import 'package:object_detection/body_shape/widget/video_progress_indicator.dart';
import 'package:object_detection/global.dart';
import 'package:video_player/video_player.dart';

import 'custom_controls_widget.dart';

class VideoPlayerWidget3 extends StatefulWidget {
  final List<Duration> timestamps;

  const VideoPlayerWidget3({
    @required this.timestamps,
    Key key,
  }) : super(key: key);
  @override
  _VideoPlayerWidget3State createState() => _VideoPlayerWidget3State();
}

class _VideoPlayerWidget3State extends State<VideoPlayerWidget3> {
  // VideoPlayerController controller;
  int endtime=1190;
  int userPoint;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2F20%E5%88%86%E9%92%9F%E4%BD%8E%E9%9A%BE%E5%BA%A6%E6%9C%89%E6%B0%A7%E8%BF%90%E5%8A%A8%20_%20%E8%85%B0%E8%85%BF_%20%E7%87%83%E8%84%82_%20%E6%97%A0%E5%B7%A5%E5%85%B7%E9%AB%98%E4%BD%93%E8%84%82%E5%A4%A7%E5%9F%BA%E6%95%B0%E5%85%A5%E9%97%A8%E9%80%82%E5%90%88%E3%80%90%E5%91%A8%E5%85%AD%E9%87%8EZoey%E3%80%91%20%5B720p%5D.mp4?alt=media&token=56ecf9d7-64f7-4a1e-8beb-1f2e89a0ab8b',
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
