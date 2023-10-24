import 'package:flutter/material.dart';
import 'package:mars_study_case/layers/presentation/provider/select_photo_provider.dart';
import 'package:mars_study_case/layers/presentation/provider/video_preview_provider.dart';
import 'package:mars_study_case/layers/presentation/view/select_photo/select_photo_view.dart';
import 'package:mars_study_case/layers/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:splash_view/source/presentation/presentation.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SelectPhotoProvider()),
    ChangeNotifierProvider(create: (context) => VideoPlayerProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashView(
        logo: FlutterLogo(),
        done: Done(const SelectPhotoView()),
      ),
    );
  }
}
