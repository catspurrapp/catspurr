import 'package:flutter/material.dart';
import '/drawer/catspurr_drawer.dart';
import '/pages/friend.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("フレンド"),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Icon(Icons.person_add),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Icon(Icons.people),
          )
        ],
      ),
      drawer: const Drawer(
        child: CatsPurrDrawer(),
      ),
      body: const FriendPage(),
    );
  }
}
