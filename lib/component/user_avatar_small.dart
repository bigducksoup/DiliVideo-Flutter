
import 'package:flutter/material.dart';





class UserAvatarSmall extends StatelessWidget {
  const UserAvatarSmall({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundImage: NetworkImage(url),);
  }
}
