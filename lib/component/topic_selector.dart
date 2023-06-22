
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../http/main_api.dart';

class TopicSelector extends StatefulWidget {
   const TopicSelector({super.key, required this.setTopicId});

  final void Function(String topicId) setTopicId;


  @override
  State<TopicSelector> createState() => _TopicSelectorState();
}

class _TopicSelectorState extends State<TopicSelector> {
  int index = 0;
  //话题列表
  List topicList = [];
  //搜索时的备份话题列表
  List searchBackup = [];
  //分页查询的页数
  int topicPage = 1;

  bool topicListLoading = true;

  //显示的文字
  String topic = '#选择话题';

  //由于bottomsheet的state属于新页面当前页面无法访问，需要StatefulBuilder
  var setSheetState;

  //加载话题列表
  Future<void> loadTopicList() async {
    var response = await getTopicList(topicPage);
    var res = jsonDecode(response.toString());

    setSheetState(() {
      topicListLoading = false;
    });

    if (res['code'] != 200) {
      return;
    }
    if ((res['data'] as List).isEmpty) {
      return;
    }
    setState(() {
      topicList.addAll(res['data']);
      searchBackup.addAll(res['data']);
    });
    topicPage++;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //搜索话题
  Widget _buildTopicSearch() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.purple),
      child: Center(
        child: TextField(
          decoration: const InputDecoration(
              hintText: "搜索感兴趣的话题",
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              border: InputBorder.none),
          onChanged: (value) {
            topicList = List.from(searchBackup);
            if (value != '') {
              topicList.removeWhere((element) {
                if (!(element['name'] as String).contains(value) &&
                    !(element['description'] as String).contains(value)) {
                  return true;
                }
                return false;
              });
            }
            setSheetState(() {});
          },
        ),
      ),
    );
  }

  //话题列表选择
  void openBottomTopicSheet() {
    Get.bottomSheet(StatefulBuilder(builder: (context, st) {
      setSheetState = st;
      return SafeArea(
          child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black,
              child: topicListLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        _buildTopicSearch(),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  widget.setTopicId( topicList[index]['id']);
                                  setState(() {
                                    topic = '#' + topicList[index]['name'];
                                    Get.back();
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topicList[index]['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      Text(topicList[index]['description']),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: topicList.length,
                          ),
                        )
                      ],
                    )));
    }));
    if (topicListLoading == true) {
      loadTopicList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Colors.transparent,
      child: _buildSelectButton(),
    );
  }


  //选择按钮
  Widget _buildSelectButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: ElevatedButton(
            onPressed: openBottomTopicSheet,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
            child:  Text(topic),
          ),
        )
      ],
    );
  }
}