import 'dart:convert';

import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'http/content_api.dart';

class VideoItemManage extends StatefulWidget {
  const VideoItemManage({super.key});

  @override
  State<VideoItemManage> createState() => _VideoItemManageState();
}

class _VideoItemManageState extends State<VideoItemManage> {
  dynamic _item;

  static const _leadingTextStyle =
      TextStyle(color: Color(0xff909090), fontSize: 18);

  TextEditingController titleController = TextEditingController();
  TextEditingController summaryController = TextEditingController();

  //分区列表
  List _partition = [];
  String _selectionText = '请选择分区';
  //是否可编辑
  bool readOnly = true;
  int groupValue = 1;

  final Map<String, dynamic> _form = {
    "id": "",
    "title": "",
    "partitionId": "",
    "iforiginal": false,
    "description": "",
  };

  @override
  void initState() {
    getPart();
    _item = Get.arguments;

    setData();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  void setData() {
    titleController.text = _item['title'];
    summaryController.text = _item['summary'];
    _form['title'] = _item['title'];
    _form['description'] = _item['summary'];
    _form['partitionId'] = _item['partitionId'];
    _form['iforiginal'] = _item['isOriginal'] == 1 ? true : false;
    _form['id'] = _item['videoInfoId'];
    setState(() {
      groupValue = _item['isOriginal'];
    });
  }

  //选择分区底部弹出框
  void _showBottomsheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: maindarkcolor,
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
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            _partition[index]['description'],
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
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

  //获取分区列表
  void getPart() async {
    if (_partition.isEmpty) {
      var res = await getAllPartition();
      setState(() {
        _partition = jsonDecode(res.toString())['data'];
      });
    }

    for (int i = 0; i < _partition.length; i++) {
      var element = _partition[i];
      if (element['id'] == _item['partitionId']) {
        _selectionText = element['partitionname'];
        break;
      }
    }
  }

  void delete(id) async {
    Get.defaultDialog(
      title: "确认删除此稿件？",
      middleText: "这一操作将无法撤销！",
      confirmTextColor: Colors.red,
      backgroundColor: Colors.pink.shade300,
      radius: 5,
      textConfirm: '确认',
      textCancel: '取消',
      onConfirm: () async {
        var response = await deleteVideo(id);

        var res = jsonDecode(response.toString());

        if (res['code'] == 200) {
          Get.back();
          Get.back(result: {"videoInfoId": id});
        }
      },
      onCancel: () {},
    );
  }

  void refresh() async {
    var response = await getVideoInfoById(_form['id']);
    var res = jsonDecode(response.toString());

    if (res['code'] == 200) {
      _item = res['data'];
      setData();
      getPart();
    }
  }

  void update() async {
    var response = await updateVideoInfo(_form);
    var res = jsonDecode(response.toString());

    if (res['code'] == 200) {
      refresh();
    }

    TextToast.showToast(res['msg']);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: maindarkcolor,
            title: const Text("编辑稿件"),
            leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios)),
            actions: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    readOnly = !readOnly;
                  });
                },
                child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.all(5),
                    child: Center(
                      child: readOnly ? Text("编辑") : Text("取消"),
                    )),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  readOnly: readOnly,
                  controller: titleController,
                  decoration: const InputDecoration(
                      prefix: Text(
                        "标题: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      border: InputBorder.none),
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  height: 0.11,
                  color: Colors.grey,
                ),
                TextFormField(
                  readOnly: readOnly,
                  controller: summaryController,
                  decoration: const InputDecoration(
                      prefix: Text(
                        "简介: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      border: InputBorder.none),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 10,
                ),
                Container(
                  height: 0.11,
                  color: Colors.grey,
                ),
                GestureDetector(
                  onTap: () {
                    if (readOnly == true) return;
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
                          value: 0,
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
                Visibility(
                  visible: !readOnly,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          _form['title'] = titleController.text;
                          _form['description']  =summaryController.text;
                          update();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: const Center(
                          child: Text(
                            "确认修改",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      )),
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        delete(_item['videoInfoId']);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red.shade700),
                      ),
                      child: const Center(
                        child: Text(
                          "删除稿件",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
