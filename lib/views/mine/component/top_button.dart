import 'package:flutter/material.dart';

import '../../../theme/colors.dart';


class TopButton extends StatelessWidget {
  const TopButton({super.key});

    static const List<Widget> _buttonlist = [
    // Icon(
    //   Icons.scanner_outlined,
    //   size: 30,
    //   color: Colors.white,
    //   weight: 1,
    // ),
    // SizedBox(
    //   width: 20,
    // ),
    // Icon(
    //   Icons.adobe,
    //   size: 30,
    //   color: Colors.white,
    // ),
    // SizedBox(
    //   width: 20,
    // ),
    // Icon(
    //   Icons.wb_sunny_outlined,
    //   size: 30,
    //   color: Colors.white,
    // )
  ];

  @override
  Widget build(BuildContext context) {
    return           Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            height: 100,
            color: maindarkcolor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _buttonlist),
                )
              ],
            ),
          );
  }
}