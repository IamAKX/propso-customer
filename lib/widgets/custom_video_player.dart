import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key, required this.videoUrl});
  final String videoUrl;
  static const String routePath = '/videoViewer';

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final PodPlayerController controller;
  @override
  void initState() {
    debugPrint(widget.videoUrl);
    controller = PodPlayerController(
      podPlayerConfig: PodPlayerConfig(
        autoPlay: true,
      ),
      playVideoFrom: PlayVideoFrom.network(
        widget.videoUrl,
      ),
    )..initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: PodVideoPlayer(
        controller: controller,
        matchFrameAspectRatioToVideo: true,
        matchVideoAspectRatioToFrame: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
