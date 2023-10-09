import 'package:dili_video/component/post_item.dart';
import 'package:dili_video/http/main_api.dart';
import 'package:dili_video/services/responseHandler.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/utils/success_fail_dialog_util.dart';
import 'package:flutter/material.dart';

class AllActivityView extends StatefulWidget {
  const AllActivityView({super.key});

  @override
  State<AllActivityView> createState() => _AllActivityViewState();
}

class _AllActivityViewState extends State<AllActivityView> {


  int page = 1;

  int pageSize = 5;

  bool init = false;

  bool empty = false;

  List data = [];

  bool loading = false;

  void loadData()async{
    if(loading)return;
    loading = true;

    if(empty)return;
    

    var response = await  getPostByFollows(page, pageSize);
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
      print(page);
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