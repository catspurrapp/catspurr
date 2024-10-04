import 'dart:convert';

import '/custom_widgets/totp_auth_app_dialog.dart';
import '/custom_widgets/totp_main_dialog.dart';
import '/pages/main_page.dart';
import '/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/services/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  String email = '';
  String? emailErrorText;
  String password = '';
  String? passwordErrorText;

  Future<void> login() async {
    http.Response? response = await HTTPService.post(
        "https://discord.com/api/v9/auth/login",
        headers: {"Content-Type": "application/json"},
        body: json.encode({"login": email, "password": password}));
    if (response != null) {
      if (response.statusCode == 200) {
        debugPrint(response.body);
        setState(() {
          emailErrorText = null;
          passwordErrorText = null;
        });

        Map<String, dynamic> userMap = json.decode(response.body);
        if (userMap["totp"] == true) {
          while (true) {
            final String? selected = await showDialog<String>(
                context: context,
                builder: (_) {
                  return TotpMainDialog();
                });
            if (selected == null) {
              break;
            } else if (selected == "authapp") {
              final String? rawUserData = await showDialog<String>(
                  context: context,
                  builder: (_) {
                    return TotpAuthAppDialog(ticket: userMap["ticket"]);
                  });
              if (rawUserData != null) {
                debugPrint(rawUserData);
                if (rawUserData == "other") continue;
                Map<String, dynamic> userData = json.decode(rawUserData);
                await StorageService.setToken(userData["token"]);
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return MainPage();
                    },
                  ),
                );
              } else {
                break;
              }
            }
          }
        } else {
          await StorageService.setToken(userMap["token"]);
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            ),
          );
        }
      } else if (response.statusCode == 400) {
        Map<String, dynamic> loginData = json.decode(response.body);
        debugPrint(response.body);
        setState(() {
          emailErrorText =
              loginData["errors"]["email"]["_errors"][0]["message"];
          passwordErrorText =
              loginData["errors"]["password"]["_errors"][0]["message"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'メールアドレス',
                    errorText: emailErrorText,
                  ),
                  onChanged: (value) => {
                    setState(() {
                      email = value;
                    })
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      labelText: 'パスワード',
                      errorText: passwordErrorText,
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                  onChanged: (value) => {
                    setState(() {
                      password = value;
                    })
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      login();
                    },
                    child: const Text('ログイン')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
