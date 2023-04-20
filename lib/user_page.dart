import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  String _userId = '';


  @override
  void initState() {
    
    _userId = Get.parameters['userId']!;

    print(_userId);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}