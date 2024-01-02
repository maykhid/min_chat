
import 'package:flutter/material.dart';

class ChatTimePill extends StatelessWidget {
  const ChatTimePill({
    required this.time,
    super.key,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
        borderRadius: const BorderRadiusDirectional.all(
          Radius.circular(5),
        ),
      ),
      child: Text(
        time,
        style: const TextStyle(fontSize: 12, color: Colors.white),
        // style: AppTextStyles.smallTextStyleGrey,
      ),
    );
  }
}
