import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dili_video/http/content_api.dart';
import 'package:dili_video/states/auth_state.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: const ColorScheme.dark()),
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios)),
          ),
          body: const VideoForm()),
    );
  }
}

class VideoForm extends StatefulWidget {
  const VideoForm({super.key});

  @override
  State<VideoForm> createState() => _VideoFormState();
}

class _VideoFormState extends State<VideoForm> {
  final ImagePicker _picker = ImagePicker();
  late XFile? image =null;
  String url = "";

  void selectImg() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      url = image!.path;
    }
    setState(() {});
  }

  final _formKey = GlobalKey<FormState>();
  static const _leadingTextStyle =
      TextStyle(color: Color(0xff909090), fontSize: 18);

  List _partition = [];
  String _selectionText = '请选择分区';
  int groupValue = 1;

  final Map<String, dynamic> _form = {
    "title": "",
    "partitionId": "",
    "iforiginal": false,
    "description": "",
    "file":null,
    "authorId":auth_state.id
    
  };

  @override
  void initState() {
    getPart();
    super.initState();
  }

  void getPart() async {
    if (_partition.isNotEmpty) {
      return;
    }
    var res = await getAllPartition();
    setState(() {
      _partition = jsonDecode(res.toString())['data'];
    });
  }

  void _showBottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _partition.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _form['partitionId'] = _partition[index]['id'];
                      _selectionText = _partition[index]['partitionname'];
                    });
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            _partition[index]['partitionname'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _partition[index]['description'],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  )),
            );
          },
        );
      },
    );
  }

  void submit() {
    _formKey.currentState!.save();

    if(image==null){
      showDialog(context: context, builder:(context) {
        return  Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.pink.shade200,
              borderRadius: BorderRadius.circular(10)
            ),
            width: 100,
            height: 50,
            child: const Center(child: Text("未上传视频!"))),
        );
      });
    }



    print(_form);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: url == ""
                ? Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextButton(
                      onPressed: selectImg,
                      child: const Text(
                        "点击选择视频",
                        style: TextStyle(fontSize: 20),
                      ),
                    ))
                : Image.file(
                    File(url),
                    fit: BoxFit.cover,
                  ),
          ),
          TextFormField(
            onSaved: (newValue) {
              _form['title'] = newValue;
            },
            maxLength: 100,
            maxLines: 3,
            decoration: const InputDecoration(
              prefix: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 30, 0),
                child: Text(
                  "标题*",
                  style: _leadingTextStyle,
                ),
              ),
              hintText: "请输入标题",
              border: InputBorder.none,
            ),
          ),
          Container(
            height: 0.11,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: () {
              _showBottomsheet(context);
            },
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "分区*",
                    style: _leadingTextStyle,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(
                    _selectionText,
                    style: _leadingTextStyle,
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.transparent,
                  )),
                  const Icon(Icons.arrow_circle_right_outlined),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 0.11,
            color: Colors.grey,
          ),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "类型*",
                  style: _leadingTextStyle,
                ),
                const SizedBox(
                  width: 30,
                ),
                Radio(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        _form['iforiginal'] = true;
                        groupValue = value!;
                      });
                    }),
                const Text("自制"),
                Radio(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        _form['iforiginal'] = false;
                        groupValue = value!;
                      });
                    }),
                const Text("转载"),
                Expanded(
                    child: Container(
                  color: Colors.transparent,
                )),
                const SizedBox(
                  width: 15,
                )
              ],
            ),
          ),
          Container(
            height: 0.11,
            color: Colors.grey,
          ),
          TextFormField(
            onSaved: (newValue) {
              _form["description"] = newValue;
            },
            maxLength: 250,
            maxLines: 3,
            decoration: const InputDecoration(
              prefix: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 30, 0),
                child: Text(
                  "简介*",
                  style: _leadingTextStyle,
                ),
              ),
              hintText: "请输入简介",
              border: InputBorder.none,
            ),
          ),
          Container(
            height: 0.11,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 50,
            child: ElevatedButton(onPressed: submit, child: Text("发布")),
          )
        ]));
  }
}
