import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final Function()? ontap;
  final String text;

  const MyButton(
      {
        super.key,
        this.ontap,
        required this.text
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xff004252),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
        ),
      ),
    );
  }
}
