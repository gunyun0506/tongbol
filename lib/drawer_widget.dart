import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tongbokapp/my_order_list_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Container(
        color: Colors.white, // Drawer의 배경색을 흰색으로 설정
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75, // Drawer의 너비 설정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 237, 235, 235),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(1, 7),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipOval(
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: Image.network(
                                user!.photoURL!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(user.displayName ?? ""),
                      Text(user.email ?? '이메일 없음'),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  '주문 현황',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyOrderListPage()),
                  );
                },
              ),
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
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context); // Drawer를 닫음
                },
              ),
              const Spacer(), // 나머지 공간 차지
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Image.asset(
                    //   'assets/images/logo/logo.png',
                    //   width: 80,
                    //   height: 60,
                    // ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/images/logo/logo2.png', // 두 번째 로고 이미지 경로
                      width: 150,
                      height: 45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
