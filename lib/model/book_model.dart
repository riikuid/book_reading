// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:book_reading/model/page_model.dart';

class BookModel {
  String? id;
  final String title;
  final List<PageModel> pages;
  final DateTime createdAt;

  BookModel({
    this.id,
    required this.title,
    required this.pages,
    required this.createdAt,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<PageModel>? pages,
    DateTime? createdAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
