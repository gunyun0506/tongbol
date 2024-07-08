import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  String? categoryId;

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
        categoryId = categorySnapshot.docs.first.id;

        QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
            .collection('categorys')
            .doc(categoryId)
            .collection('products')
            .get();

        setState(() {
          productList = productsSnapshot.docs.map((doc) {
            return Product.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();
        });

        if (productList.isEmpty) {
          print("No products found in the selected category.");
        } else {
          print("Products fetched successfully: ${productList.length}");
        }
      } else {
        print("No category document found for ${widget.searchCategory}");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
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
                  categoryId: categoryId!,
                  product: productList[index],
                );
              },
            ),
    );
  }

  Widget productContainer(
      {required String categoryId, required Product product}) {
    final numberFormat = NumberFormat('#,##0', 'ko_KR');
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ItemDetailsPage(
              categoryId: categoryId,
              productNo: product.productNo!,
              productName: product.productName!,
              productImageUrl: product.productImageUrl!,
              price: product.price!,
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
              imageUrl: product.productImageUrl!,
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
                product.productName!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text("${numberFormat.format(product.price)}원"),
            ),
          ],
        ),
      ),
    );
  }
}
