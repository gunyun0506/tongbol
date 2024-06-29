import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '프로필 페이지 내용을 추가하세요.',
              style: TextStyle(fontSize: 20),
            ),
            // 여기에 프로필 페이지의 추가적인 내용을 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
