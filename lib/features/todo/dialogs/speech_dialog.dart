// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/features/widgets/custom_button.dart';

class SpeechToTextDialog extends StatefulWidget {
  const SpeechToTextDialog({super.key});

  @override
  State<SpeechToTextDialog> createState() => _SpeechToTextDialogState();
}

class _SpeechToTextDialogState extends State<SpeechToTextDialog> {
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Speech to Text",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Your Speech",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Start speaking and your text will appear here...",
                hintStyle: GoogleFonts.poppins(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isRecording = !_isRecording;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording
                        ? Colors.redAccent
                        : Colors.indigo,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording
                                ? Colors.redAccent
                                : Colors.indigo)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Center(
              child: Text(
                _isRecording ? "Recording..." : "Tap to Record",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: _isRecording
                      ? Colors.redAccent
                      : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
         CustomButton(
          onPress: () {
            Navigator.pop(context);
          },
          title: "Close",
          isBackgroundColor: false,
        ),
        CustomButton(
          onPress: () => Navigator.pop(context),
          title: "Save",
          isBackgroundColor: true,
        ),
      ],
    );
  }
}