// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PageModel {
  final String id;
  final String text;

  PageModel({
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
  String toString() => 'PageModel(id: $id, text: $text)';

  @override
  bool operator ==(covariant PageModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.text == text;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode;
}
