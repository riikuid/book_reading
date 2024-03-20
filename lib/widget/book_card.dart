// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:book_reading/model/page_model.dart';
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
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateBookPage(book: book)));
      },
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: primaryTextStyle.copyWith(
                  fontWeight: semibold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: book.pages.isNotEmpty
                    ? Text(
                        book.pages.first.text,
                        textAlign: TextAlign.justify,
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle.copyWith(
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
