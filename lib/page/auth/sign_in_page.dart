import 'package:book_reading/page/home_page.dart';
import 'package:book_reading/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isObscure = true;
  bool isLoading = false;
  final Uri _url = Uri.parse(
      'https://sifabel.myr.id/membership/berlangganan-aplikasi-sifabel');

  Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    userCredential.user!.updateDisplayName(
        userCredential.additionalUserInfo!.authorizationCode);

    return userCredential.user;
  }

  Future<void> _launchUrl() async {
    setState(() {
      isLoading = true;
    });
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
    setState(() {
      isLoading = false;
    });
  }

  handleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = await loginWithGoogle();
      // Navigasi ke halaman home atau lakukan sesuatu dengan user
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    user: user,
                  )),
        );
      }
    } on FirebaseAuthException catch (error) {
      print(error);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal masuk, coba lagi beberapa saat!"),
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal masuk, coba lagi beberapa saat."),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selamat Datang di",
                        style: primaryTextStyle.copyWith(
                          color: primaryColor600,
                          fontWeight: semibold,
                          fontSize: 20,
                        ),
                      ),
                      Image.asset(
                        "assets/image_logo_text.png",
                        height: 34,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Baca buku favorit anda dengan SiFabel.\nMasuk untuk mulai membaca",
                    textAlign: TextAlign.center,
                    style: primaryTextStyle.copyWith(
                      color: subtitle1TextColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset("assets/image_login2.png"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      elevation: 1,
                      fixedSize: const Size(double.infinity, 50),
                      shadowColor: primaryColor900,
                      backgroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: primaryColor100,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: handleSignIn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/icon_google.svg",
                          height: 16,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Masuk Dengan Google",
                          style: primaryTextStyle.copyWith(
                            color: primaryColor800,
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      elevation: 1,
                      fixedSize: const Size(double.infinity, 50),
                      shadowColor: primaryColor900,
                      backgroundColor: whiteColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: const Color(0xFF00415a).withOpacity(0.3),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    onPressed: _launchUrl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mulai Berlangganan",
                          style: primaryTextStyle.copyWith(
                            color: const Color(0xFF00415a),
                            fontWeight: bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: _launchUrl,
                  //   child: Text(
                  //     'Berlangganan',
                  //     style: primaryTextStyle.copyWith(
                  //       fontSize: 10,
                  //       color: const Color(0xFF00415a),
                  //       fontWeight: medium,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryColor500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
