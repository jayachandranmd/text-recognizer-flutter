import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_recognition/screens/loading_screen.dart';

import '../widgets/image_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  String scannedText = "";
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource imgSource) async {
    final pickedFile = await _picker.pickImage(source: imgSource);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
    cropImage();
  }

  Future<void> cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              activeControlsWidgetColor: Colors.deepPurple,
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
        getRecognisedText(_croppedFile);
      }
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  void getRecognisedText(CroppedFile? image) async {
    final inputImage = InputImage.fromFilePath(image!.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _croppedFile != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DottedBorder(
                      dashPattern: const [8, 8],
                      strokeWidth: 2,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(12),
                      child:
                          Center(child: Image.file(File(_croppedFile!.path)))),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        _clear();
                      },
                      backgroundColor: Colors.deepPurple,
                      tooltip: 'Delete',
                      child: const Icon(Icons.delete),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        cropImage();
                      },
                      backgroundColor: Colors.deepPurple,
                      tooltip: 'Crop',
                      child: const Icon(Icons.crop),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        getRecognisedText(_croppedFile);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoadingScreen(
                                imageFile: _croppedFile,
                                scannedText: scannedText,
                              ),
                            ),
                            (route) => false);
                      },
                      backgroundColor: Colors.deepPurple,
                      tooltip: 'Done',
                      child: const Icon(Icons.done),
                    ),
                  ],
                )
              ],
            )
          : Column(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    pickImage(ImageSource.camera);
                  },
                  child: ImageSourceBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child:
                                Image.asset('assets/capture.png', height: 40)),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('Tap to take a photo',
                            style: TextStyle(color: Colors.grey, fontSize: 18))
                      ],
                    ),
                  ),
                )),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: ImageSourceBox(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset('assets/gallery.png', height: 40),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text('Tap to choose image\n from your gallery',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 18))
                      ],
                    )),
                  ),
                )
              ],
            ),
    );
  }
}
