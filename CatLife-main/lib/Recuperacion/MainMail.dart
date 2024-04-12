import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/hotmail.dart';
import 'package:mailer/smtp_server/yandex.dart';

void main() {
  runApp(const MaterialApp(
    home: MailPage(),
  ));
}

class MailPage extends StatefulWidget {
  const MailPage({key});

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  final outlookSmtp = hotmail("catlifegimo@outlook.com", "Tomate123##");

  sendMailFromOutlook() async {
    final message = Message()
      ..from = Address("catlifegimo@outlook.com", 'Cat Life')
      ..recipients.add('35qg9pugxh@myinfoinc.com')
      ..subject = '¡Hola! Tu código de verificación'
      ..html = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Email Verification</title>
</head>
<body style="background-color:#fafafa;display:flex;justify-content:center;align-items:center">
  <div class="c-email" style="width:100vw;border-radius:10px;overflow:hidden;box-shadow:0 7px 22px 0 rgba(0,0,0,.1)">
    <div class="c-email__header" style="background-color:#08caf7;width:100%;height:60px">
      <h1 class="c-email__header__title" style="font-size:18px;font-family:'Open Sans';height:60px;line-height:60px;margin:0;text-align:center;color:#fff">Ingresa este código en tu app</h1>
    </div>
    <div class="c-email__content" style="width:100%;display:flex;flex-direction:column;justify-content:space-around;align-items:center;flex-wrap:wrap;background-color:#fff;padding:10px">
      <div class="c-email__code" style="display:block;width:60%;margin:30px auto;background-color:#ddd;border-radius:10px;padding:2px;text-align:center;font-size:20px;font-family:'Open Sans';letter-spacing:5px;box-shadow:0 7px 22px 0 rgba(0,0,0,.1)">
        <span class="c-email__code__text">123456</span>
      </div>
    </div>
    <div class="c-email__footer" style="width:100%;background-color:#fff"></div>
  </div>
</body>
</html>
''';
    try {
      final sendReport = await send(message, outlookSmtp);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Send Mail From App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: Text("Send Mail From Outlook"),
                onPressed: () {
                  sendMailFromOutlook();
                }),
            ElevatedButton(
                child: Text("Send Mail From Yandex"), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
