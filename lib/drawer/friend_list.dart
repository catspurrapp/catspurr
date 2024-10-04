import 'dart:convert';
import 'package:catspurr/services/http.dart';
import 'package:catspurr/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FriendList extends StatefulWidget {
  const FriendList({super.key});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  Future<List<dynamic>> getFriends() async {
    http.Response? response = await HTTPService.get(
      "https://discord.com/api/v10/users/@me/relationships",
      headers: {"Authorization": StorageService.token ?? ""},
    );
    List<dynamic> data = json.decode(response?.body ?? "[]");
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          children: <Widget>[
            // Input field
            Container(
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[900],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "会話に参加または作成する",
                  hintStyle: TextStyle(fontSize: 12, color: Colors.white30),
                ),
              ),
            ),

            // Friend list
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: getFriends(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error message
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final friends = snapshot.data!;
                    return ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[900],
                      ),
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            foregroundImage: NetworkImage(
                              "https://cdn.discordapp.com/avatars/${friends[index]["id"]}/${friends[index]["user"]["avatar"]}.png",
                            ),
                          ),
                          title: Text(
                            friends[index]["nickname"] ??
                                '${friends[index]["user"]["global_name"] ?? friends[index]["user"]["username"]}',
                          ),
                          subtitle: Text(
                            "hello", // Update this with actual status if available
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                        );
                      },
                    );
                  } else {
                    // No friends
                    return const Center(child: Text('No friends found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
