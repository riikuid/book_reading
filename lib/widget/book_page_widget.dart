// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:book_reading/theme.dart';
import 'package:flutter/material.dart';

import 'package:book_reading/model/page_model.dart';

class BookPageWidget extends StatelessWidget {
  final PageModel page;
  final VoidCallback onDeleteButtonPressed;
  final VoidCallback onSpeakButtonPressed;

  const BookPageWidget({
    super.key,
    required this.page,
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
              IconButton(
                onPressed: onDeleteButtonPressed,
                icon: const Icon(Icons.delete),
              ),
              Text(
                page.text,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
