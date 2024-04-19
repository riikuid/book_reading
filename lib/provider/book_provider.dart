// import 'package:book_reading/model/book_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BookProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Existing methods: addBook, saveBook, removeBook

//   Future<List<BookModel>> getBooksForUser() async {
//     final currentUser = _auth.currentUser;
//     if (currentUser == null) {
//       return []; // Handle case where user is not signed in
//     }

//     final userID = currentUser.uid;
//     final booksRef = _firestore.collection('books');
//     final booksQuery = booksRef.where('userId', isEqualTo: userID);
//     final querySnapshot = await booksQuery.get();

//     // print(querySnapshot.docs);
//     final books = querySnapshot.docs.map((doc) {
//       final bookData = doc.data();

//       return BookModel.fromJson(bookData, doc.id);
//     }).toList();
//     notifyListeners();

//     return books;
//   }
//   // List<BookModel> _books = [];
//   // List<BookModel> get books => _books;

//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // // Existing methods: addBook, saveBook, removeBook

//   // Future<List<BookModel>> getBooksForUser() async {
//   //   final currentUser = _auth.currentUser;
//   //   if (currentUser == null) {
//   //     return []; // Handle case where user is not signed in
//   //   }

//   //   final userID = currentUser.uid;
//   //   final booksRef = _firestore.collection('books');
//   //   final booksQuery = booksRef.where('userId', isEqualTo: userID);
//   //   final querySnapshot = await booksQuery.get();

//   //   // print(querySnapshot.docs);
//   //   final books = querySnapshot.docs.map((doc) {
//   //     final bookData = doc.data();

//   //     return BookModel.fromJson(bookData, doc.id);
//   //   }).toList();

//   //   _books = books;
//   //   notifyListeners();

//   //   return books;
//   // }

//   // void addBook(BookModel book) {
//   //   _books.add(book);
//   //   print(book);
//   //   notifyListeners();
//   // }
// }
