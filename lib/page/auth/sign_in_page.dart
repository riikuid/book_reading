import 'package:book_reading/page/home_page.dart';
import 'package:book_reading/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // User? _user;
  bool isObscure = true;

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // void handleSignInGoogle() {
  //   if (_user == null) {
  //     try {
  //       GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  //       _auth.signInWithProvider(googleAuthProvider);
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else {
  //     print(" ini email masuk ${_user!.email}");
  //   }
  // }

  Future<User?> loginWithGoogle() async {
    final googleAcount = await GoogleSignIn().signIn();

    final googleAuth = await googleAcount?.authentication;

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

  handleSignIn() async {
    try {
      final user = await loginWithGoogle();
    } on FirebaseAuthException catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Somethign went wrong"),
        ),
      );
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: primaryTextStyle.copyWith(
                  color: primaryColor600,
                  fontWeight: semibold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "It was popularised in the 1960s with the release of Letraset sheetscontaining Lorem Ipsum.",
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                  color: subtitle1TextColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize: const Size(double.infinity, 50),
                    backgroundColor: customFieldColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    )),
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
                      "Google",
                      style: primaryTextStyle.copyWith(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "OR",
                    style: primaryTextStyle.copyWith(
                      color: subtitle1TextColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: primaryTextStyle,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  filled: true,
                  hintText: 'Email',
                  hintStyle: primaryTextStyle.copyWith(
                    color: subtitle1TextColor,
                  ),
                  fillColor: customFieldColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: primaryTextStyle,
                obscureText: isObscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                    ),
                    color: subtitle1TextColor,
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  filled: true,
                  hintText: 'Password',
                  hintStyle: primaryTextStyle.copyWith(
                    color: subtitle1TextColor,
                  ),
                  fillColor: customFieldColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Forgot Password?",
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 12,
                        color: subtitle1TextColor,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  fixedSize: const Size(double.infinity, 50),
                  backgroundColor: primaryColor500,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HomePage(),
                  //   ),
                  // );
                },
                child: Text(
                  "Log In",
                  style: primaryTextStyle.copyWith(
                    fontWeight: semibold,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
