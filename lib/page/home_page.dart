// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:book_reading/model/book_model.dart';
import 'package:book_reading/model/page_model.dart';
import 'package:book_reading/page/auth/sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:book_reading/provider/book_provider.dart';
import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/book_card.dart';
import 'package:book_reading/widget/custom_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEnable = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<BookModel>> getListBooks() async {
      final booksRef = FirebaseFirestore.instance.collection('books');
      final booksQuery = booksRef.where('user_id', isEqualTo: widget.user.uid);

      final querySnapshot = await booksQuery.get();

      final List<BookModel> books = [];
      for (final doc in querySnapshot.docs) {
        final pagesQuery = await FirebaseFirestore.instance
            .collection('pages')
            .where('book_id', isEqualTo: doc.id)
            .get();

        final List<PageModel> pages = pagesQuery.docs
            .map((doc) => PageModel.fromJson(doc.data()).copyWith(id: doc.id))
            .toList();

        final bookData = doc.data();
        final book = BookModel.fromJson(bookData, doc.id);
        books.add(book);
      }

      books.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return books;
    }

    Widget listBooks() {
      return Scaffold(
        body: FutureBuilder(
          future: getListBooks(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
            return GridView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: [
                DottedBorder(
                  radius: const Radius.circular(12),
                  dashPattern: [9, 5],
                  borderType: BorderType.RRect,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: IconButton(
                        style: IconButton.styleFrom(
                          elevation: 2,
                          // fixedSize: const Size(double.infinity, double.infinity),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: primaryColor50,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: subtitle1TextColor,
                              style: BorderStyle.none,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // print(widget.user);
                          showModalBottomSheet<void>(
                            shape: const ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return CustomBottomSheet();
                            },
                          );
                        },
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Buat Kelompok\nBuku Baru",
                              textAlign: TextAlign.center,
                              style: primaryTextStyle.copyWith(
                                fontWeight: regular,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  border: Border.all(
                                    width: 1.5,
                                    color: primaryColor500,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  weight: 2,
                                  color: primaryColor500,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                ...snapshot.data!.map((book) => BookCard(book: book))
              ],
            );
          },
        ),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: greyBackgroundColor,
      //   actions: [
      //     GestureDetector(
      //       onTap: () async {
      //         await FirebaseAuth.instance.signOut();
      //         await GoogleSignIn().signOut();
      //       },
      //       child: const Text(
      //         "Logout",
      //       ),
      //     )
      //   ],
      //   title: Column(
      //     children: [
      //       Text(widget.user.providerData.first.displayName ?? "Tidak ada"),
      //     ],
      //   ),
      // ),
      backgroundColor: greyBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          // padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          left: 20,
          right: 20,
          top: MediaQuery.of(context).padding.top + 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hai ${widget.user.providerData.first.displayName!.split(" ").first},",
                      style: primaryTextStyle.copyWith(
                        fontWeight: bold,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Jelajahi Literasi Bersama SiFabel!",
                      style: primaryTextStyle.copyWith(
                          fontSize: 12, fontWeight: regular),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      await GoogleSignIn().signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInPage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: primaryColor800,
                      semanticLabel: "Logout",
                    ))
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('books')
                    .where(
                      'user_id',
                      isEqualTo: widget.user.uid,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // var books = snapshot.data!.docs;
                  List<BookModel> books = [];
                  for (var doc in snapshot.data!.docs) {
                    var book = BookModel.fromJson(doc.data(), doc.id);
                    books.add(book);
                  }

                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    children: [
                      DottedBorder(
                        radius: const Radius.circular(12),
                        dashPattern: [9, 5],
                        borderType: BorderType.RRect,
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: IconButton(
                              style: IconButton.styleFrom(
                                elevation: 2,
                                padding: const EdgeInsets.all(20),
                                backgroundColor: primaryColor50,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: subtitle1TextColor,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                // print(widget.user);
                                showModalBottomSheet<void>(
                                  shape: const ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return CustomBottomSheet();
                                  },
                                );
                              },
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Buat Kelompok\nBuku Baru",
                                    textAlign: TextAlign.center,
                                    style: primaryTextStyle.copyWith(
                                      fontWeight: regular,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                        border: Border.all(
                                          width: 1.5,
                                          color: primaryColor500,
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        weight: 2,
                                        color: primaryColor500,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      ...books.map((book) => BookCard(book: book))
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
