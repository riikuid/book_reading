// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:book_reading/service/book_firebase.dart';
import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/book_page_widget.dart';
import 'package:book_reading/widget/delete_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:book_reading/model/book_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class CreateBookPage extends StatefulWidget {
  final String bookId;
  const CreateBookPage({
    super.key,
    required this.bookId,
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
  String errorText = "Failed to delete book";
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
            BookFirebase.addPageToBook(widget.bookId, text);
            _isLoading = false;
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
    bool result = await flutterTts.speak(text);
    if (result) {
      setState(() {
        isPlaying = false;
      });
    }
    // setState(() {
    //   isPlaying = false;
    // });
    // if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _start(List<String> listText) async {
    setState(() {
      isPlaying = true;
    });
    String text = listText.join("\n");
    await flutterTts.speak(text);
    // setState(() {
    //   isPlaying = false;
    // });
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

  @override
  void initState() {
    // oldPages = widget.book.pages;
    // newPages = List.from(oldPages);
    flutterTts.setLanguage("id-ID");
    // addTextForTts();
    super.initState();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  // void addTextForTts() {
  //   if (widget.book.pages.isNotEmpty) {
  //     for (PageModel page in widget.book.pages) {
  //       forTts.add(page.text);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("books")
                  .doc(widget.bookId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor500,
                      ),
                    ),
                  );
                }
                final data = snapshot.data?.data();
                if (data != null) {
                  BookModel book = BookModel.fromJson(data, widget.bookId);
                  forTts = book.pages
                      .map(
                        (e) => e.text,
                      )
                      .toList();
                  return Scaffold(
                    backgroundColor: greyBackgroundColor,
                    appBar: AppBar(
                      backgroundColor: primaryColor400,
                      surfaceTintColor: Colors.transparent,
                      title: Text(
                        book.title,
                        style: primaryTextStyle.copyWith(
                          color: whiteColor,
                          fontWeight: semibold,
                          fontSize: 18,
                        ),
                      ),
                      leading: IconButton(
                        onPressed: () {
                          if (book.pages.isEmpty) {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!

                              builder: (BuildContext context) {
                                return DeleteAlert(
                                  useIcon: false,
                                  title: "Buku Kosong",
                                  confirmationText: "Keluar",
                                  description:
                                      "Buku akan otomatis terhapus apabila\n anda keluar",
                                  onTapDelete: () async {
                                    await BookFirebase.deleteBookFromFirestore(
                                      bookId: book.id,
                                      errorCallback: (p0) => setState(
                                        () {
                                          errorText = p0;
                                        },
                                      ),
                                    ).then((value) {
                                      if (value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        Fluttertoast.showToast(msg: errorText);
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                          // size: 20,
                        ),
                      ),
                    ),
                    body: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        ...book.pages.map((page) => BookPageWidget(
                              pageNumber: (
                                book.pages.indexWhere((element) =>
                                        element.hashCode == page.hashCode) +
                                    1,
                              ).toString(),
                              page: page.text,
                              onSpeakButtonPressed: () async {
                                setState(() {
                                  isPlaying = true;
                                });
                                await _speak(page.text);
                              },
                              onDeleteButtonPressed: () async {
                                await BookFirebase.removePageFromBook(
                                    widget.bookId, page.id);
                                setState(() {});
                              },
                            ))
                      ],
                    ),
                    floatingActionButton: Wrap(
                      //will break to another line on overflow
                      direction: Axis
                          .vertical, //use vertical to show  on vertical axis
                      children: <Widget>[
                        Semantics(
                          label: isPlaying
                              ? "Mulai Baca Buku"
                              : "Berhenti Baca Buku",
                          child: Visibility(
                            visible: book.pages.isNotEmpty,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: FloatingActionButton(
                                heroTag: "MULAI BACA",
                                onPressed: () {
                                  isPlaying ? _stop() : _start(forTts);
                                },
                                backgroundColor: isPlaying
                                    ? primaryColor400
                                    : primaryColor100,
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
                  );
                }
                return Scaffold(
                  backgroundColor: greyBackgroundColor,
                  appBar: AppBar(
                    title: Text("Gagal"),
                  ),
                );
              }),
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
