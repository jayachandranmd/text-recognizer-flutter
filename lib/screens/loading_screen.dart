import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';

import 'text_recognizer.dart';

class LoadingScreen extends StatefulWidget {
  final CroppedFile? imageFile;
  final String? scannedText;
  const LoadingScreen(
      {Key? key, required this.imageFile, required this.scannedText})
      : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => TextRecognizerPage(
                    imageFile: widget.imageFile,
                    scannedText: widget.scannedText,
                  )),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(child: SpinKitSpinningLines(size: 140, color: Colors.white)),
    );
  }
}
