import 'package:dili_video/component/recommand_list.dart';
import 'package:dili_video/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assets/assets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1,length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    const _pinkTextStyle = TextStyle(
      color: Colors.pink,
    );



    return CustomScrollView(
      slivers: [
        SliverAppBar(
          
          elevation: 0,
          floating: true,
          pinned: true,
          snap: true,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              height: 40,
              width: 40,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Obx(()=>Image.network(
                auth_state.avatarUrl.value,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
              ),)
            ),
            Expanded(
              child: Container(
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
                    "data",
                    style: TextStyle(color: Color(0xff5d5e62)),
                  )
                ]),
              ),
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
        SliverFillRemaining(
          child: TabBarView(
            children: [
              Placeholder(),
              RecommandList(),
              FlutterLogo()
            ],
            controller: _tabController,
          ),
        )
      ],
    );
  }
}
