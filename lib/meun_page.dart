// menu_page.dart
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  final String day;
  final String date;
  final String menu;

  const MenuPage({
    super.key,
    required this.day,
    required this.date,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$day 메뉴"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              menu,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
