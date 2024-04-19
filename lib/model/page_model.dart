// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PageModel {
  final String id;
  final String text;

  PageModel({
    required this.id,
    required this.text,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json["id"],
      text: json["text"],
    );
  }

  PageModel copyWith({
    String? id,
    String? text,
  }) {
    return PageModel(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
    };
  }

  String toJson() => json.encode(toMap());

}
