import 'dart:convert';
import 'dart:io';

import 'package:dili_video/component/img_picker_warp.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/topic_selector.dart';
import '../../../http/main_api.dart';

class PostPublish extends StatefulWidget {
  const PostPublish({super.key});

  @override
  State<PostPublish> createState() => _PostPublishState();
}

class _PostPublishState extends State<PostPublish> {
  int index = 0;

  bool sending = false;

  Map<String, dynamic> postForm = {
    'content': '',
    'topicId': '',
    'files': <File>[]
  };

  //设置话题id
  void setTopicId(String topicId) {
    postForm['topicId'] = topicId;
  }

  //设置内容与图片
  void setContent(String content, List<File> files) {
    postForm['content'] = content;
    postForm['files'] = files;
  }

  void checkAndSubmit() async {
    contentInputKey.currentState!.setData();

    if (postForm['content'] == '') {
      TextToast.showToast("请填写内容");
      return;
    }
    if (postForm['topicId'] == '') {
      TextToast.showToast("请填写话题");
      return;
    }
    setState(() {
      sending = true;
    });
    var response = await postText(postForm);
    var res = jsonDecode(response.toString());

    setState(() {
      sending = false;
    });

    if (res['code'] != 200) {
      TextToast.showToast(res['msg']);
      return;
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: _buildPublishButton())
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopicSelector(
                setTopicId: setTopicId,
              ),
              Expanded(
                  child: ContentInput(
                key: contentInputKey,
                setContent: setContent,
              )),
              Container(
                height: 40,
                color: Colors.black38,
              ),
            ],
          ),
        ));
  }

  Widget _buildPublishButton() {
    return ElevatedButton(
      onPressed: () {
        if (!sending) {
          checkAndSubmit();
        }
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
          backgroundColor: MaterialStateProperty.all(Colors.grey)),
      child: sending
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.pink.shade400,
              ))
          : const Text("发布"),
    );
  }
}

GlobalKey<_ContentInputState> contentInputKey = GlobalKey();

class ContentInput extends StatefulWidget {
  const ContentInput({super.key, required this.setContent});

  final void Function(String content, List<File> files) setContent;

  @override
  State<ContentInput> createState() => _ContentInputState();
}

class _ContentInputState extends State<ContentInput> {
  TextEditingController inputController = TextEditingController();

  List<File> images = [];

  void setData() {
    widget.setContent(inputController.text, images);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: inputController,
              cursorColor: Colors.pink.shade400,
              style: const TextStyle(fontSize: 18),
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "分享到我的动态",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ImgPickerWarp(
              images: images,
            )
          ],
        ),
      ),
    );
  }
}
