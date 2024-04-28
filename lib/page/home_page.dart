import 'package:book_reading/provider/book_provider.dart';
import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/book_card.dart';
import 'package:book_reading/widget/custom_bottom_sheet.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEnable = false;
  bottomSheet(BuildContext context) {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBackgroundColor,
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, _) {
          bookProvider.books.sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
              ...bookProvider.books.map(
                (book) => BookCard(book: book),
              )
            ],
          );
        },
      ),
    );
  }
}
