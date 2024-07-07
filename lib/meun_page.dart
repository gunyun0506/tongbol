import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatelessWidget {
  final String day;
  final String menu; // 변수명 수정: meun -> menu
  final String date;

  const MenuPage({
    Key? key,
    required this.day,
    required this.menu, // 변수명 수정: meun -> menu
    required this.date,
  }) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchMenuData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('menus')
          .where('day', isEqualTo: day)
          .where('menu', isEqualTo: menu) // 변수명 수정: meun -> menu
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'day': doc['day'],
                'menu': doc['menu'], // 변수명 수정: meun -> menu
                // Add other fields you need here
              })
          .toList();
    } catch (e) {
      print("Error fetching menu data: $e");
      throw e; // 예외를 다시 던져서 상위에서 처리할 수 있도록 합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$day 메뉴"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchMenuData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No menu available'));
          } else {
            // 데이터가 정상적으로 로드된 경우 처리
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.map((menuItem) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        menuItem['day'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        menuItem['menu'], // 변수명 수정: meun -> menu
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      // Add other UI elements for additional fields
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
