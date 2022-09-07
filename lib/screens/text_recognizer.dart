import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class TextRecognizerPage extends StatefulWidget {
  final CroppedFile? imageFile;
  final String? scannedText;
  const TextRecognizerPage(
      {Key? key, required this.imageFile, required this.scannedText})
      : super(key: key);

  @override
  State<TextRecognizerPage> createState() => _TextRecognizerPageState();
}

class _TextRecognizerPageState extends State<TextRecognizerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            const Text(
              'Photo',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              width: 400,
              child: Image.file(File(widget.imageFile!.path)),
            ),
            const SizedBox(height: 30),
            const Text(
              'Text',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
            ),
            const SizedBox(height: 20),
            DottedBorder(
                dashPattern: const [8, 8],
                strokeWidth: 2,
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 250,
                    width: 400,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.scannedText.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
