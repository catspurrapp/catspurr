import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '/services/http.dart';

/// 状態を持ったダイアログ
class TotpAuthAppDialog extends StatefulWidget {
  const TotpAuthAppDialog({Key? key, this.text, this.ticket}) : super(key: key);
  final String? text;
  final String? ticket;

  @override
  State<TotpAuthAppDialog> createState() => _TotpAuthAppDialogState();
}

class _TotpAuthAppDialogState extends State<TotpAuthAppDialog> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String? errorText;
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // TextFormFieldに初期値を代入する
    controller.text = widget.text ?? '';
    focusNode.addListener(
      () {
        // フォーカスが当たったときに文字列が選択された状態にする
        if (focusNode.hasFocus) {
          controller.selection = TextSelection(
              baseOffset: 0, extentOffset: controller.text.length);
        }
      },
    );
  }

  Future<String?> totpAuthorize() async {
    setState(() {
      errorText = null;
    });

    http.Response? response =
        await HTTPService.post("https://discord.com/api/v9/auth/mfa/totp",
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "code": controller.text,
              "gift_code_sku_id": null,
              "login_source": null,
              "ticket": widget.ticket
            }));
    return response?.body;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFormField(
        decoration:
            InputDecoration(labelText: "Discordの認証コード", errorText: errorText),
        maxLength: 6,
        autofocus: true, // ダイアログが開いたときに自動でフォーカスを当てる
        focusNode: focusNode,
        controller: controller,
        onFieldSubmitted: (_) {
          // エンターを押したときに実行される
          totpAuthorize().then((text) {
            if (text != null) {
              Map<String, dynamic> userData = json.decode(text);
              if (!userData.containsKey("message")) {
                Navigator.of(context).pop(text);
              } else {
                setState(() {
                  errorText = userData["message"];
                });
              }
            }
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop("other");
          },
          child: const Text('他の手段で認証'),
        ),
        TextButton(
          onPressed: () {
            totpAuthorize().then((text) {
              if (text != null) {
                Map<String, dynamic> userData = json.decode(text);
                if (!userData.containsKey("message")) {
                  Navigator.of(context).pop(text);
                } else {
                  setState(() {
                    errorText = userData["message"];
                  });
                }
              }
            });
          },
          child: const Text('確認'),
        )
      ],
    );
  }
}
