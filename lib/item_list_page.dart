import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // numberFormat을 위해 추가
import 'package:tongbokapp/constants.dart';
import 'package:tongbokapp/item_details_page.dart';
import 'package:tongbokapp/models/product.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

List<Map<String, dynamic>> dataList = [
  {
    "category": "뚝딱뚝닭강정",
    "imgUrl": "https://i.ibb.co/GkY5xXZ/main-image.jpg",
  },
  {
    "category": "맘마",
    "imgUrl": "https://i.ibb.co/2KbN5pV/soup.jpg",
  },
  {
    "category": "한식",
    "imgUrl": "https://i.ibb.co/KXJD0rN/korean-meals.jpg",
  },
  {
    "category": "디저트",
    "imgUrl": "https://i.ibb.co/9Yn3t0w/tiramisu.jpg",
  },
  {
    "category": "피자",
    "imgUrl": "https://i.ibb.co/P9nKtt2/pizza.jpg",
  },
  {
    "category": "볶음밥",
    "imgUrl": "https://i.ibb.co/3svVzM1/shakshuka.jpg",
  },
];

Future<List<Product>> productsForCategory(String category) async {
  // 여기에 실제 데이터 로직을 구현해야 합니다.
  // 예시로, 뚝딱뚝닭강정 카테고리에 해당하는 제품을 반환하는 부분을 추가합니다.
  if (category == '뚝딱뚝닭강정') {
    return [
      Product(
          productNo: 1,
          productName: "노트북(Laptop)",
          productImageUrl: "https://picsum.photos/id/1/300/300",
          price: 600000),
      Product(
          productNo: 2,
          productName: "스마트폰(Phone)",
          productImageUrl: "https://picsum.photos/id/20/300/300",
          price: 500000),
    ];
  }
  // 다른 카테고리에 대한 로직도 추가할 수 있습니다.
  return [];
}

class _ItemListPageState extends State<ItemListPage> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    // 예시로 뚝딱뚝닭강정 카테고리의 제품을 불러옵니다.
    productsForCategory('뚝딱뚝닭강정').then((products) {
      setState(() {
        productList = products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 리스트"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: productList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.9, crossAxisCount: 2),
        itemBuilder: (context, index) {
          return productContainer(
            productNo: productList[index].productNo ?? 0,
            productName: productList[index].productName ?? "",
            productImageUrl: productList[index].productImageUrl ?? "",
            price: productList[index].price ?? 0,
          );
        },
      ),
    );
  }

  Widget productContainer(
      {required int productNo,
      required String productName,
      required String productImageUrl,
      required double price}) {
    final numberFormat = NumberFormat('#,##0', 'ko_KR'); // 숫자 포맷 정의
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ItemDetailsPage(
                productNo: productNo,
                productName: productName,
                productImageUrl: productImageUrl,
                price: price);
          },
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            CachedNetworkImage(
              height: 150,
              fit: BoxFit.cover,
              imageUrl: productImageUrl,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return const Center(
                  child: Text("오류 발생"),
                );
              },
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text("${numberFormat.format(price)}원"),
            ),
          ],
        ),
      ),
    );
  }
}
