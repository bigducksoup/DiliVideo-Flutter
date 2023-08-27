import 'package:dili_video/controller/RoundedInputController.dart';
import 'package:flutter/material.dart';

class RoundedInput extends StatefulWidget {
  const RoundedInput({Key? key, required this.roundedInputController, required this.hintText, this.onClickSendBtn})
      : super(key: key);

  final RoundedInputController roundedInputController;

  final String hintText;

  final Function(String text)? onClickSendBtn;

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
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.pink)),
                  child: Center(
                    child: TextField(
                      controller: widget.roundedInputController.textEditingController,
                      focusNode: widget.roundedInputController.focusNode,
                      decoration:   InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(0),
                          isCollapsed: true,
                          hintText: widget.hintText
                          ),
                          cursorColor: Colors.pink.shade500,
                          
                    ),
                  ))),
          InkWell(onTap: () {
            widget.onClickSendBtn?.call(widget.roundedInputController.textEditingController.text);
          },child:  const SizedBox(width: 50, height: 50, child: Icon(Icons.send)))
        ],
      ),
    );
  }
}



