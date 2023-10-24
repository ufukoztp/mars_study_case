import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPreviewView extends StatefulWidget {
  const VideoPreviewView({super.key, required this.videoPath});
  final String videoPath;

  @override
  createState() => _VideoPreviewViewState();
}

class _VideoPreviewViewState extends State<VideoPreviewView> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController customVideoPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((value) => setState(() {
            videoPlayerController.play();
          }));

    customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
        customVideoPlayerSettings:
            const CustomVideoPlayerSettings(showSeekButtons: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      bottomNavigationBar: ContinueButton(),
      body: SafeArea(
        child: Center(
          child: CustomVideoPlayer(
            customVideoPlayerController: customVideoPlayerController,
          ),
        ),
      ),
    );
  }
}

class ContinueButton extends StatelessWidget {
  ContinueButton({
    super.key,
  });
  final String _continue = 'Video Oluşturmaya Devam Et';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          height: 50,
          child: Center(
            child: Text(
              _continue,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    title: Text('ÖNİZLEME'),
    centerTitle: true,
  );
}
