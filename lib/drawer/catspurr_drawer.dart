import 'package:nyxx_self/src/models/guild/guild.dart';
import '/services/storage.dart';
import 'package:flutter/material.dart';
import '/custom_widgets/padding_icon.dart';
import '/drawer/friend_list.dart';

class CatsPurrDrawer extends StatefulWidget {
  const CatsPurrDrawer({super.key});

  @override
  State<CatsPurrDrawer> createState() => _CatsPurrDrawerState();
}

class _CatsPurrDrawerState extends State<CatsPurrDrawer> {
  // Widget to display a server (guild) icon
  Widget _serverList(BuildContext context, UserGuild guild) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(
          guild.icon != null
              ? guild.icon!.url.toString()
              : "https://ui-avatars.com/api/?background=494d54&uppercase=false&color=dbdcdd&size=128&font-size=0.33&name=${guild.name}",
        ),
      ),
    );
  }

  // Widget to display user's own stats
  Widget _ownStats() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: CircleAvatar(
            foregroundImage: NetworkImage(
              StorageService.user?.avatar.url.toString() ??
                  StorageService.user!.defaultAvatar.url.toString(),
            ),
          ),
        ),
        Expanded(
            child: Column(
          children: [
            Text(
              StorageService.user?.globalName ??
                  '${StorageService.user?.username}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              '${StorageService.user?.username}',
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).secondaryHeaderColor),
            )
          ],
        )),
        const PaddingIcon(icon: Icons.search),
        const PaddingIcon(icon: Icons.security),
        const PaddingIcon(icon: Icons.sentiment_dissatisfied),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 72,
              color: Colors.grey[900],
              child: FutureBuilder<List<UserGuild>>(
                future: StorageService.client
                    ?.listGuilds(), // Fetch guilds asynchronously
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Handle error state
                    return const Center(child: Text('Error loading guilds'));
                  } else if (snapshot.hasData) {
                    final guilds = snapshot.data!;
                    return ListView.builder(
                      itemCount:
                          guilds.length, // Use the length of the fetched guilds
                      itemBuilder: (context, index) =>
                          _serverList(context, guilds[index]),
                    );
                  } else {
                    // Handle empty state if needed
                    return const Center(child: Text('No guilds available'));
                  }
                },
              ),
            ),
            const Expanded(
              child: FriendList(),
            ),
          ],
        ),
        Container(
          height: 60,
          color: Colors.grey[850],
          padding: const EdgeInsets.all(8),
          child: _ownStats(),
        ),
      ],
    );
  }
}
