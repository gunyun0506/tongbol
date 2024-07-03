import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 추가
import 'package:tongbokapp/item_checkout_page.dart';
import 'package:tongbokapp/models/product.dart';
import 'package:tongbokapp/constants.dart';

class ItemBasketPage extends StatefulWidget {
  @override
  State<ItemBasketPage> createState() => _ItemBasketPageState();
}

class _ItemBasketPageState extends State<ItemBasketPage> {
  Map<String, dynamic> cartMap = {};
  List<int> productNos = [];
  List<Product> productList = []; // productList 추가

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      cartMap =
          json.decode(sharedPreferences.getString("cartMap") ?? "{}") ?? {};
      productNos = cartMap.keys.map((key) => int.parse(key)).toList();

      // 상품 목록 가져오기
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('productNo', whereIn: productNos)
          .get();

      setState(() {
        productList = snapshot.docs.map((doc) {
          return Product(
            productNo: doc['productNo'],
            productName: doc['productName'],
            productImageUrl: doc['productImageUrl'],
            price: doc['price'].toDouble(),
          );
        }).toList();
      });
    } catch (e) {
      debugPrint("Error fetching cart items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장바구니"),
        centerTitle: true,
      ),
      body: cartMap.isEmpty
          ? Center(child: Text("장바구니에 상품이 없습니다."))
          : FutureBuilder(
              future: fetchCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: productNos.length,
                    itemBuilder: (context, index) {
                      int productNo = productNos[index];
                      Product product = productList.firstWhere(
                        (prod) => prod.productNo == productNo,
                        orElse: () => Product(), // 예외 처리
                      );
                      return basketContainer(
                        productNo: product.productNo ?? 0,
                        productName: product.productName ?? "",
                        productImageUrl: product.productImageUrl ?? "",
                        price: product.price ?? 0,
                        quantity: cartMap[productNo.toString()] ?? 0,
                      );
                    },
                  );
                }
              },
            ),
      bottomNavigationBar: cartMap.isEmpty
          ? null
          : FutureBuilder(
              future: fetchCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  double totalPrice = calculateTotalPrice();
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ItemCheckoutPage(),
                        ));
                      },
                      child: Text("총 ${numberFormat.format(totalPrice)}원 결제하기"),
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget basketContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price,
    required int quantity,
  }) {
    final numberFormat = NumberFormat('#,##0', 'ko_KR');
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 130,
            fit: BoxFit.cover,
            imageUrl: productImageUrl,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) => Center(child: Text("오류 발생")),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  productName,
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("${numberFormat.format(price)}원"),
                Row(
                  children: [
                    Text("수량: "),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (cartMap[productNo.toString()] > 1) {
                            cartMap[productNo.toString()]--;
                            saveCartMap();
                          }
                        });
                      },
                    ),
                    Text("$quantity"),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          cartMap[productNo.toString()]++;
                          saveCartMap();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          cartMap.remove(productNo.toString());
                          saveCartMap();
                        });
                      },
                    ),
                  ],
                ),
                Text("합계: ${numberFormat.format(price * quantity)}원"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    productNos.forEach((productNo) {
      if (cartMap.containsKey(productNo.toString())) {
        totalPrice += cartMap[productNo.toString()] *
            productList
                .firstWhere((product) => product.productNo == productNo,
                    orElse: () => Product(price: 0))
                .price!;
      }
    });
    return totalPrice;
  }

  void saveCartMap() {
    sharedPreferences.setString("cartMap", json.encode(cartMap));
  }
}
