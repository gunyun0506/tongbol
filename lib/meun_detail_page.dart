import 'package:flutter/material.dart';

class MenuDetailPage extends StatelessWidget {
  final String title;

  const MenuDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Text(
          '모든 점포를 볼 수 있습니다.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
