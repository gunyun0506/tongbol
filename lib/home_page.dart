import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tongbokapp/item_basket_page.dart';
import 'package:tongbokapp/meun_detail_page.dart';
import 'package:tongbokapp/meun_page.dart';
import 'item_list_page.dart';
import 'drawer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categorys').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (streamSnapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!streamSnapshot.hasData ||
              streamSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return HomeBody(categoryCount: streamSnapshot.data!.docs.length);
          }
        },
      ),
      drawer: const CustomDrawer(),
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Image(
        image: AssetImage('assets/images/logo/final_logo.png'),
        height: 65,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ItemBasketPage()),
            );
          },
          icon: const Icon(Icons.shopping_cart,
              color: Color.fromARGB(255, 100, 100, 100)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class HomeBody extends StatefulWidget {
  final int categoryCount;

  const HomeBody({Key? key, required this.categoryCount}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final PageController pageController;
  final TextEditingController searchController = TextEditingController();
  List<String> days = [];
  List<String> dates = [];

  final List<String> menus = [
    "메뉴 한식: 메뉴 아이템 1",
    "메뉴 중식: 메뉴 아이템 4",
    "메뉴 일식: 메뉴 아이템 7",
    "메뉴 양식: 메뉴 아이템 10",
    "메뉴 특별식: 메뉴 아이템 13",
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    _generateDatesAndDays(); //날짜 및 요일 리스트 생성
  }

  @override
  void dispose() {
    pageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _generateDatesAndDays() {
    final DateFormat dateFormat = DateFormat('MM월 dd일');
    final DateFormat dayFormat = DateFormat('EEEE', 'ko'); //한국어 요일 형식임

    for (int i = 0; i < 5; i++) {
      final DateTime date = DateTime.now().add(Duration(days: i));
      dates.add(dateFormat.format(date));
      days.add(dayFormat.format(date));
    }
  }

  Future<void> _onSearch() async {
    String searchQuery = searchController.text.trim(); // 검색어 앞뒤 공백 제거

    if (searchQuery.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('categorys')
            .where('category', isEqualTo: searchQuery)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemListPage(searchCategory: searchQuery),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No products found for the category $searchQuery'),
            ),
          );
        }
      } catch (e) {
        // 에러 발생 시 사용자에게 알림을 보여줄 수 있음
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching for category: $e'),
          ),
        );
      }
    } else {
      // 검색어가 비어 있을 때 처리할 내용 추가
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a search query.'),
        ),
      );
    }
  }

  Widget search() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 243, 240, 240),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search, // 검색 동작으로 지정
                onSubmitted: (value) => _onSearch(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "상품명을 입력하세요.",
                  hintStyle: TextStyle(fontSize: 18),
                  contentPadding:
                      EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 5),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  void _navigateToMenuPage(String day, String date, String menu) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuPage(
          day: day,
          date: date,
          menu: menu,
        ),
      ),
    );
  }

  void _navigateToRestaurantPage(DocumentSnapshot restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItemListPage(searchCategory: restaurant['category']),
      ),
    );
  }

  void _navigateToMenuDetailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuDetailPage(title: '모든 점포'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          search(),
          const SizedBox(height: 35),
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: pageController,
              itemCount: days.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () => _navigateToMenuPage(
                    days[index],
                    dates[index],
                    menus[index],
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 8,
                                  offset: const Offset(1, 7)),
                            ],
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 45, top: 0, bottom: 23),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "오늘의 메뉴",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dates[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                days[index],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                menus[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              days.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AnimatedBuilder(
                  animation: pageController,
                  builder: (context, child) {
                    double? page = pageController.page;
                    double selectedness = Curves.easeOut
                        .transform(max(0.0, 1.0 - ((page ?? 0) - index).abs()));
                    double zoom = 1.0 + (selectedness * 0.3);
                    return Container(
                      width: 8.0 * zoom,
                      height: 8.0 * zoom,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (page?.round() == index)
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '등록 점포',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categorys')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No restaurants available'));
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final restaurant = doc.data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () => _navigateToRestaurantPage(doc),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  restaurant['ImgUrl'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant['category'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      restaurant['detail'],
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 131, 130, 130),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Rating: ${restaurant['rating']}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
