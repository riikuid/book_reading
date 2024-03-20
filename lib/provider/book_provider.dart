import 'package:book_reading/model/book_model.dart';
import 'package:book_reading/model/page_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BookProvider extends ChangeNotifier {
  List<BookModel> _books = [];

  List<BookModel> get books => _books;

  void addBook(BookModel book) {
    _books.add(book);
    print(book);
    notifyListeners();
  }

  void saveBook(BookModel book) {
    // Cek apakah buku sudah ada dalam koleksi buku (_books) berdasarkan id
    final existingBookIndex =
        _books.indexWhere((oldBook) => oldBook.id == book.id);

    // Jika buku sudah ada, perbarui buku yang sudah ada dengan buku yang baru
    if (existingBookIndex != -1) {
      _books[existingBookIndex] = book;
    } else {
      // Jika buku belum ada dalam koleksi, tambahkan buku baru ke dalam koleksi
      addBook(book);
    }
    notifyListeners();
  }

  void removeBook(BookModel book) {
    _books.remove(book);
    notifyListeners();
  }
}
