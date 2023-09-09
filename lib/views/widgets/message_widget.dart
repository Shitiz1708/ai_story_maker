import 'package:flutter/material.dart';

import 'incoming_chat.dart';
import 'my_chat.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      required this.query,
      required this.index,
      required this.type,
      required this.time,
      required this.sessionId,
      required this.isImage});

  final String text;
  final String sender;

  final String query;
  final bool isImage;
  final int index;
  final String type;
  final String sessionId;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return sender != 'You'
        ? IncomingChat(
            message: text,
            query: query,
            index: index,
          )
        : MyChat(
            message: text,
            query: query,
            type: type,
            isImage: isImage,
          );
  }
}
