

import 'package:education_app/core/res/colours.dart';
import'package:flutter/material.dart';
class RoundedButton extends StatelessWidget {
  const  RoundedButton({
    required this.label,
    required this.onPressed,
    this.buttoncolor,
    this.labelcolor,
        super.key,});

        final String label;
        final VoidCallback? onPressed;
        final Color? buttoncolor;
        final Color? labelcolor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttoncolor?? Colours.primaryColour,
        foregroundColor: labelcolor ?? Colors.white,
      ),
      onPressed: onPressed, 
      child: Text(label),
      );
  }
}