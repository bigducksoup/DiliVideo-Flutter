import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../component/post_item.dart';
import '../../../http/main_api.dart';
import '../../../services/responseHandler.dart';
import '../../../theme/colors.dart';
import '../../../utils/success_fail_dialog_util.dart';


class VideoActivityView extends StatefulWidget {
  const VideoActivityView({super.key});

  @override
  State<VideoActivityView> createState() => _VideoActivityViewState();
}

class _VideoActivityViewState extends State<VideoActivityView> {
  
  int page = 1;

  int pageSize = 20;

  bool init = false;

  bool empty = false;

  List data = [];

  bool loading = false;

  CancelToken cancelToken = CancelToken();

  void loadData()async{

    if(loading)return;
    loading = true;

    if(empty)return;

    var response = await  getPostByFollows(page, pageSize,video_only: true,cancelToken: cancelToken);
    try{
      Map<String,dynamic> res  =  handleResponse(response);
      if((res['data'] as List).isEmpty){
      setState(() {
        empty = true;
        init = true;
        loading = false;
        return;
      });
    }

    setState(() {
      data.addAll(res['data']);
      init = true;
    });

    page++;
    loading = false;
    }catch(e){
      TextToast.showToast("网络错误");
      reloadState();
    }
  }


  void reloadState(){
    setState(() {
      page = 1;
      init = false;
      empty = false;
      loading = false;
      data.clear();
    });

    loadData();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }


  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: maindarkcolor,
      child: init? RefreshIndicator(
        color: Colors.pink.shade400,
        onRefresh: () async{ 
          reloadState();
         },
        child: _buildContent() 
      ):const Center(child: CircularProgressIndicator(),),
    );
  }


  Widget _buildContent(){
    if(data.isEmpty){
      return const Center(child: Text("这里什么也没有捏 =V=!",style: TextStyle(color: Colors.white),),);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if(notification.metrics.pixels==notification.metrics.maxScrollExtent ){
          if(empty==false && loading == false){
            loadData();
          }else{ 
            return true;
          }
        }
        return false;
      },
      child: ListView.builder(itemBuilder:(context, index) {
          return Column(children: [
            PostItem(item: data[index]),
            Container(width: double.infinity,height: 10,color: Colors.black,)
          ],);
        },itemCount: data.length,),
    );
  }

}