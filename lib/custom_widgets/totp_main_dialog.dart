import 'package:flutter/material.dart';

class TotpMainDialog extends StatelessWidget {
  const TotpMainDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('多要素認証'),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16, vertical: 8),
          child: Text('この追加ステップで、本当にあなたであることを確認できます。'),
        ),
        SimpleDialogOption(
          child: Text('パスキーまたはセキュリティキーを使用'),
          onPressed: () {
            Navigator.pop(context, 'passkey');
          },
        ),
        SimpleDialogOption(
          child: Text('認証アプリを使用'),
          onPressed: () {
            Navigator.pop(context, 'authapp');
          },
        ),
        SimpleDialogOption(
          child: Text('バックアップコードを使用'),
          onPressed: () {
            Navigator.pop(context, 'backup');
          },
        )
      ],
    );
  }
}
