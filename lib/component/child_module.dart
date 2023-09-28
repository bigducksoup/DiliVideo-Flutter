

import 'package:flutter/material.dart';



class ChildPost extends StatefulWidget {
  const ChildPost({super.key, required this.postId});


  final String postId;

  @override
  State<ChildPost> createState() => _ChildPostState();
}

class _ChildPostState extends State<ChildPost> {

  


  @override
  void initState() {
    super.initState();
    
  }


  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,child: Center(child: CircularProgressIndicator()),);
  }
}