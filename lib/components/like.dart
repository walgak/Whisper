import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.isLiked, this.onTap});
  final bool isLiked;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? CupertinoIcons.star_fill : CupertinoIcons.star_fill,
        color: isLiked ? Colors.yellow: Colors.grey,
      ),
    );
  }
}
