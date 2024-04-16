// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final List<String> pages;
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
    List<String>? pages,
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

  factory BookModel.fromJson(Map<String, dynamic> json) {
    // Mengonversi Timestamp menjadi DateTime
    Timestamp timestamp = json["updated_at"];
    DateTime updatedAt = timestamp.toDate();

    return BookModel(
      id: json["title"],
      title: json["title"],
      pages: List<String>.from(json["pages"] ?? []),
      updatedAt: updatedAt,
      userId: json["user_id"],
    );
  }
}
