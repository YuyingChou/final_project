import 'package:flutter/material.dart';

class p2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('上架交易品資訊'),
      backgroundColor: Colors.blue,
    );

    final btn = ElevatedButton(
      child: const Text('確定'),
      onPressed: () => Navigator.pop(context),
    );

    final widget =
    Container(child: btn, alignment: Alignment.bottomRight, padding: const EdgeInsets.all(30),
    );

    final page = Scaffold(
      appBar: appBar,
      body: widget,
      backgroundColor: const Color.fromARGB(255, 220, 220, 220),
    );

    return page;
  }

}