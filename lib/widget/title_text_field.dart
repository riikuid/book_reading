import 'package:book_reading/theme.dart';
import 'package:flutter/material.dart';

class TitleTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  const TitleTextField({super.key, required this.controller, this.onChanged});

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  bool showError = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLength: 25,
      keyboardType: TextInputType.name,
      maxLines: 1,
      decoration: InputDecoration(
        isDense: true, // Added this
        counterText: "",
        contentPadding: const EdgeInsets.all(15),
        hintText: 'Masukan Judul Buku',
        errorText: showError ? null : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        errorBorder: OutlineInputBorder(
          // borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor600, width: 2.0),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      style: primaryTextStyle.copyWith(
        fontSize: 14.0,
        // height: 1.5, // Tinggi baris ganda untuk mempertahankan tinggi 50
      ),
      onChanged: widget.onChanged,
    );
  }
}
