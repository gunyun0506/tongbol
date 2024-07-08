import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tongbokapp/constants.dart';
import 'package:tongbokapp/item_checkout_page.dart';

class ItemBasketPage extends StatefulWidget {
  final String categoryId;
  final int productNo;
  final String productName;
  final String productImageUrl;
  final double price;

  ItemBasketPage({
    Key? key,
    required this.price,
    required this.categoryId,
    required this.productNo,
    required this.productName,
    required this.productImageUrl,
  }) : super(key: key);

  @override
  State<ItemBasketPage> createState() => _ItemBasketPageState();
}

class _ItemBasketPageState extends State<ItemBasketPage> {
  double totalPrice = 0;
  Map<String, dynamic> cartMap = {};

  @override
  void initState() {
    super.initState();

    // Load the cart items from shared preferences
    try {
      cartMap =
          json.decode(sharedPreferences.getString("cartMap") ?? "{}") ?? {};
    } catch (e) {
      debugPrint(e.toString());
      cartMap = {};
    }

    // Calculate the total price
    totalPrice = calculateTotalPrice();
  }

  // Function to calculate the total price of items in the cart
  double calculateTotalPrice() {
    double total = 0;
    cartMap.forEach((key, value) {
      int quantity = value as int;
      total += widget.price * quantity;
    });
    return total;
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = calculateTotalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("장바구니"),
        centerTitle: true,
      ),
      body: cartMap.isEmpty
          ? const Center(
              child: Text("장바구니에 담긴 제품이 없습니다."),
            )
          : ListView.builder(
              itemCount: cartMap.length,
              itemBuilder: (context, index) {
                String productKey = cartMap.keys.toList()[index];
                int productQuantity = cartMap[productKey] as int;

                if (widget.productNo.toString() == productKey) {
                  return basketContainer(
                    productNo: widget.productNo,
                    productName: widget.productName,
                    productImageUrl: widget.productImageUrl,
                    price: widget.price,
                    quantity: productQuantity,
                  );
                }
                return Container();
              },
            ),
      bottomNavigationBar: FilledButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ItemCheckoutPage(
              productNos: cartMap.keys.map((e) => int.parse(e)).toList(),
              totalPrice: totalPrice,
              categoryId: widget.categoryId,
              productName: widget.productName,
              productImageUrl: widget.productImageUrl,
              price: widget.price,
            ),
          ));
        },
        child: Text("총 ${numberFormat.format(totalPrice)}원 결제하기"),
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
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            productImageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${numberFormat.format(price)}원"),
              Row(
                children: [
                  const Text("수량:"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          cartMap[productNo.toString()]--;
                          totalPrice -= price;
                        }
                        sharedPreferences.setString(
                          "cartMap",
                          json.encode(cartMap),
                        );
                        updateTotalPrice();
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text("$quantity"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        cartMap[productNo.toString()]++;
                        totalPrice += price;
                        sharedPreferences.setString(
                          "cartMap",
                          json.encode(cartMap),
                        );
                        updateTotalPrice();
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        totalPrice -= price * quantity;
                        cartMap.remove(productNo.toString());
                        sharedPreferences.setString(
                          "cartMap",
                          json.encode(cartMap),
                        );
                        updateTotalPrice();
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              Text("합계: ${numberFormat.format(price * quantity)}원"),
            ],
          ),
        ],
      ),
    );
  }
}
