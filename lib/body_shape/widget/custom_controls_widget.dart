import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomControlsWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final List<Duration> timestamps;

  const CustomControlsWidget({
    @required this.controller,
    @required this.timestamps,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(Icon(Icons.fast_rewind,size: 40,), rewindToPosition),
            SizedBox(width: 12),
            buildButton(Icon(Icons.replay_5,size: 40,), rewind5Seconds),
            SizedBox(width: 12),
            buildButton(Icon(Icons.forward_5,size: 40), forward5Seconds),
            SizedBox(width: 12),
            buildButton(Icon(Icons.fast_forward,size: 40), forwardToPosition),
          ],
        ),
      );

  Widget buildButton(Widget child, Function onPressed) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: CircleBorder(),
      padding: EdgeInsets.all(5),
      primary: Color(0xffF1D621), // <-- Button color
    ),
    child: child,
    onPressed: onPressed,
  );

  Future rewindToPosition() async {
    if (timestamps.isEmpty) return;
    Duration rewind(Duration currentPosition) => timestamps.lastWhere(
          (element) => currentPosition > element + Duration(seconds: 2),
          orElse: () => Duration.zero,
        );

    await goToPosition(rewind);
  }

  Future forwardToPosition() async {
    if (timestamps.isEmpty) return;
    Duration forward(Duration currentPosition) => timestamps.firstWhere(
          (position) => currentPosition < position,
          orElse: () => Duration(days: 1),
        );

    await goToPosition(forward);
  }

  Future forward5Seconds() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));

  Future rewind5Seconds() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = await controller.position;
    final newPosition = builder(currentPosition);

    await controller.seekTo(newPosition);
  }
}
