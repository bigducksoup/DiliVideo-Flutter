import 'dart:async';

import 'package:dili_video/assets/assets.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RecommandList extends StatefulWidget {
  const RecommandList({super.key});

  @override
  State<RecommandList> createState() => _RecommandListState();
}

class _RecommandListState extends State<RecommandList>
    with AutomaticKeepAliveClientMixin {
    
    var scrollController = Get.find<ScrollController>();

      
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: double.infinity,
      color: Colors.black,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          // physics: const NeverScrollableScrollPhysics(),
          // shrinkWrap: true,
          itemBuilder: (context, index) {
            return const TwoVideoInOneRow();
          },
          itemCount: 10,
        ),
      ),
    );
  }

  @override

  bool get wantKeepAlive => true;
}

class TwoVideoInOneRow extends StatelessWidget {
  const TwoVideoInOneRow({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.96;
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          VideoItem(
            coverurl:
                "http://127.0.0.1:9000/img/cf/c6/f71fa4ff-a93d-4bb3-a7e1-e6fb58448d5a.jpg",
            plcount: 1002,
            authorname: "要西，kiu有麻木忽略",
            title: "要西，kiu有麻木忽略要西，kiu有麻木忽略要西，kiu有麻木忽略要西，kiu有麻木忽略",
          ),
          VideoItem(
            coverurl:
                "http://127.0.0.1:9000/img/cf/c6/f71fa4ff-a93d-4bb3-a7e1-e6fb58448d5a.jpg",
            plcount: 1002,
            authorname: "duck",
            title: "this is a render test",
          ),
        ],
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem(
      {super.key,
      required this.coverurl,
      required this.plcount,
      required this.authorname,
      required this.title});

  final String coverurl;
  final int plcount;
  final String authorname;
  final String title;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.96 * 0.51;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(5),
          color: maindarkcolor,
          
        ),
        width: width,
        height: width * 1.1,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: width*0.7,
              child: Stack(
                children: [
                  SizedBox(
                    width: width,
                    height: width*0.7,
                    child: Image.network(coverurl,fit: BoxFit.cover,)
                    ),
                  Positioned(
                    left: 5,
                    bottom: 5,
                    child: Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.youtube,color: Colors.white,size: 15,),
                        const SizedBox(width: 5,),
                        Text("$plcount",style: const TextStyle(color:Colors.white,fontWeight: FontWeight.w300),),
                      ],
                    )
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Text(title,maxLines: 2,style: const TextStyle(color: Colors.white,fontSize: 17),overflow: TextOverflow.ellipsis,),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.user,color: Colors.white,size: 15,),
                  const SizedBox(width: 5,),
                  Text(authorname,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
