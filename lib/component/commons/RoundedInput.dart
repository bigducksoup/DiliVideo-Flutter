import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:flutter/material.dart';

class RoundedInput extends StatefulWidget {
  const RoundedInput({Key? key, required this.roundedInputController, required this.hintText, this.onClickSendBtn, this.fillColor, this.borderColor, this.textColor, this.iconColor, this.btnIcon, this.hintColor})
      : super(key: key);

  final RoundedInputController roundedInputController;

  final String hintText;

  final Function(String text)? onClickSendBtn;

  final Color? fillColor;

  final Color? borderColor;

  final Color? textColor;

  final Color? iconColor;

  final Color? hintColor;

  final IconData? btnIcon;

  

  @override
  State<RoundedInput> createState() => _RoundedInputState();
}

class _RoundedInputState extends State<RoundedInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 5),
                  decoration: BoxDecoration(
                      color: widget.fillColor ?? Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: widget.borderColor ?? Colors.pink.shade400)),
                  child: Center(
                    child: TextField(
                      style: TextStyle(color: widget.textColor),
                      controller: widget.roundedInputController.textEditingController,
                      focusNode: widget.roundedInputController.focusNode,
                      decoration:   InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(0),
                          isCollapsed: true,
                          hintText: widget.hintText,
                          hintStyle: TextStyle(color: widget.hintColor)
                          ),
                          cursorColor: Colors.pink.shade500,
                          
                    ),
                  ))),
          InkWell(onTap: () {
            widget.onClickSendBtn?.call(widget.roundedInputController.textEditingController.text);
          },child:   SizedBox(width: 50, height: 50, child: Icon(widget.btnIcon?? Icons.send,color: widget.iconColor ?? Colors.white,)))
        ],
      ),
    );
  }
}



