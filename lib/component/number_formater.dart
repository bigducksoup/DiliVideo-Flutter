import 'package:flutter/material.dart';


///
///大数转换 100001 -> 10W+ 1000001->1M+
///
class NumberConverter extends StatelessWidget {
  final int number;

  const NumberConverter({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    String convertedNumber = number.toString();

    if (number >= 10000 && number < 100000) {
      convertedNumber = '${(number ~/ 10000)}W+';
    } else if (number >= 1000000) {
      convertedNumber = '${(number ~/ 1000000)}M+';
    }

    return Text(convertedNumber);
  }
}