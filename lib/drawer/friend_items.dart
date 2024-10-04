import 'dart:math';

abstract class ListItem {}

class Head implements ListItem {
  Head();
}

class FriendItem implements ListItem {
  const FriendItem({required this.name, required this.status});

  final String name;
  final String status;
}

class Status {
  final list = ["オンライン", "取り込み中", "退席中", "オフライン"];
  final _rand = Random();

  Status();

  String generate() {
    return list[_rand.nextInt(list.length)];
  }
}
