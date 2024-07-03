import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // numberFormat을 위해 추가
import 'package:cached_network_image/cached_network_image.dart';
import 'item_details_page.dart';
import 'models/product.dart';

class ItemListPage extends StatefulWidget {
  final String searchCategory;

  ItemListPage({required this.searchCategory});

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categorys')
          .where('category', isEqualTo: widget.searchCategory)
          .get();

      if (categorySnapshot.docs.isNotEmpty) {
        String categoryId = categorySnapshot.docs.first.id;

        QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
            .collection('categorys')
            .doc(categoryId)
            .collection('products')
            .get();

        setState(() {
          productList = productsSnapshot.docs.map((doc) {
            return Product(
              productNo: doc['productNo'],
              productName: doc['productName'],
              productImageUrl: doc['productImageUrl'],
              price: doc['price'].toDouble(),
            );
          }).toList();
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchCategory),
        centerTitle: true,
      ),
      body: productList.isEmpty
          ? Center(child: Text("No products available"))
          : GridView.builder(
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
              price: price,
            );
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
