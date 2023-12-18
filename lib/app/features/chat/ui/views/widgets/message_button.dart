import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({
    required this.onPressed,
    required this.icon,
    this.size,
    super.key,
  });

  final void Function()? onPressed;
  final IconData icon;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.height ?? 40,
      width: size?.width ?? 40,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          child: FaIcon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
