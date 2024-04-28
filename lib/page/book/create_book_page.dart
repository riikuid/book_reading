// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:book_reading/model/page_model.dart';
import 'package:book_reading/provider/book_provider.dart';
import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/book_page_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:book_reading/model/book_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  void _pickedImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          'TAMBAH HALAMAN BARU',
          style: primaryTextStyle.copyWith(
            fontSize: 16,
          ),
        ),
        content: Text(
          'Ambil gambar dari',
          style: primaryTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
        actions: [
          CupertinoDialogAction(
              child: Text(
                'Kamera',
                style: primaryTextStyle.copyWith(
                  color: primaryColor700,
                ),
              ),
              onPressed: () {
                Navigator.pop(context, ImageSource.camera);
                flutterTts.speak(
                  "Arahkan Kamera sejajar dengan buku yang ingin di baca, Gunakan kangan kiri untuk mengukur",
                );
              }),
          CupertinoDialogAction(
            child: Text(
              'Galeri',
              style: primaryTextStyle.copyWith(
                color: primaryColor700,
              ),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) return;
      setState(() => _image = File(pickedFile.path));

      setState(() {
        _isLoading = true;
      });
      readTextFromImageString().then((text) {
        if (text.isEmpty) {
          Fluttertoast.showToast(
            msg: "Tidak ada kata yang terbaca",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0,
          );
          setState(() {
            _isLoading = false;
          });
        } else {
          setState(() {
            ocrResult = text;
            forTts.add(text);
            newPages.add(PageModel(id: const Uuid().v4(), text: text));
            _isLoading = false;
            print('oldPages: $oldPages');
            print('newPages: $newPages');
            print("isDiff: ${newPages == oldPages}");
          });
        }
      });
    });
  }

  Future<bool> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      return true;
    } else {
      return false;
    }
  }

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
  // late bool isDiff;

  @override
  void initState() async {
    oldPages = widget.book.pages;
    newPages = List.from(oldPages);
    bool isLanguageAvailable = await flutterTts.isLanguageAvailable("id-ID");
    if (isLanguageAvailable) {
      flutterTts.setLanguage("id-ID");
    }
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
    bool isDiff = !const IterableEquality().equals(oldPages, newPages);

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: greyBackgroundColor,
            appBar: AppBar(
              title: Text(widget.book.title),
              actions: [
                isDiff
                    ? TextButton(
                        onPressed: () {
                          bookProvider
                              .saveBook(widget.book.copyWith(pages: newPages));
                          setState(() {
                            oldPages = List.from(newPages);
                          });
                        },
                        child: const Text("SIMPAN"),
                      )
                    : SizedBox(),
              ],
            ),
            body: ListView(padding: const EdgeInsets.all(20), children: [
              ...newPages.map((page) => BookPageWidget(
                    pageNumber: (newPages.indexWhere((element) =>
                                element.hashCode == page.hashCode) +
                            1)
                        .toString(),
                    page: page,
                    onSpeakButtonPressed: () async {
                      await _speak(page.text);
                      setState(() {
                        isPlaying = true;
                      });
                    },
                    onDeleteButtonPressed: () {
                      setState(() {
                        newPages.remove(page);
                        forTts.remove(page.text);
                        print('oldPages: $oldPages');
                        print('newPages: $newPages');
                        print("isDiff: ${newPages == oldPages}");
                      });
                    },
                  ))
            ]),
            floatingActionButton: Wrap(
              //will break to another line on overflow
              direction: Axis.vertical, //use vertical to show  on vertical axis
              children: <Widget>[
                Semantics(
                  label: isPlaying ? "Mulai Baca Buku" : "Berhenti Baca Buku",
                  child: Visibility(
                    visible: newPages.isNotEmpty,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        heroTag: "MULAI BACA",
                        onPressed: () {
                          isPlaying ? _stop() : _start(forTts);
                        },
                        backgroundColor:
                            isPlaying ? primaryColor400 : primaryColor100,
                        child: Icon(
                          isPlaying ? Icons.stop : Icons.play_arrow,
                          color: isPlaying ? whiteColor : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Semantics(
                    label: "Tombol Tambah Halaman Baru",
                    child: FloatingActionButton(
                      heroTag: "TAMBAH HALAMAN",
                      backgroundColor: primaryColor100,
                      child: const Icon(Icons.add),
                      onPressed: () async {
                        _pickedImage();
                      },
                    ),
                  ),
                ), //button first
              ],
            ),
          ),
          _isLoading
              ? Scaffold(
                  backgroundColor: blackColor.withOpacity(0.5),
                  body: SizedBox(
                    width: screenSize.width,
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
