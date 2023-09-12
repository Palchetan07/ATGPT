import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender})
      : super(key: key);
  final String text;
  final String sender;

//  CrossAxisAlignment alignment =
  //sender == "User" ? CrossAxisAlignment.end : CrossAxisAlignment.start;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration:  BoxDecoration(borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              color: Colors.redAccent,
            ),
            child: Text(sender),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: sender == "User" ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            text,
            style: TextStyle(
                color: sender == "User" ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
