import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tongbokapp/constants.dart';
import 'package:tongbokapp/item_basket_page.dart';

class ItemDetailsPage extends StatefulWidget {
  final String categoryId;
  final int productNo;
  final String productName;
  final String productImageUrl;
  final double price;

  ItemDetailsPage({
    Key? key,
    required this.categoryId,
    required this.productNo,
    required this.productName,
    required this.productImageUrl,
    required this.price,
  }) : super(key: key);

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 상세 페이지"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productImageContainer(),
            productNameContainer(),
            productPriceContainer(),
            productQuantityContainer(),
            productTotalPriceContainer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: () {
            Map<String, dynamic> cartMap =
                json.decode(sharedPreferences.getString("cartMap") ?? "{}") ??
                    {};

            if (cartMap[widget.productNo.toString()] == null) {
              cartMap[widget.productNo.toString()] = quantity;
            } else {
              cartMap[widget.productNo.toString()] += quantity;
            }

            sharedPreferences.setString("cartMap", json.encode(cartMap));

            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ItemBasketPage(
                price: widget.price,
                categoryId: widget.categoryId,
                productNo: widget.productNo,
                productName: widget.productName,
                productImageUrl: widget.productImageUrl,
              );
            }));
          },
          child: const Text("장바구니 담기"),
        ),
      ),
    );
  }

  Widget productImageContainer() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      child: CachedNetworkImage(
        width: MediaQuery.of(context).size.width * 0.8,
        fit: BoxFit.cover,
        imageUrl: widget.productImageUrl,
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
    );
  }

  Widget productNameContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        widget.productName,
        textScaleFactor: 1.5,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget productPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "${numberFormat.format(widget.price)}원",
        textScaleFactor: 1.3,
      ),
    );
  }

  Widget productQuantityContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text("수량: "),
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       if (quantity > 1) {
          //         quantity--;
          //       }
          //     });
          //   },
          //   icon: const Icon(Icons.remove, size: 24),
          // ),
          // Text("$quantity"),
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       quantity++;
          //     });
          //   },
          //   icon: const Icon(Icons.add, size: 24),
          // ),
        ],
      ),
    );
  }

  Widget productTotalPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "총 상품금액: ",
            textScaleFactor: 1.3,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${numberFormat.format(widget.price * quantity)}원",
            textScaleFactor: 1.3,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
