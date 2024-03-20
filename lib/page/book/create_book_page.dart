// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:book_reading/model/page_model.dart';
import 'package:book_reading/provider/book_provider.dart';
import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/book_page_widget.dart';
import 'package:flutter/material.dart';

import 'package:book_reading/model/book_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateBookPage extends StatefulWidget {
  final BookModel book;
  const CreateBookPage({
    super.key,
    required this.book,
  });

  @override
  State<CreateBookPage> createState() => _CreateBookPageState();
}

class _CreateBookPageState extends State<CreateBookPage> {
  File? _image;
  String? ocrResult;
  final picker = ImagePicker();
  bool _isLoading = false;
  FlutterTts flutterTts = FlutterTts();
  List<String> forTts = [];
  bool isPlaying = false;
  // TtsState ttsState = TtsStat.stopped;

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
    String text = recognizedText.text.replaceAll("\n", " ");
    textRecognizer.close();

    return text;
  }

  Future _speak(String text) async {
    await flutterTts.speak(text);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _start(List<String> listText) async {
    setState(() {
      isPlaying = true;
    });
    String text = listText.join("\n");
    await flutterTts.speak(text);
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    setState(() {
      isPlaying = false;
    });
    var result = await flutterTts.stop();
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _pause(String text) async {
    var result = await flutterTts.pause();
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _resume(String text) async {
    var result = await flutterTts.pause();
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  late List<PageModel> oldPages;
  late List<PageModel> newPages;

  @override
  void initState() {
    oldPages = widget.book.pages;
    newPages = List.from(oldPages);
    addTextForTts();
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void addTextForTts() {
    if (widget.book.pages.isNotEmpty) {
      for (PageModel page in widget.book.pages) {
        forTts.add(page.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BookProvider bookProvider = Provider.of<BookProvider>(context);
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: subtitle2TextColor,
            appBar: AppBar(
              title: Text(widget.book.title),
              actions: [
                TextButton(
                  onPressed: () {
                    bookProvider
                        .saveBook(widget.book.copyWith(pages: newPages));
                  },
                  child: const Text("SAVE"),
                ),
              ],
            ),
            body: ListView(padding: const EdgeInsets.all(20), children: [
              ...newPages.map((page) => BookPageWidget(
                    page: page,
                    onSpeakButtonPressed: () async {
                      await _speak(page.text);
                    },
                    onDeleteButtonPressed: () {
                      setState(() {
                        newPages.remove(page);
                        forTts.remove(page.text);
                      });
                    },
                  ))
            ]),
            floatingActionButton: Wrap(
              //will break to another line on overflow
              direction: Axis.vertical, //use vertical to show  on vertical axis
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton(
                    heroTag: "TTS",
                    onPressed: () {
                      isPlaying ? _stop() : _start(forTts);
                    },
                    backgroundColor: primaryColor100,
                    child: Icon(
                      isPlaying ? Icons.stop : Icons.play_arrow,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    heroTag: "ADD PAGE",
                    backgroundColor: primaryColor100,
                    child: const Icon(Icons.add),
                    onPressed: () async {
                      getImageFromGallery().then(
                        (success) {
                          if (success) {
                            setState(() {
                              _isLoading = true;
                            });
                            readTextFromImageString().then((text) {
                              setState(() {
                                ocrResult = text;
                                forTts.add(text);
                                newPages.add(PageModel(
                                    id: const Uuid().v4(), text: text));
                                _isLoading = false;
                              });
                              // Lakukan apapun yang diperlukan dengan teks yang diperoleh
                            });

                            // Panggil fungsi lain jika perlu
                          } else {
                            debugPrint("Gagal mengambil gambar");
                          }
                        },
                      );
                    },
                  ),
                ), //button first

                // button third

                // Add more buttons here
              ],
            ),
          ),
          _isLoading
              ? Positioned.fill(
                  child: ColoredBox(
                    color: blackColor.withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitCubeGrid(
                          color: whiteColor,
                          size: 80,
                        ),
                        Text(
                          "Loading",
                          style: primaryTextStyle.copyWith(
                            fontWeight: semibold,
                            color: whiteColor,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
