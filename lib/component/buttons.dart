import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton(
      {super.key, required this.onPressed, this.size = 20, required this.icon});

  final Function() onPressed;

  final double? size;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Icon(
          icon,
          size: size,
        ));
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
      this.size = 20,
      this.defaultColor,
      this.changedColor});

  final Function()? onPressedDefault;

  final Function()? onPressedChanged;

  final Function()? onPressed;

  final IconData defaultIcon;

  final IconData changedIcon;

  final double? size;

  final Color? defaultColor;

  final Color? changedColor;

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
              color: widget.defaultColor,
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
              color: widget.changedColor,
            ),
          );
  }
}

class FaIconsButton extends StatelessWidget {
  const FaIconsButton(
      {super.key, required this.icon, required this.onPressed, this.size = 20});

  final Function() onPressed;

  final double? size;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: FaIcon(icon, size: size));
  }
}

class FilletButton extends StatefulWidget {
  const FilletButton(
      {super.key,
      this.defaultChild,
      this.changedChild,
      this.onPressed,
      this.defaultColor,
      this.changedColor,
      this.onCanceld,
      this.width,
      this.height});

  final Widget? defaultChild;

  final Widget? changedChild;

  final Function()? onPressed;

  final Function()? onCanceld;

  final Color? defaultColor;

  final Color? changedColor;

  final double? width;

  final double? height;

  @override
  State<FilletButton> createState() => _FilletButtonState();
}

class _FilletButtonState extends State<FilletButton> {
  late Color _current;

  late Widget _child;

  bool _showDefault = true;

  @override
  void initState() {
    super.initState();
    _current = widget.defaultColor ?? Colors.pink;
    _child = widget.defaultChild ?? const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 35,
      width: widget.width ?? 70,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (_showDefault) {
              _current = widget.changedColor ?? Colors.grey;
              _child = widget.changedChild ?? const SizedBox();
              _showDefault = false;
              widget.onPressed?.call();
            } else {
              _current = widget.defaultColor ?? Colors.pink;
              _child = widget.defaultChild ?? const SizedBox();
              _showDefault = true;
              widget.onCanceld?.call();
            }
          });
        },
        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(_current)),
        child: _child,
      ),
    );
  }
}

class WidgetChangeButton extends StatefulWidget {
  const WidgetChangeButton(
      {super.key,
      required this.defaultWidget,
      required this.changedWidget,
      this.showDefault = false,
      this.onClick,
      this.onCancel});

  final Widget defaultWidget;

  final Widget changedWidget;

  final bool? showDefault;

  final Function()? onClick;

  final Function()? onCancel;

  @override
  State<WidgetChangeButton> createState() => _WidgetChangeButtonState();
}

class _WidgetChangeButtonState extends State<WidgetChangeButton> {
  bool _showDefault = true;

  late Widget _current;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _showDefault = widget.showDefault ?? true;
    _current = widget.showDefault ?? true
        ? widget.defaultWidget
        : widget.changedWidget;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      if(_showDefault){
        widget.onClick?.call();
        setState(() {
          _current = widget.changedWidget;
          _showDefault = false;
        });
      }else{
        widget.onCancel?.call();
        setState(() {
          _current = widget.defaultWidget;
        _showDefault = true;
        });
      }
    }, child: _current);
  }
}
