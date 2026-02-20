import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPress,
    required this.title,
    required this.isBackgroundColor,
  });

  final Function onPress;
  final String title;
  final bool isBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPress(),
      style: ElevatedButton.styleFrom(
        backgroundColor: isBackgroundColor ? Colors.indigo : Colors.white,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isBackgroundColor ? Colors.white : Colors.indigo,
        ),
      ),
    );
  }
}
