import 'package:flutter/material.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/utils/datetime_x.dart';

class RecipientChatBubble extends StatelessWidget {
  const RecipientChatBubble({
    required this.message,
    super.key,
  });

  final BaseMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(8),
                  bottomEnd: Radius.circular(8),
                  bottomStart: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: const TextStyle(color: Colors.black),
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),

                  Padding(
                   padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      message.timestamp!.formatToTime,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
