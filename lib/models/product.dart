class Product {
  int? productNo;

  String? productName;

  String? productDetails;

  String? productImageUrl;

  double? price;

  Product({
    this.productNo,
    this.productName,
    this.productDetails,
    this.productImageUrl,
    this.price,
  });

  Product.fromJson(Map<String, dynamic> json)
      : productNo = json['productNo'] as int?,
        productName = json['productName'] as String?,
        productDetails = json['productDetails'] as String?,
        productImageUrl = json['productImageUrl'] as String?,
        price = (json['price'] as num?)?.toDouble() ??
            0.0; // price가 없을 경우 기본값 0.0 설정

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['productNo'] = productNo;

    data['productName'] = productName;

    data['productDetails'] = productDetails;

    data['productImageUrl'] = productImageUrl;

    data['price'] = price;

    return data;
  }
}

final List<Map<String, dynamic>> restaurantList = [
  {
    "name": "구름계란덮밥 송탄점",
    "rating": 4.9,
    "orders": 100,
    "details": "제육덮밥, 계란덮밥, 치킨마요덮밥",
    //"deliveryTime": "35~50분",
    //"deliveryFee": "2,300~3,300원",
    "minOrder": "8,500원",
    "image": "assets/images/outback.png",
    //"coupon": "1,000원 쿠폰",
  },
  {
    "name": "후라이드참잘하는집 송탄점",
    "rating": 4.9,
    "orders": 100,
    "details": "제육덮밥, 계란덮밥, 치킨마요덮밥",
    //"deliveryTime": "35~50분",
    //"deliveryFee": "2,300~3,300원",
    "minOrder": "8,500원",
    "image": "assets/images/outback.png",
    //"coupon": "1,000원 쿠폰",
  },
  {
    "name": "뚝딱뚝닭강정",
    "rating": 4.9,
    "orders": 100,
    "details": "닭강정 매운맛, 닭강정 순한맛, 뚝닭 닭강정",
    //"deliveryTime": "35~50분",
    //"deliveryFee": "2,300~3,300원",
    "minOrder": "8,500원",
    "image": "assets/images/outback.png",
    //"coupon": "1,000원 쿠폰",
  },
  {
    "name": "60계\치킨 송탄점",
    "rating": 4.9,
    "orders": 100,
    "details": "간지치킨, 고추치킨, 크크크치킨",
    //"deliveryTime": "35~50분",
    //"deliveryFee": "2,300~3,300원",
    "minOrder": "10,000원",
    "image": "assets/images/outback.png",
    //"coupon": "1,000원 쿠폰",
  },
  {
    "name": "구름계란덮밥 송탄점",
    "rating": 4.9,
    "orders": 100,
    "details": "제육덮밥, 계란덮밥, 치킨마요덮밥",
    //"deliveryTime": "35~50분",
    //"deliveryFee": "2,300~3,300원",
    "minOrder": "8,500원",
    "image": "assets/images/outback.png",
    //"coupon": "1,000원 쿠폰",
  },
];
