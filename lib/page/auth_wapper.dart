import 'package:book_reading/page/auth/sign_in_page.dart';
import 'package:book_reading/page/home_page.dart';
import 'package:book_reading/provider/book_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Stream<User?> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Menampilkan indikator loading jika status masih menunggu
        }

        final User? user = snapshot.data;
        print("ini user:  ${snapshot.data}");

        // Mengarahkan pengguna ke halaman yang sesuai berdasarkan status login
        // if (user != null) {
        //   BookProvider().getBooksForUser();
        // }
        return user != null
            ? HomePage(
                user: user,
              )
            : const SignInPage();
      },
    );
  }
}
