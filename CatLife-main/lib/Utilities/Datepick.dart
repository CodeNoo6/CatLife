import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupertino Date Picker in Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (date == null) ...[
              const Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              Text(date.toString()),
            ],
            ElevatedButton(
              onPressed: () async {
                await showCupertinoModalPopup<void>(
                  context: context,
                  builder: (_) {
                    final size = MediaQuery.of(context).size;
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      height: size.height * 0.27,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (value) {
                          date = value;
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
              child: const Text('Show Date Picker'),
            ),
          ],
        ),
      ),
    );
  }
}
