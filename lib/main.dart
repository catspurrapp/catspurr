import 'package:catspurr/services/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/pages/main_page.dart';
import 'package:flutter/material.dart';
import "/pages/login.dart";

void main() => runApp(const CatsPurrMain());

class CatsPurrMain extends StatelessWidget {
  const CatsPurrMain({super.key});

  @override
  Widget build(BuildContext context) {
    StorageService.initialize();
    return MaterialApp(
      title: 'CatsPurr',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: FlutterSecureStorage().read(key: "token") == null
          ? LoginPage()
          : MainPage(),
    );
  }
}
