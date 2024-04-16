import 'package:book_reading/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  List<BookModel> _books = [];
  List<BookModel> get books => _books;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Existing methods: addBook, saveBook, removeBook

  Future<List<BookModel>> getBooksForUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return []; // Handle case where user is not signed in
    }

    final userID = currentUser.uid;
    final booksRef = _firestore.collection('books');
    final booksQuery = booksRef.where('userId', isEqualTo: userID);

    final querySnapshot = await booksQuery.get();
    final books = querySnapshot.docs.map((doc) {
      final bookData = doc.data();

      return BookModel.fromJson(bookData);
    }).toList();

    _books = books;
    notifyListeners();

    return books;
  }

  void addBook(BookModel book) {
    _books.add(book);
    print(book);
    notifyListeners();
  }

  // void saveBook(BookModel book) {
  //   // Cek apakah buku sudah ada dalam koleksi buku (_books) berdasarkan id
  //   final existingBookIndex =
  //       _books.indexWhere((oldBook) => oldBook.id == book.id);

  //   // Jika buku sudah ada, perbarui buku yang sudah ada dengan buku yang baru
  //   if (existingBookIndex != -1) {
  //     _books[existingBookIndex] = book;
  //   } else {
  //     // Jika buku belum ada dalam koleksi, tambahkan buku baru ke dalam koleksi
  //     addBook(book);
  //   }
  //   notifyListeners();
  // }

  void removeBook(BookModel book) {
    _books.remove(book);
    notifyListeners();
  }
}
