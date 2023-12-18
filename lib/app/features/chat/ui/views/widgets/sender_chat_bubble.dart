
import 'package:flutter/material.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/utils/datetime_x.dart';

class SenderChatBubble extends StatelessWidget {
  const SenderChatBubble({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // height: 56,
            // width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            decoration: const BoxDecoration(
              // color: Colors.black12,
              color: Colors.black87,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.message,
                  style: const TextStyle(color: Colors.white),
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
                Text(
                  message.timestamp!.formatToTime,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
