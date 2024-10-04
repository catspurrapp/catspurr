import 'package:flutter/material.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const SafeArea(
            child: TabBar(
              labelPadding: EdgeInsets.all(16),
              labelStyle: TextStyle(fontSize: 12),
              isScrollable: true,
              tabs: <Widget>[
                Tab(text: "すべて表示"),
                Tab(text: "オンライン"),
                Tab(text: "承認待ち"),
                Tab(text: "提案"),
                Tab(text: "ブロック中"),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Text("すべて表示"),
            Text("オンライン"),
            Text("承認待ち"),
            Text("提案"),
            Text("ブロック中"),
          ],
        ),
      ),
    );
  }
}
