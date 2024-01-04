import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {

  final String text;
  final String user;
  final String time;

  const Comment(
      {
        super.key,
        required this.text,
        required this.user,
        required this.time
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  const Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(4),
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //username and time
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  user,
                style: const TextStyle(
                    color: Color(0xff004252)
                ),
              ),
              const Text(
                  " • ",
                style: TextStyle(
                    color: Color(0xff004252)
                ),
              ),
              Text(
                  time,
                style: const TextStyle(
                    color: Color(0xff004252),
                ),
              ),
            ],
          ),

          //Comment text
          Text(
            text,
            style: const TextStyle(
                color: CupertinoColors.black
            ),
          ),
        ],
      ),
    );
  }
}
