// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:book_reading/page/book/create_book_page.dart';
import 'package:book_reading/theme.dart';
import 'package:flutter/material.dart';

import 'package:book_reading/model/book_model.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  const BookCard({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("INI ADALAH ID BUKU ${book.id}");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateBookPage(book: book)));
      },
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFF4E4),
            // border: Border.all(
            //     // width: 1.0,
            //     // color: primaryColor500,
            //     ),
            boxShadow: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 24,
                offset: Offset(0, 11),
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                  fontWeight: semibold,
                  color: primaryColor800,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: book.pages.isNotEmpty
                    ? Text(
                        book.pages.first,
                        textAlign: TextAlign.justify,
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle.copyWith(
                          color: subtitle1TextColor,
                          fontWeight: regular,
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
