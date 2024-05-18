// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:book_reading/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool? isLoading;
  final bool? isEnabled;
  final Color? color;
  final double? width;
  final double? height;
  final double? elevation;
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled,
    this.color,
    this.width,
    this.height,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: !isLoading! ? onPressed : () {},
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 1,
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
        ),
        backgroundColor: !isLoading! ? color ?? primaryColor500 : disabledColor,
        foregroundColor: primaryColor100,
        shadowColor: elevation != 0 ? null : transparentColor,
        minimumSize: Size(
          width ?? double.infinity,
          height ?? 40,
        ),
      ),
      child: !isLoading!
          ? child
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Loading",
                  style: primaryTextStyle.copyWith(
                    fontWeight: semibold,
                    fontSize: 16,
                    color: whiteColor,
                  ),
                )
              ],
            ),
    );
  }
}
