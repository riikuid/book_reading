import 'dart:developer';
import 'dart:io';

import 'package:book_reading/model/book_model.dart';
import 'package:book_reading/model/page_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class BookFirebase {
  static final bookRef = FirebaseFirestore.instance.collection('books');
  static Future<void> addPageToBook(String bookId, String pageText) async {
    final String pageId = Uuid().v4(); // Generate a unique ID for the page

    // Create a new PageModel instance
    final PageModel newPage = PageModel(id: pageId, text: pageText);

    // Get a reference to the book document
    final book = bookRef.doc(bookId);

    // Update the book's pages list with the new page
    await book.update({
      'pages':
          FieldValue.arrayUnion([newPage.toMap()]), // Use arrayUnion for adding
    });

    log('Page added successfully!');
  }

  static Future<void> deletePageFromBook(String bookId, String pageId) async {
    // Get a reference to the book document
    final selectedBook =
        FirebaseFirestore.instance.collection('books').doc(bookId);

    // Update the book's pages list, removing the specified page
    await selectedBook.update({
      'pages': FieldValue.arrayRemove([
        {'id': pageId}
      ]), // Use arrayRemove for removing
    });

    log('Page deleted successfully!');
  }

  static Future<void> removePageFromBook(String bookId, String pageId) async {
    // Get a reference to the book document
    final selectedBook = bookRef.doc(bookId);

    // Get the current pages of the book
    final bookSnapshot = await selectedBook.get();
    final List<dynamic> currentPages = bookSnapshot.data()?['pages'];

    // Find the index of the page to be removed
    final int pageIndexToRemove =
        currentPages.indexWhere((page) => page['id'] == pageId);

    if (pageIndexToRemove != -1) {
      // Create a copy of the current pages list
      List<dynamic> updatedPages = List.from(currentPages);

      // Remove the page from the copy
      updatedPages.removeAt(pageIndexToRemove);

      // Update the book document with the updated pages list
      await selectedBook.update({
        'pages': updatedPages,
        'updated_at': DateTime.now(), // Memperbarui updated_at
      });

      log('Page removed successfully!');
    } else {
      log('Page not found in the book!');
    }
  }

  static Future<BookModel> addBookToFirestore(
    String title,
    String userId,
  ) async {
    try {
      // Menambahkan dokumen baru dengan menggunakan metode add()
      // Menambahkan dokumen baru dengan menggunakan metode add()
      DocumentReference newDocRef = await bookRef.add({
        'title': title,
        'pages': [], // Menyediakan array kosong sebagai daftar halaman
        'updated_at': DateTime.now(),
        'user_id': userId,
        // Jika ada properti lain yang Anda inginkan, tambahkan di sini
      });

      print('Buku berhasil ditambahkan ke Firestore dengan judul: $title');

      // Membuat instance BookModel berdasarkan data yang ditambahkan ke Firestore
      BookModel newBook = BookModel(
        id: newDocRef.id, // Menggunakan id dokumen yang baru ditambahkan
        title: title,
        userId: userId,
        pages: [], // Menyediakan array kosong sebagai daftar halaman
        updatedAt: DateTime.now(),
      );

      // Mengembalikan objek BookModel yang baru dibuat
      return newBook;
    } catch (error) {
      print('Terjadi kesalahan saat menambahkan buku: $error');
      rethrow;
    }
  }

  static Future<bool> deleteBookFromFirestore({
    required String bookId,
    void Function(dynamic)? errorCallback,
  }) async {
    try {
      // Mendapatkan referensi ke dokumen buku yang akan dihapus
      DocumentReference selectedBook = bookRef.doc(bookId);

      // Menghapus dokumen buku dari Firestore
      await selectedBook.delete();

      print('Buku dengan ID $bookId berhasil dihapus dari Firestore.');
      return true;
    } on SocketException {
      errorCallback?.call("No Internet Connection");
      return false;
    } catch (error) {
      print('Terjadi kesalahan saat menghapus buku: $error');
      errorCallback?.call(error.toString());
      return false;
    }
  }
}
