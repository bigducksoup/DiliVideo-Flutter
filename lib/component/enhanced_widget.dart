import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class EnhancedList extends StatefulWidget {
  const EnhancedList(
      {super.key,
      this.onReachBottom,
      this.onPullDown,
      required this.itemBuilder,
      required this.itemCount});

  final Future<void> Function()? onReachBottom;

  final Future<void> Function()? onPullDown;

  final Widget Function(BuildContext ctx, int index) itemBuilder;

  final int itemCount;

  @override
  State<EnhancedList> createState() => _EnhancedListState();
}

class _EnhancedListState extends State<EnhancedList> {
  int pullDownState = 0;

  void callPullDown() {
    if (pullDownState == 1) return;

    setState(() {
      pullDownState = 1;
    });

    if (widget.onReachBottom != null) {
      Future<void> res = widget.onReachBottom!.call();

      res.whenComplete(() {
        setState(() {
          pullDownState = 0;
        });
      });
    } else {
      setState(() {
        pullDownState = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.onPullDown?.call();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is UserScrollNotification &&
              notification.direction ==
                  ScrollDirection.reverse && // 检查滚动方向是向下滚动
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            // 到达底部，可以在这里执行加载更多的操作
            callPullDown();
          }
          return false;
        },
        child: ListView.builder(
            itemBuilder: widget.itemBuilder, itemCount: widget.itemCount),
      ),
    );
  }
}

class EnhancedCustomeScrollView extends StatefulWidget {
  const EnhancedCustomeScrollView(
      {super.key, this.slivers, this.onReachBottom, this.onPullDown, this.bottomLoadingWidget});

  final List<Widget>? slivers;

  final Future<void> Function()? onReachBottom;

  final Future<void> Function()? onPullDown;

  final Widget? bottomLoadingWidget;

  @override
  State<EnhancedCustomeScrollView> createState() =>
      _EnhancedCustomeScrollViewState();
}

class _EnhancedCustomeScrollViewState extends State<EnhancedCustomeScrollView> {


  int _reachBottomState = 0;


  void callonReachBottom() async {
    if(_reachBottomState == 1)return;

    setState(() {
      _reachBottomState = 1;
    });

    if(widget.onReachBottom!=null){
      Future<void> res = widget.onReachBottom!.call();
      res.whenComplete((){
        setState(() {
          _reachBottomState = 0;
        });
      });
      res.onError((error, stackTrace){
        setState(() {
          //error occurd
          _reachBottomState = 2;
        });
      });
      return;
    }


    setState(() {
      _reachBottomState = 0;
    });





  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.onPullDown?.call();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is UserScrollNotification &&
              notification.direction ==
                  ScrollDirection.reverse && // 检查滚动方向是向下滚动
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            // 到达底部，可以在这里执行加载更多的操作
            callonReachBottom();
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            ...?widget.slivers,
             SliverToBoxAdapter(
              child: _reachBottomState==1? widget.bottomLoadingWidget??const Center(child: CircularProgressIndicator(),):const SizedBox()
            )
          ],
        ),
      ),
    );
  }
}
