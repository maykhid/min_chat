import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomCircularIconButton extends StatelessWidget {
  const CustomCircularIconButton({
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.size,
    this.iconColor,
    this.buttonColor,
    super.key,
  }) : assert(
          onPressed != null || onLongPress != null,
          'At least one of onPressed or onLongPress must be initialized',
        );

  final void Function()? onPressed;
  final void Function()? onLongPress;
  final IconData icon;
  final Size? size;
  final Color? iconColor;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size?.height ?? 40,
      width: size?.width ?? 40,
      decoration: BoxDecoration(
        color: buttonColor ?? Colors.black,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          child: FaIcon(
            icon,
            size: 20,
            color: iconColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
