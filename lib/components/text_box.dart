import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String section;
  final Function ()? onPressed;

  const MyTextBox({super.key, required this.text, required this.section, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20,top: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //section name
          Row(
            children: [
              Text(
                  section,
                style: const TextStyle(
                  color: Colors.grey
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.edit))
            ],
          ),

          //text
          Text(
              text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
