import 'package:book_reading/model/book_model.dart';
import 'package:book_reading/page/book/create_book_page.dart';
import 'package:book_reading/service/book_firebase.dart';
import 'package:book_reading/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    super.key,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  TextEditingController bookTitleController = TextEditingController();
  // Mendapatkan instance FirebaseAuth
  FirebaseAuth auth = FirebaseAuth.instance;

  // Mendapatkan detail pengguna yang sedang login
  late User? user = auth.currentUser;

  bool isEnable = false;
  bool _isLoading = false;

  @override
  void dispose() {
    bookTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context,
        StateSetter setModalState /*You can rename this!*/) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buat Buku Baru',
                      style: primaryTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semibold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.close,
                  size: 20,
                  color: subtitle1TextColor,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: bookTitleController,
              maxLength: 25,
              keyboardType: TextInputType.name,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true, // Added this
                counterText: "",
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Masukan Judul Buku',
                errorText: bookTitleController.text.isEmpty ? null : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
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
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setModalState(() {
                    isEnable = true;
                  });
                } else {
                  setModalState(() {
                    isEnable = false;
                  });
                }
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Maksimal 25 Abjad',
              style: primaryTextStyle.copyWith(
                  fontSize: 12, fontWeight: regular, color: subtitle1TextColor),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEnable ? primaryColor500 : disabledColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: isEnable
                    ? () async {
                        if (bookTitleController.text.isEmpty) {
                          // setState(() {
                          //   showError = true;
                          // });
                        } else {
                          setModalState(() {
                            _isLoading = true;
                          });
                          BookModel newbook =
                              await BookFirebase.addBookToFirestore(
                            bookTitleController.text,
                            user!.uid,
                          );
                          setModalState(() {
                            _isLoading = false;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateBookPage(bookId: newbook.id),
                              ));
                          // setState(() {
                          //   var showError = false;
                          // });
                          // Navigasi ke halaman berikutnya
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CreateBookPage(
                          //       book: BookModel(
                          //         id: "",
                          //         title: bookTitleController.text,
                          //         pages: [],
                          //         updatedAt: DateTime.now(),
                          //         userId:
                          //             FirebaseAuth.instance.currentUser!.uid,
                          //       ),
                          //     ),
                          //   ),
                          // );
                        }
                      }
                    : () {},
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        "BUAT BUKU",
                        style: primaryTextStyle.copyWith(
                          color: whiteColor,
                          fontWeight: semibold,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }
}
