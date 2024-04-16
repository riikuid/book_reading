// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:book_reading/model/page_model.dart';
import 'package:book_reading/theme.dart';

class BookPageWidget extends StatelessWidget {
  final String page;
  final String pageNumber;
  final VoidCallback onDeleteButtonPressed;
  final VoidCallback onSpeakButtonPressed;

  const BookPageWidget({
    super.key,
    required this.page,
    required this.pageNumber,
    required this.onDeleteButtonPressed,
    required this.onSpeakButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 24,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor400,
                        shape: const RoundedRectangleBorder(),
                      ),
                      onPressed: onSpeakButtonPressed,
                      child: Text(
                        "Baca Halaman $pageNumber",
                        style: primaryTextStyle.copyWith(
                          color: whiteColor,
                          fontWeight: semibold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      shape: const RoundedRectangleBorder(),
                    ),
                    onPressed: onDeleteButtonPressed,
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                page,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
