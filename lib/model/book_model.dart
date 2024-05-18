// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:book_reading/model/page_model.dart';

class BookModel {
  final String id;
  final String title;
  final List<PageModel> pages;
  final DateTime updatedAt;
  final String userId;

  BookModel({
    required this.id,
    required this.title,
    required this.userId,
    required this.pages,
    required this.updatedAt,
  });

  BookModel copyWith({
    String? id,
    String? title,
    List<PageModel>? pages,
    DateTime? updatedAt,
    String? userId,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pages: pages ?? this.pages,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json, String id) {
    Timestamp timestamp = json["updated_at"];
    DateTime updatedAt = timestamp.toDate();

    return BookModel(
      id: id,
      title: json["title"],
      pages: json['pages'] != null
          ? json['pages']
              .map<PageModel>((item) => PageModel.fromJson(item))
              .toList()
          : [],
      updatedAt: updatedAt,
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'pages': pages.map((x) => x.toMap()).toList(),
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'user_id': userId,
    };
  }

  String toJson() => json.encode(toMap());
}
