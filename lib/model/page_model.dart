// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final String id;
  final String text;

  const PageModel({
    required this.id,
    required this.text,
  });

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

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'],
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PageModel.fromJson(String source) =>
      PageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [id, text];
}
