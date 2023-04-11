import 'package:flutter/material.dart';
import 'package:object_detection/body_shape/widget/video_controls_widget.dart';
import 'package:object_detection/body_shape/widget/video_progress_indicator.dart';
import 'package:video_player/video_player.dart';

import 'custom_controls_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final List<Duration> timestamps;

  const VideoPlayerWidget({
    @required this.timestamps,
    Key key,
  }) : super(key: key);
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/imagetotextconverterapp-3953b.appspot.com/o/exercise_video%2F10%E5%88%86%E9%90%98%E5%85%A8%E8%BA%AB%E7%87%83%E8%84%82%E9%81%8B%E5%8B%95%20TABATA%20%E7%84%A1%E8%B7%B3%E8%BA%8D%20%E7%84%A1%E5%99%AA%E9%9F%B3%20_%2010%20MIN%20TABATA-full%20body%20fat%20burn%E3%80%90Bellysu%E6%B8%9B%E8%82%A5%E4%B8%AD%E3%80%91%20%5B720p%5D.mp4?alt=media&token=082bf226-c8fd-4af4-8bf2-5a2b2fe69cee',
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

  @override
  Widget build(BuildContext context) => Column(
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                VideoPlayer(controller),
                VideoControlsWidget(controller: controller),
                CustomVideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  timestamps: widget.timestamps,
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          CustomControlsWidget(
            controller: controller,
            timestamps: widget.timestamps,
          ),
          SizedBox(height: 12),
        ],
      );
}
