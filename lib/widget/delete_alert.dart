import 'package:book_reading/theme.dart';
import 'package:book_reading/widget/primary_button.dart';
import 'package:flutter/material.dart';

class DeleteAlert extends StatefulWidget {
  final VoidCallback onTapDelete;
  final String? title;
  final String? description;
  final String? confirmationText;
  final bool useIcon;
  const DeleteAlert({
    super.key,
    required this.onTapDelete,
    this.title,
    this.description,
    this.confirmationText,
    this.useIcon = true,
  });

  @override
  State<DeleteAlert> createState() => _DeleteAlertState();
}

class _DeleteAlertState extends State<DeleteAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: whiteColor,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: IntrinsicHeight(
        child: Column(
          children: [
            widget.useIcon
                ? CircleAvatar(
                    backgroundColor: Colors.red.withOpacity(0.3),
                    child: const Icon(
                      Icons.error,
                      size: 30,
                      color: Colors.red,
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.title ?? "Hapus Buku",
              style: primaryTextStyle.copyWith(
                fontWeight: semibold,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.description ??
                  "Anda yakin untuk menghapus buku ini?\n Tindakan ini tidak dapat dikembalikan",
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                fontSize: 12,
                color: blackColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      elevation: 0,
                      color: transparentColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Batal",
                        style: primaryTextStyle.copyWith(
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      elevation: 0,
                      color: Colors.red.withOpacity(0.8),
                      onPressed: widget.onTapDelete,
                      child: Text(
                        widget.confirmationText ?? "Hapus",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
