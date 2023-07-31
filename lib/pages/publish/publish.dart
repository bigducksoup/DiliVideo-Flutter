import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dili_video/http/content_api.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:dili_video/utils/file_utils.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

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
          body: const SingleChildScrollView(child: VideoForm())),
    );
  }
}

class VideoForm extends StatefulWidget {
  const VideoForm({super.key});

  @override
  State<VideoForm> createState() => _VideoFormState();
}

class _VideoFormState extends State<VideoForm> {
  final _formKey = GlobalKey<FormState>();

  static const _leadingTextStyle =
      TextStyle(color: Color(0xff909090), fontSize: 18);

  String? code;
  File? video;
  File? cover;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  //分区列表
  List _partition = [];
  String _selectionText = '请选择分区';
  int groupValue = 1;
  bool ifupload = false;

  //总片数
  int totalChunkCount = 1;
  //已上传完的片数
  int finishedChunk = 0;

  List<int> failedChunkIndex = [];

   Timer? retryTimer;

  //表单
  final Map<String, dynamic> _form = {
    "title": "",
    "partitionId": "",
    "iforiginal": false,
    "description": "",
    "file": null,
    "authorId": auth_state.id,
    "code": ""
  };

  @override
  void initState() {
    super.initState();
    getPart();
    pickVideo();
  }

  @override
  void dispose() {
    video?.delete();
    cover?.delete();
    _videoController?.dispose();
    retryTimer?.cancel();
    super.dispose();
  }

  Future<void> pickVideo() async {
    var source = ImageSource.gallery;
    final XFile? pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      setState(() {
        video = File(pickedFile.path);

        _videoController = VideoPlayerController.file(video!)
          ..initialize().then((value) {
            setState(() {});
            _videoController!.setLooping(true);
            _videoController!.play();
          });
      });
      chunkAndUpload(pickedFile);
    }
  }

  void uploadOneTime(XFile pickedFile) async {
    var res = await getUploadCode();
    var m = jsonDecode(res.toString());
    print(m);
    code = m['data'];

    Map<String, dynamic> formdata = {
      "file": await dio.MultipartFile.fromFile(video!.path,
          filename: pickedFile.name),
      "originalFileName": pickedFile.name,
      "code": code
    };
    var uploadRes = await uploadVideo(formdata);
    var uploadr = jsonDecode(uploadRes.toString());

    var resCode = uploadr['code'];
    if (resCode == 200) {
      ifupload = true;
      video?.delete();
    }
  }

  void chunkAndUpload(XFile pickedFile) async {
    var res = await getUploadCode();
    code= jsonDecode(res.toString())['data'];
    List<File> files = FileChunker.chunkSync(File(pickedFile.path));
    setState(() {
      totalChunkCount = files.length;
    });
    uploadChunks(files, pickedFile.name);
    //设置定时器监听失败分片
    retryTimer =  Timer.periodic(const Duration(seconds: 30), (timer) async{
      if (finishedChunk < totalChunkCount && failedChunkIndex.isNotEmpty) {
        for (int index in failedChunkIndex) {
          print("有分片上传失败，重试，第${index}个");
          failedChunkIndex.remove(index);
          File element = files[index];
          uploadVideoChunk({
            "code": code,
            "file": await dio.MultipartFile.fromFile(element.path),
            "index": index,
            "totalChunkCount": files.length,
            "fileName": pickedFile.name
          }).then((response) {
            Map res = jsonDecode(response.toString());
            if (res['code'] == 200) {
              setState(() {
                element.delete();
                finishedChunk++;
              });
            } else {
              failedChunkIndex.add(index);
            }
          });
        }
      } else {
        //全部上传成功，关闭定时器
        timer.cancel();
      }
    });
  }

  void uploadChunks(List<File> files, String fileName) async{
    for (int i = 0; i < files.length; i++) {
      File element = files[i];
      print("上传第${i}个,总共${files.length}个");
      //上传分片
      uploadVideoChunk({
        "code": code,
        "file": await dio.MultipartFile.fromFile(element.path),
        "index": i,
        "totalChunkCount": files.length,
        "fileName": fileName
      }).then((response) {
        Map res = jsonDecode(response.toString());
        if (res['code'] != 200) {
          print("第${i}个上传失败");
          print(res);
          failedChunkIndex.add(i);
        } else {
          setState(() {
            element.delete();
            finishedChunk++;
            print("上传第${i}个成功");
          });
        }
      });
    }
  }

  Future<void> pickCover() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        cover = File(pickedFile.path);
      });
      _form['file'] = await dio.MultipartFile.fromFile(cover!.path,
          filename: pickedFile.name);
    }
  }

  //获取分区列表
  void getPart() async {
    if (_partition.isNotEmpty) {
      return;
    }
    var res = await getAllPartition();
    setState(() {
      _partition = jsonDecode(res.toString())['data'];
    });
  }

  //选择分区底部弹出框
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

  void showFormError(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.pink.shade200,
                    borderRadius: BorderRadius.circular(10)),
                width: 100,
                height: 50,
                child: Center(child: Text(msg))),
          );
        });
  }

  //提交表单
  void submit() async {
    _formKey.currentState!.save();

    if(totalChunkCount == finishedChunk){
      ifupload = true;
    }

    if (ifupload == false) {
      showFormError("视频未上传！");
      return;
    }

    _form['code'] = code;

    //checkform
    if (_form['title'].length == '' ||
        _form['partitionId'] == '' ||
        _form['description'] == '') {
      showFormError("视频信息填写不全==");
      return;
    }

    print(_form);

    var response = await submitVideoInfoForm(_form);
    var subRes = jsonDecode(response.toString());

    if (subRes['code'] == 200) {
      Get.back();
    } else {
      showFormError("上传失败");
    }
  }

  videoPlayerBuilder() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else {
      return Center(
        child: InkWell(
            onTap: () => pickVideo(),
            child: Text(
              "点击选择视频",
              style: TextStyle(color: Colors.pink.shade300, fontSize: 20),
            )),
      );
    }
  }

  Widget coverBuilder() {
    if (cover != null) {
      return GestureDetector(
        onTap: () => pickCover(),
        child: SizedBox(
            height: 55,
            width: 80,
            child: Image.file(
              cover!,
              fit: BoxFit.cover,
            )),
      );
    } else {
      return TextButton(
          onPressed: () => pickCover(), child: const Text("选择封面"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(
              width: double.infinity, height: 200, child: videoPlayerBuilder()),
          Row(
            children: [
              SizedBox(height: 5,width: MediaQuery.of(context).size.width,child: LinearProgressIndicator(value: (finishedChunk.toDouble()/totalChunkCount.toDouble()),))
            ],
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
          SizedBox(
              height: 60,
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "封面*",
                    style: _leadingTextStyle,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  // const Expanded(child: SizedBox()),
                  coverBuilder(),
                  const SizedBox(
                    width: 105,
                  )
                ],
              )),
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
