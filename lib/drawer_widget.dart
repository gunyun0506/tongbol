import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tongbokapp/profile_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Colors.white, // 16진수 색상 코드로 색상 지정
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: SizedBox(
                          width: 64, // 이미지의 가로 세로 크기 지정
                          height: 64,
                          child: Image.network(
                            user!.photoURL!,
                            fit: BoxFit.cover, // 이미지를 더 잘 맞게 조정
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(user.displayName ?? ""),
                  Text(user.email ?? 'No email available'),
                ],
              ),
            ),
          ),
          // 추가: 프로필 정보 표시
          ListTile(
            title: const Text(
              '프로필',
              style: TextStyle(fontSize: 18),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
            onTap: () {
              // 프로필 페이지로 이동
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          // 추가: 로그아웃 버튼
          ListTile(
            title: const Text(
              '로그아웃',
              style: TextStyle(fontSize: 18),
            ),
            trailing: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context); // Drawer를 닫음
              // 로그아웃 후에 로그인 페이지로 이동하도록 할 수도 있음
            },
          ),
          const SizedBox(
            height: 400,
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(160, 55, 0, 0),
              child: Image(
                image: AssetImage('assets/images/logo/logo.png'),
                width: 90,
              ))
        ],
      ),
    );
  }
}
