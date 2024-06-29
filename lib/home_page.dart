import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tongbokapp/item_list_page.dart';
import 'package:tongbokapp/meun_detail_page.dart';
import 'package:tongbokapp/meun_page.dart';
import 'package:tongbokapp/models/product.dart';
import 'drawer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(),
      body: HomeBody(),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      title: const Row(
        children: [
          Image(
            image: AssetImage('assets/images/logo/market_logo.png'),
            height: 65,
          ),
        ],
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final PageController pageController;
  final TextEditingController searchController = TextEditingController();
  final List<String> days = ["월요일", "화요일", "수요일", "목요일", "금요일"];
  final List<String> dates = ["6월 24일", "6월 25일", "6월 26일", "6월 27일", "6월 28일"];
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
  }

  @override
  void dispose() {
    pageController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    String searchQuery = searchController.text;
    if (searchQuery.isNotEmpty) {
      Future<List<Product>> products =
          productsForCategory(searchQuery); // 수정: 해당 검색 기능을 지원하는 함수 사용
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemListPage(
            category: searchQuery,
            products: products,
          ),
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
              decoration: BoxDecoration(
                color: const Color(0xffE1E2E4).withAlpha(100),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                controller: searchController,
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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: _onSearch,
          ),
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

  void _navigateToRestaurantPage(Map<String, dynamic> restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemListPage(
          category: restaurant['name'], // 예시에서는 name을 category로 사용
          products: productsForCategory(
              restaurant['name']), // 수정: 해당 식당의 상품 목록을 불러오는 함수 사용
        ),
      ),
    );
  }

  void _navigateToMenuDetailPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuDetailPage(title: '모든 메뉴'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10), // 검색 UI 위 간격 조정
          search(),
          const SizedBox(height: 35), // 검색 UI와 PageView.builder 사이 간격 조정
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
                        horizontal: 16, vertical: 12),
                    child: Stack(
                      children: [
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            border: Border.all(color: Colors.grey, width: 0.8),
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
          const SizedBox(height: 40), // 위젯 간격 조정
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '입점 점포',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _navigateToMenuDetailPage();
                  },
                  child: const Text(
                    '더보기   ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: List.generate(
                  restaurantList.length,
                  (index) {
                    final restaurant = restaurantList[index];
                    return GestureDetector(
                      onTap: () => _navigateToRestaurantPage(restaurant),
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
                            Image.asset(
                              restaurant['image'],
                              width: 100,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    "${restaurant['rating']} (${restaurant['orders']}+)",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    restaurant['details'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  Text(
                                    "최소 주문: ${restaurant['minOrder']}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  //maxLines: 2,
                                  //overflow: TextOverflow.ellipsis,
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
            ),
          ),
        ],
      ),
    );
  }
}
