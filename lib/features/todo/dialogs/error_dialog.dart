import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/widgets/custom_button.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Error",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      content: Text(message, style: GoogleFonts.poppins()),
      actions: [
        CustomButton(
          onPress: () => Navigator.pop(context),
          title: "Okay",
          isBackgroundColor: true,
        ),
      ],
    );
  }
}
