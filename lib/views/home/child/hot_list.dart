import 'package:dili_video/component/card/video_item.dart';
import 'package:dili_video/http/content_api.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HotPage extends StatefulWidget {
  const HotPage({super.key});

  @override
  State<HotPage> createState() => _HotPageState();
}



  


class _HotPageState extends State<HotPage> {


  int page = 1;
  bool loading = false;
  bool empty = false;
  bool inited = false;
  List data = [];


  @override
  void initState() {
    super.initState();
    init();
  }


  init(){
    getData();
  }


  reloadState(){
    setState(() {
      page = 1;
      loading = false;
      empty = false;
      inited = false;
      data.clear();
    });

    init();
  }


  distory(){
    
  }



  void getData()async{
    
    if(loading)return;

    loading = true;
    var response = await getHotVideos(page);

    try{
      Map<String,dynamic> res = handleResponse(response);
      List currentData = res['data'];

      if(currentData.isEmpty){
        setState(() {
          empty = true;
          loading = false;
          inited = true;
        });
        return;
      }


      data.addAll(currentData);
    
      page++;
      setState(() {
        loading = false;
        inited = true;
      });

    }catch(e){
      reloadState();
    }

  }




  @override
  Widget build(BuildContext context) {
    return
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0? _buildTopBar() : VideoItem(coverUrl: data[index-1]['coverUrl'], title: data[index-1]['title'], videoAuthorName: data[index-1]['videoAuthorName'], watchCount: data[index-1]['watchCount'], date: data[index-1]['createTime']);
          },
          itemCount: data.length+1,
        ),
      );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(" 当前热门"),
          GestureDetector(
            onTap: () {
              print(123);
            },
            child: Container(
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.rankingStar,color: Colors.pink.shade400,size: 15,),
                  const SizedBox(width: 5,),
                  const Text("排行榜 ")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
