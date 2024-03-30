import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String? ocrResult;
  final picker = ImagePicker();

  Future<bool> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      return true;
    } else {
      return false;
    }
  }

  Future<String> readTextFromImageString() async {
    final inputImage = InputImage.fromFile(_image!);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image to Text'),
        ),
        body: Center(
            child: ocrResult == null ? Text('No Has Data') : Text(ocrResult!)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getImageFromGallery().then((success) {
              if (success) {
                readTextFromImageString().then((text) {
                  setState(() {
                    ocrResult = text;
                  });
                });
              } else {
                print("Gagal mengambil gambar");
              }
            });
          },
          tooltip: 'Select Image',
          child: Icon(Icons.image),
        ),
      ),
    );
  }
}
