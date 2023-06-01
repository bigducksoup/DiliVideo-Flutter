import 'package:cached_network_image/cached_network_image.dart';
import 'package:dili_video/views/home/child/recommand_list.dart';
import 'package:dili_video/controller/index_page_controller.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final indexController = Get.find<IndexController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              floating: true,
              pinned: true,
              snap: false,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAvatar(),
                    Expanded(
                      child: _buildSearchBar(),
                    ),
                    const Icon(Icons.message)
                  ]),
              bottom: TabBar(
                  controller: _tabController,
                  labelColor: Colors.pink,
                  unselectedLabelColor: Colors.white,
                  indicatorWeight: 3.0,
                  indicatorColor: Colors.pink,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(
                      text: "直播",
                    ),
                    Tab(
                      text: "推荐",
                    ),
                    Tab(
                      text: "热门",
                    ),
                  ]),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            test(),
            RecommandList(),
            FlutterLogo()
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
        height: 40,
        width: 40,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Obx(
          () => GestureDetector(
              onTap: () {
                indexController.currentIndex.value = 2;
              },
              child: auth_state.avatarUrl.value != ''
                  ? CachedNetworkImage(
                      imageUrl: auth_state.avatarUrl.value,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox()),
        ));
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff242527),
      ),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 35,
      child: Row(children: const [
        SizedBox(width: 20),
        Icon(
          Icons.search,
          color: Color(0xff5d5e62),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "今天吃什么？",
          style: TextStyle(color: Color(0xff5d5e62)),
        )
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}





class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder:(context, index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(width: double.infinity,height: 200,color: Colors.amber,),
      );
    },itemCount: 200,);
  }
}


