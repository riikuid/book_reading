import 'package:book_reading/model/book_model.dart';
import 'package:book_reading/page/book/create_book_page.dart';
import 'package:book_reading/provider/book_provider.dart';
import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BookProvider bookProvider =
        Provider.of<BookProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: greyBackgroundColor,
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, _) {
          bookProvider.books.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return GridView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                    style: IconButton.styleFrom(
                        fixedSize: const Size(40, 40),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: primaryColor50,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        )),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateBookPage(
                            book: BookModel(
                              id: const Uuid().v4(),
                              title: "Sifabel_${DateTime.now()}",
                              pages: [],
                              createdAt: DateTime.now(),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: primaryColor500,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "New Book",
                          style: primaryTextStyle.copyWith(
                              fontWeight: semibold, color: primaryColor500),
                        ),
                      ],
                    )),
              ),
              ...bookProvider.books.map((book) => BookCard(book: book))
            ],
          );
        },
      ),
    );
  }
}
