import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton(
      {super.key, required this.onPressed, this.size = 20, required this.icon});

  final Function() onPressed;

  final double? size;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: Icon(icon,size: size,));
  }
}

class IconChangeButton extends StatefulWidget {
  const IconChangeButton(
      {super.key,
      this.onPressedDefault,
      this.onPressedChanged,
      this.onPressed,
      required this.defaultIcon,
      required this.changedIcon,
      this.size = 20});

  final Function()? onPressedDefault;

  final Function()? onPressedChanged;

  final Function()? onPressed;

  final IconData defaultIcon;

  final IconData changedIcon;

  final double? size;

  @override
  State<IconChangeButton> createState() => _IconChangeButtonState();
}

class _IconChangeButtonState extends State<IconChangeButton> {
  bool _showDefault = true;

  @override
  Widget build(BuildContext context) {
    return _showDefault
        ? GestureDetector(
            onTap: () {
              widget.onPressedDefault?.call();
              widget.onPressed?.call();
              setState(() {
                _showDefault = false;
              });
            },
            child: Icon(
              widget.defaultIcon,
              size: widget.size,
            ),
          )
        : GestureDetector(
            onTap: () {
              widget.onPressedChanged?.call();
              widget.onPressed?.call();
              setState(() {
                _showDefault = true;
              });
            },
            child: Icon(
              widget.changedIcon,
              size: widget.size,
            ),
          );
  }
}
