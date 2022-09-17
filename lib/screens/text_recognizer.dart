import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:text_recognition/utils/api_key.dart';
import 'hidden_drawer.dart';

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
  List? finalList;
  String? finalString;
  bool isLoaded = false;
  bool showCorrectedText = false;
  fetchEdits() async {
    var url = Uri.parse("https://api.sapling.ai/api/v1/edits");
    var body = json.encode({
      "key": apiKey,
      "text": widget.scannedText.toString(),
      "session_id": "Test Document UUID"
    });
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      var data = response.body;
      final decodedData = json.decode(data);
      var edits = decodedData["edits"] as List;
      setState(() {
        finalList = edits;
        isLoaded = true;
      });
    }
  }

  applyEdits(String text, List edits) {
    edits.sort((a, b) =>
        b['sentence_start'] + b['start'] - a['sentence_start'] - a['start']);
    for (dynamic edit in edits) {
      var start = edit['sentence_start'] + edit['start'];
      var end = edit['sentence_start'] + edit['end'];
      if (start > text.length || end > text.length) {
        if (kDebugMode) {
          print('Edit start:$start/$end:$end outside of bounds of text:$text');
        }
      }
      text =
          (text.substring(0, start) + edit['replacement'] + text.substring(end))
              .toString();
    }
    setState(() {
      finalString = text;
    });
  }

  @override
  void initState() {
    fetchEdits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: isLoaded
            ? Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                      child: !showCorrectedText
                                          ? Text(
                                              widget.scannedText.toString(),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )
                                          : Text(
                                              finalString.toString(),
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            )),
                                ),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showCorrectedText = true;
                                    });
                                    applyEdits(widget.scannedText.toString(),
                                        finalList!.toList());
                                    if (kDebugMode) {
                                      print(finalString);
                                    }
                                  },
                                  child: const Text('Fix text')),
                              showCorrectedText
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showCorrectedText = false;
                                        });
                                      },
                                      child: const Text('Undo'))
                                  : Container()
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HiddenDrawer()),
                                        (route) => false);
                                  },
                                  child: const Text("Done")),
                              ElevatedButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: !showCorrectedText
                                            ? widget.scannedText.toString()
                                            : finalString));
                                  },
                                  child: const Text("Copy text"))
                            ],
                          )
                        ]),
                  ),
                ),
              )
            : const Scaffold(
                backgroundColor: Colors.deepPurple,
                body: Center(
                    child:
                        SpinKitSpinningLines(size: 140, color: Colors.white)),
              ));
  }
}
