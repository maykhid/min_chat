import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  final String text;
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(text, style: GoogleFonts.lato(fontSize: 15),),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 240, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 12,
          ), // Set border radius here
        ),
        backgroundColor:
            color ?? Colors.red, // Change the color for Google button
      ),
    );
  }
}
