
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/theme/box_style.dart';
import 'package:dili_video/theme/colors.dart';
import 'package:dili_video/theme/text_styles.dart';
import 'package:flutter/material.dart';








class CardWithCover extends StatelessWidget {
  const CardWithCover({super.key,required this.title, this.leftBottomWidget, this.rightBottomWidget, required this.coverUrl, this.bottomHeight,  this.onClick});

  final String coverUrl;

  final String title;


  final double? bottomHeight;

  final Widget? leftBottomWidget;

  final Widget? rightBottomWidget;

  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick?.call();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: roundedBox(radius: 5,color: maindarkcolor),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Expanded(child: SizedBox(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: coverUrl,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(left: 5,bottom: 5,child: leftBottomWidget ?? Container()),
                  Positioned(right: 5,bottom: 5,child: rightBottomWidget ?? Container()),
                ],
              )
            )),
            Container(
              padding: const EdgeInsets.all(5),
              height: bottomHeight??50,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(title,style: whiteHeavy(size: 15),softWrap: false,overflow: TextOverflow.ellipsis,),
            )
          ],
        ),
      ),
    );
  }
}

