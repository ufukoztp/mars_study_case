import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mars_study_case/layers/presentation/inheriteds/select_photo_inherited.dart';
import 'package:mars_study_case/layers/presentation/view/video_preview/video_preview_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SelectPhotoProvider extends ChangeNotifier {
  int videoDuration = 10;
  double _videoProgress = 0;

  double get videoProgress => _videoProgress;

  set videoProgress(double value) {
    _videoProgress = value;
    notifyListeners();
  }

  double getFFmpegProgress(String ffmpegLogs, num videoDurationInSec) {
    final regex = RegExp("(?<=time=)[\\d:.]*");
    final match = regex.firstMatch(ffmpegLogs);
    if (match != null) {
      final matchSplit = match.group(0).toString().split(":");
      if (videoDurationInSec != 0) {
        final progress = (int.parse(matchSplit[0]) * 3600 +
                int.parse(matchSplit[1]) * 60 +
                double.parse(matchSplit[2])) /
            videoDurationInSec;
        double showProgress = (progress * 100);
        return showProgress;
      }
    }
    return 0;
  }

  Future<void> createVideoSessionStart(BuildContext context) async {
    List<Uint8List> images = [];
    SelectPhotoViewInherited.of(context)
        .imagePickerController
        .images
        .forEach((element) {
      images.add(element.bytes!);
    });
    await createVideoFromImages(images, context);
  }

  Future<void> createVideoFromImages(
      List<Uint8List> images, BuildContext context) async {
    ProgressDialog pd = ProgressDialog(context: context);
    videoProgress = 0;

    final tempDir = await getTemporaryDirectory();
    final videoPath =
        '${tempDir.path}/output_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final imagePaths = <String>[];

    for (int i = 0; i < images.length; i++) {
      final imagePath = '${tempDir.path}/image$i.jpeg';
      await File(imagePath).writeAsBytes(images[i]);
      imagePaths.add(imagePath);
    }
    final session = await FFmpegKit.executeAsync(
        '-framerate 2 -i ${tempDir.path}/image%d.jpeg -s 480x880 $videoPath',
        (session) async {
      final returnCode = await session.getReturnCode();
      videoDuration = await session.getDuration();

      if (ReturnCode.isSuccess(returnCode)) {
        /// When sucess
        await _videoCreatedSuccess(videoPath, pd, context);
      } else if (ReturnCode.isCancel(returnCode)) {
        /// When cancel
      }
    }, (Log log) {
      _logCallBack(pd, log);
    }, (Statistics statistics) {});
  }

  void _logCallBack(ProgressDialog pd, Log log) {
    pd.close();
    final progress = getFFmpegProgress(log.getMessage(), videoDuration);
    if (progress != 0) {
      ///Perform your logic here to show the progress
      videoProgress = progress;
    }
    pd.show(msg: 'Creating Video $videoProgress');
    notifyListeners();
  }

  Future<void> _videoCreatedSuccess(
      String videoPath, ProgressDialog pd, BuildContext context) async {
    await GallerySaver.saveVideo(videoPath);
    pd.close();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video saved to gallery'),
      ),
    );
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VideoPreviewView(
              videoPath: videoPath,
            )));
  }
}
