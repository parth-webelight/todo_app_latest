// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/features/todo/screen/todo_list_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateToHome(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const TodoListScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _navigateToHome(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.indigo,
              size: 110,
            ),
            const SizedBox(height: 20),
            Text(
              "Todo App",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.indigo.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Stay Organized, Stay Productive ",
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.indigo.shade400,
              ),
            ),
            const SizedBox(height: 100),
            LoadingAnimationWidget.fallingDot(color: Colors.indigo, size: 50),
          ],
        ),
      ),
    );
  }
}
