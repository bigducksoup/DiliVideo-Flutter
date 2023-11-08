import 'package:flutter/material.dart';

class UserAvatarSmall extends StatelessWidget {
  const UserAvatarSmall({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.size, required this.url, this.borderColor});

  final double? size;

  final String url;

  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    double SIZE = size ?? 20;

    return Container(
      width: SIZE * 2,
      height: SIZE * 2,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url),fit: BoxFit.cover),
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: borderColor??Colors.transparent)
      ),
    );
  }
}
