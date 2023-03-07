import 'package:flutter/material.dart';


class RecommandList extends StatefulWidget {
  const RecommandList({super.key});

  @override
  State<RecommandList> createState() => _RecommandListState();
}

class _RecommandListState extends State<RecommandList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(itemBuilder:(context, index) {
            return FlutterLogo();
          }),
      ),
    );
  }
}