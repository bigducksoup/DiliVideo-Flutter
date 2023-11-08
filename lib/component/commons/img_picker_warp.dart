import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImgPickerWarp extends StatefulWidget {
  const ImgPickerWarp({super.key, required this.images});

  final List<File> images;

  @override
  State<ImgPickerWarp> createState() => _ImgPickerWarpState();
}

class _ImgPickerWarpState extends State<ImgPickerWarp> {
  Future<void> pickMultiImgs() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> files = await picker.pickMultiImage();

    if (files.isEmpty) return;

    for (XFile element in files) {
      setState(() {
        widget.images.add(File(element.path));
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int i = 0; i <= widget.images.length; i++)
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double pwidth = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      padding: const EdgeInsets.all(3),
                      width: pwidth / 3,
                      height: pwidth / 3,
                      child: i == widget.images.length
                          ? _buildPicker()
                          : _buildImages(i)),
                  if (i != widget.images.length)
                     Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.images.removeAt(i);
                          });
                        },
                        child: const Icon(
                          Icons.cancel_sharp,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              );
            },
          )
      ],
    );
  }

  Widget _buildPicker() {
    return GestureDetector(
        onTap: () {
          pickMultiImgs();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.pink.shade400, width: 0.5)),
          width: double.infinity,
          height: double.infinity,
          child: const Center(
              child: Icon(
            Icons.add_a_photo,
            size: 30,
          )),
        ));
  }

  Widget _buildImages(int i) {
    return Image.file(
      widget.images[i],
      fit: BoxFit.cover,
    );
  }
}
